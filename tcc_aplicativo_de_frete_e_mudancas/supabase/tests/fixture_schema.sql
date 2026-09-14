-- Fixture de teste local baseada no SQL fornecido pelo usuário.
-- SOMENTE em uma instância PostgreSQL descartável; não aplicar no Supabase.
do $$ begin if not exists(select 1 from pg_roles where rolname='anon') then create role anon; end if; end $$;
do $$ begin if not exists(select 1 from pg_roles where rolname='authenticated') then create role authenticated; end if; end $$;
do $$ begin if not exists(select 1 from pg_roles where rolname='service_role') then create role service_role bypassrls; end if; end $$;
create schema auth;
create table auth.users(id uuid primary key,email text,email_confirmed_at timestamptz,raw_user_meta_data jsonb default '{}');
create function auth.uid() returns uuid language sql stable as $$
 select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid
$$;
grant usage on schema auth to authenticated;
grant execute on function auth.uid() to authenticated;
create type tipo_usuario as enum ('cliente','prestador');
create type tipo_endereco as enum ('origem','destino','cadastro');
create type tipo_veiculo as enum ('motocicleta','utilitario','fiorino','saveiro','strada','van','caminhao_3_4','vuc','outros');
create type status_veiculo as enum ('ativo','inativo','em_manutencao');
create type status_disponibilidade as enum ('disponivel','indisponivel');
create type tipo_servico_solicitado as enum ('mudanca_residencial','mudanca_comercial','frete_pequeno','outros');
create type status_solicitacao as enum ('criada','aguardando_prestador','prestador_selecionado','cancelada_pelo_cliente','expirada');
create type status_orcamento as enum ('pendente','aceito','recusado','expirado');
create type status_servico as enum ('agendado','prestador_a_caminho','em_andamento','concluido','cancelado_pelo_prestador','cancelado_pelo_cliente');
create type metodo_pagamento as enum ('pix','cartao_credito','cartao_debito');
create type status_pagamento as enum ('pendente','aprovado','recusado','cancelado','reembolsado');
create type tipo_notificacao as enum ('nova_solicitacao','orcamento_recebido','orcamento_aceito','status_servico','pagamento','avaliacao','sistema');
create table usuarios(
 id uuid primary key default gen_random_uuid(),
 tipo tipo_usuario not null,
 nome varchar(150) not null,
 email varchar(150) not null unique,
 senha_hash varchar(255) not null,
 telefone varchar(20),
 foto_url text,
 email_verificado boolean not null default false,
 ativo boolean not null default true,
 ultimo_login_em timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table recuperacoes_senha(
 id uuid primary key default gen_random_uuid(),
 usuario_id uuid not null references usuarios(id) on delete cascade,
 token_hash varchar(255) not null,
 expira_em timestamptz not null,
 usado_em timestamptz,
 created_at timestamptz not null default now()
);
create table clientes(
 usuario_id uuid primary key references usuarios(id) on delete cascade,
 cpf varchar(14) unique,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table prestadores(
 usuario_id uuid primary key references usuarios(id) on delete cascade,
 cpf_cnpj varchar(18) unique,
 status_disponibilidade status_disponibilidade not null default 'indisponivel',
 avaliacao_media numeric(3,
 2) not null default 0,
 total_avaliacoes integer not null default 0,
 total_servicos_concluidos integer not null default 0,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table regioes_atendimento(
 id uuid primary key default gen_random_uuid(),
 prestador_id uuid not null references prestadores(usuario_id) on delete cascade,
 cidade varchar(100) not null,
 estado char(2) not null,
 raio_km numeric(6,
 2),
 created_at timestamptz not null default now()
);
create table enderecos(
 id uuid primary key default gen_random_uuid(),
 usuario_id uuid references usuarios(id) on delete cascade,
 tipo tipo_endereco not null default 'cadastro',
 cep varchar(9),
 logradouro varchar(200) not null,
 numero varchar(20),
 complemento varchar(100),
 bairro varchar(100),
 cidade varchar(100) not null,
 estado char(2) not null,
 latitude double precision,
 longitude double precision,
 tem_elevador boolean,
 andar integer,
 created_at timestamptz not null default now()
);
create table veiculos(
 id uuid primary key default gen_random_uuid(),
 prestador_id uuid not null references prestadores(usuario_id) on delete cascade,
 tipo tipo_veiculo not null,
 marca varchar(60),
 modelo varchar(60),
 ano smallint,
 capacidade_kg numeric(8,
 2),
 largura_m numeric(5,
 2),
 altura_m numeric(5,
 2),
 comprimento_m numeric(5,
 2),
 valor_km numeric(10,
 2) not null,
 status status_veiculo not null default 'ativo',
 foto_url text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table ajudantes_prestador(
 prestador_id uuid primary key references prestadores(usuario_id) on delete cascade,
 oferece_ajudantes boolean not null default false,
 quantidade_disponivel smallint not null default 0,
 valor_por_ajudante numeric(10,
 2) not null default 0,
 updated_at timestamptz not null default now()
);
create table solicitacoes(
 id uuid primary key default gen_random_uuid(),
 cliente_id uuid not null references clientes(usuario_id) on delete restrict,
 endereco_origem_id uuid not null references enderecos(id) on delete restrict,
 endereco_destino_id uuid not null references enderecos(id) on delete restrict,
 data_desejada date not null,
 horario_desejado time,
 tipo_servico tipo_servico_solicitado not null,
 volume_estimado_m3 numeric(8,
 2),
 necessita_ajudantes boolean not null default false,
 quantidade_ajudantes smallint not null default 0,
 distancia_km numeric(8,
 2),
 duracao_estimada_min integer,
 status status_solicitacao not null default 'criada',
 observacoes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table itens_solicitacao(
 id uuid primary key default gen_random_uuid(),
 solicitacao_id uuid not null references solicitacoes(id) on delete cascade,
 nome varchar(150) not null,
 categoria varchar(60),
 quantidade integer not null default 1,
 fragil boolean not null default false,
 observacoes text
);
create table orcamentos(
 id uuid primary key default gen_random_uuid(),
 solicitacao_id uuid not null references solicitacoes(id) on delete cascade,
 prestador_id uuid not null references prestadores(usuario_id) on delete cascade,
 veiculo_id uuid not null references veiculos(id) on delete restrict,
 distancia_prestador_origem_km numeric(8,
 2),
 valor_km_aplicado numeric(10,
 2) not null,
 valor_transporte numeric(10,
 2) not null,
 quantidade_ajudantes smallint not null default 0,
 valor_ajudantes numeric(10,
 2) not null default 0,
 valor_total_estimado numeric(10,
 2) not null,
 tempo_estimado_min integer,
 status status_orcamento not null default 'pendente',
 expira_em timestamptz,
 unique(solicitacao_id,
 prestador_id,
 veiculo_id),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table servicos(
 id uuid primary key default gen_random_uuid(),
 solicitacao_id uuid not null references solicitacoes(id) on delete restrict,
 orcamento_id uuid not null unique references orcamentos(id) on delete restrict,
 cliente_id uuid not null references clientes(usuario_id) on delete restrict,
 prestador_id uuid not null references prestadores(usuario_id) on delete restrict,
 veiculo_id uuid not null references veiculos(id) on delete restrict,
 valor_total numeric(10,
 2) not null,
 status status_servico not null default 'agendado',
 data_agendada date not null,
 horario_agendado time,
 iniciado_em timestamptz,
 concluido_em timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table pagamentos(
 id uuid primary key default gen_random_uuid(),
 servico_id uuid not null references servicos(id) on delete restrict,
 metodo metodo_pagamento not null,
 valor numeric(10,
 2) not null,
 status status_pagamento not null default 'pendente',
 gateway varchar(50),
 gateway_transacao_id varchar(150),
 cartao_ultimos_digitos varchar(4),
 aprovado_em timestamptz,
 recusado_em timestamptz,
 reembolsado_em timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table avaliacoes(
 id uuid primary key default gen_random_uuid(),
 servico_id uuid not null unique references servicos(id) on delete cascade,
 cliente_id uuid not null references clientes(usuario_id) on delete cascade,
 prestador_id uuid not null references prestadores(usuario_id) on delete cascade,
 nota smallint not null check(nota between 1 and 5),
 comentario text,
 created_at timestamptz not null default now()
);
create table notificacoes(
 id uuid primary key default gen_random_uuid(),
 usuario_id uuid not null references usuarios(id) on delete cascade,
 tipo tipo_notificacao not null,
 titulo varchar(150) not null,
 mensagem text not null,
 referencia_id uuid,
 lida boolean not null default false,
 lida_em timestamptz,
 created_at timestamptz not null default now()
);
create table historico_status_servico(
 id uuid primary key default gen_random_uuid(),
 servico_id uuid not null references servicos(id) on delete cascade,
 status_anterior status_servico,
 status_novo status_servico not null,
 alterado_por uuid references usuarios(id) on delete set null,
 observacao text,
 created_at timestamptz not null default now()
);
create function set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end $$;
create trigger trg_set_updated_at before update on usuarios for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on clientes for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on prestadores for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on veiculos for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on ajudantes_prestador for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on solicitacoes for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on orcamentos for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on servicos for each row execute function set_updated_at();
create trigger trg_set_updated_at before update on pagamentos for each row execute function set_updated_at();
