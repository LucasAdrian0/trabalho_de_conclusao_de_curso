-- Complemento ao schema fornecido pelo projeto. Aplicar DEPOIS desse schema.
-- Não recria tabelas, não apaga contas e não importa senhas legadas para Auth.
begin;

-- Supabase Auth passa a cuidar de senha, confirmação e recuperação.
-- A coluna legada é mantida, mas não exposta à API.
alter table public.usuarios alter column senha_hash drop not null;

create or replace function public.sincronizar_usuario_auth()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.usuarios(id,tipo,nome,email,email_verificado)
  values (new.id, coalesce(new.raw_user_meta_data->>'tipo','cliente')::public.tipo_usuario,
    coalesce(nullif(new.raw_user_meta_data->>'nome',''),split_part(new.email,'@',1)),
    new.email, new.email_confirmed_at is not null)
  on conflict(id) do update set email=excluded.email,
    email_verificado=excluded.email_verificado;
  if exists(select 1 from public.usuarios where id=new.id and tipo='cliente') then
    insert into public.clientes(usuario_id) values(new.id) on conflict do nothing;
  end if;
  return new;
end $$;
revoke all on function public.sincronizar_usuario_auth() from public, anon, authenticated;
create trigger trg_usuario_auth after insert or update of email,email_confirmed_at on auth.users
for each row execute function public.sincronizar_usuario_auth();

-- Helpers de leitura evitam recursão entre políticas de tabelas relacionadas.
create function public.usuario_ativo() returns boolean
language sql stable security definer set search_path='' as $$
  select exists(select 1 from public.usuarios where id=auth.uid() and ativo)
$$;
create function public.pode_ver_solicitacao(p_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select public.usuario_ativo() and exists(
    select 1 from public.solicitacoes s where s.id=p_id and (
      s.cliente_id=auth.uid()
      or exists(select 1 from public.orcamentos o where o.solicitacao_id=s.id and o.prestador_id=auth.uid())
      or exists(select 1 from public.servicos v where v.solicitacao_id=s.id and v.prestador_id=auth.uid())
      or (s.status='aguardando_prestador' and exists(
        select 1 from public.prestadores p join public.regioes_atendimento r on r.prestador_id=p.usuario_id
        join public.enderecos e on e.id=s.endereco_origem_id
        where p.usuario_id=auth.uid() and p.status_disponibilidade='disponivel'
        and r.cidade=e.cidade and r.estado=e.estado))
    ))
$$;
create function public.pode_ver_servico(p_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select public.usuario_ativo() and exists(select 1 from public.servicos
    where id=p_id and auth.uid() in (cliente_id,prestador_id))
$$;
create function public.pode_ver_usuario(p_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
  select public.usuario_ativo() and (p_id=auth.uid()
    or exists(select 1 from public.prestadores where usuario_id=p_id)
    or exists(select 1 from public.solicitacoes s where s.cliente_id=p_id and public.pode_ver_solicitacao(s.id)))
$$;
revoke all on function public.usuario_ativo(), public.pode_ver_solicitacao(uuid),
 public.pode_ver_servico(uuid), public.pode_ver_usuario(uuid) from public,anon;
grant execute on function public.usuario_ativo(), public.pode_ver_solicitacao(uuid),
 public.pode_ver_servico(uuid), public.pode_ver_usuario(uuid) to authenticated;

do $$ declare t text; begin
  foreach t in array array['usuarios','recuperacoes_senha','clientes','prestadores','regioes_atendimento',
    'enderecos','veiculos','ajudantes_prestador','solicitacoes','itens_solicitacao','orcamentos',
    'servicos','pagamentos','avaliacoes','notificacoes','historico_status_servico'] loop
    execute format('alter table public.%I enable row level security',t);
    execute format('revoke all on public.%I from anon,authenticated',t);
  end loop;
end $$;
grant usage on schema public to authenticated;
grant select(id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at),
 update(nome,telefone,foto_url,ativo) on public.usuarios to authenticated;
create policy usuario_leitura on public.usuarios for select to authenticated using(public.pode_ver_usuario(id));
create policy usuario_edicao on public.usuarios for update to authenticated
 using(id=auth.uid() and public.usuario_ativo()) with check(id=auth.uid());

grant select,insert,update on public.clientes to authenticated;
create policy cliente_proprio on public.clientes for all to authenticated
 using(usuario_id=auth.uid() and public.usuario_ativo())
 with check(usuario_id=auth.uid() and exists(select 1 from public.usuarios where id=auth.uid() and tipo='cliente'));

grant select on public.prestadores to authenticated;
grant insert(usuario_id,cpf_cnpj,status_disponibilidade),update(cpf_cnpj,status_disponibilidade) on public.prestadores to authenticated;
create policy prestador_leitura on public.prestadores for select to authenticated using(public.usuario_ativo());
create policy prestador_criacao on public.prestadores for insert to authenticated
 with check(usuario_id=auth.uid() and exists(select 1 from public.usuarios where id=auth.uid() and tipo='prestador' and ativo));
create policy prestador_edicao on public.prestadores for update to authenticated
 using(usuario_id=auth.uid() and public.usuario_ativo()) with check(usuario_id=auth.uid());

grant select,insert,update,delete on public.regioes_atendimento,public.veiculos,public.ajudantes_prestador to authenticated;
do $$ declare t text; begin
 foreach t in array array['regioes_atendimento','veiculos','ajudantes_prestador'] loop
  execute format('create policy leitura on public.%I for select to authenticated using(public.usuario_ativo())',t);
  execute format('create policy escrita on public.%I for all to authenticated using(prestador_id=auth.uid() and public.usuario_ativo()) with check(prestador_id=auth.uid() and public.usuario_ativo())',t);
 end loop;
end $$;

grant select,insert,update,delete on public.enderecos to authenticated;
create policy endereco_leitura on public.enderecos for select to authenticated using(
 usuario_id=auth.uid() or exists(select 1 from public.solicitacoes s
 where enderecos.id in (s.endereco_origem_id,s.endereco_destino_id) and public.pode_ver_solicitacao(s.id)));
create policy endereco_escrita on public.enderecos for all to authenticated
 using(usuario_id=auth.uid() and public.usuario_ativo()) with check(usuario_id=auth.uid() and public.usuario_ativo());
grant select,insert on public.solicitacoes,public.itens_solicitacao to authenticated;
create policy solicitacao_leitura on public.solicitacoes for select to authenticated using(public.pode_ver_solicitacao(id));
create policy solicitacao_criacao on public.solicitacoes for insert to authenticated
 with check(cliente_id=auth.uid() and public.usuario_ativo() and status in ('criada','aguardando_prestador')
 and exists(select 1 from public.enderecos e where e.id=endereco_origem_id and e.usuario_id=auth.uid())
 and exists(select 1 from public.enderecos e where e.id=endereco_destino_id and e.usuario_id=auth.uid()));
create policy solicitacao_edicao on public.solicitacoes for update to authenticated
 using(cliente_id=auth.uid() and public.usuario_ativo()) with check(cliente_id=auth.uid() and status in ('criada','aguardando_prestador','cancelada_pelo_cliente'));
create policy item_leitura on public.itens_solicitacao for select to authenticated using(public.pode_ver_solicitacao(solicitacao_id));
create policy item_criacao on public.itens_solicitacao for insert to authenticated
 with check(exists(select 1 from public.solicitacoes s where s.id=solicitacao_id and s.cliente_id=auth.uid() and s.status in ('criada','aguardando_prestador')));

grant select,insert on public.orcamentos to authenticated;
grant update(status,updated_at) on public.orcamentos to authenticated;
create policy orcamento_leitura on public.orcamentos for select to authenticated using(public.usuario_ativo() and
 (prestador_id=auth.uid() or exists(select 1 from public.solicitacoes s where s.id=solicitacao_id and s.cliente_id=auth.uid())));
create policy orcamento_criacao on public.orcamentos for insert to authenticated with check(
 prestador_id=auth.uid() and status='pendente' and public.pode_ver_solicitacao(solicitacao_id)
 and exists(select 1 from public.solicitacoes s where s.id=solicitacao_id and s.status='aguardando_prestador')
 and exists(select 1 from public.veiculos v where v.id=veiculo_id and v.prestador_id=auth.uid() and v.status='ativo'));
create policy orcamento_edicao on public.orcamentos for update to authenticated
 using(prestador_id=auth.uid() and status='pendente') with check(prestador_id=auth.uid() and status in ('recusado','expirado'));

grant select on public.servicos,public.historico_status_servico,public.pagamentos to authenticated;
create policy servico_leitura on public.servicos for select to authenticated using(public.pode_ver_servico(id));
create policy historico_leitura on public.historico_status_servico for select to authenticated using(public.pode_ver_servico(servico_id));
create policy pagamento_leitura on public.pagamentos for select to authenticated using(public.pode_ver_servico(servico_id));
-- Confirmação de pagamento e notificações de outros usuários são operações do backend.
grant select,insert on public.avaliacoes to authenticated;
create policy avaliacao_leitura on public.avaliacoes for select to authenticated using(public.usuario_ativo());
create policy avaliacao_criacao on public.avaliacoes for insert to authenticated with check(
 cliente_id=auth.uid() and exists(select 1 from public.servicos s where s.id=servico_id
 and s.cliente_id=auth.uid() and s.prestador_id=avaliacoes.prestador_id and s.status='concluido'));
grant select on public.notificacoes to authenticated;
grant update(lida,lida_em) on public.notificacoes to authenticated;
create policy notificacao_propria on public.notificacoes for all to authenticated
 using(usuario_id=auth.uid() and public.usuario_ativo()) with check(usuario_id=auth.uid());

-- Uma mudança de status e seu histórico pertencem à mesma transação.
create function public.atualizar_status_servico(p_servico_id uuid,p_status public.status_servico,p_observacao text default null)
returns void language plpgsql security definer set search_path='' as $$
declare s public.servicos;
begin
 select * into strict s from public.servicos where id=p_servico_id for update;
 if not public.pode_ver_servico(s.id) then raise exception 'Serviço não autorizado'; end if;
 if s.status=p_status then return; end if;
 if not (
   (auth.uid()=s.prestador_id and (
     (s.status='agendado' and p_status in ('prestador_a_caminho','em_andamento','cancelado_pelo_prestador')) or
     (s.status='prestador_a_caminho' and p_status in ('em_andamento','cancelado_pelo_prestador')) or
     (s.status='em_andamento' and p_status='concluido')))
   or (auth.uid()=s.cliente_id and s.status in ('agendado','prestador_a_caminho') and p_status='cancelado_pelo_cliente')
 ) then raise exception 'Transição de status não permitida'; end if;
 update public.servicos set status=p_status,
 iniciado_em=case when p_status='em_andamento' then now() else iniciado_em end,
 concluido_em=case when p_status='concluido' then now() else concluido_em end where id=s.id;
 insert into public.historico_status_servico(servico_id,status_anterior,status_novo,alterado_por,observacao)
 values(s.id,s.status,p_status,auth.uid(),p_observacao);
 if p_status='concluido' then
  update public.prestadores set total_servicos_concluidos=total_servicos_concluidos+1 where usuario_id=s.prestador_id;
 end if;
end $$;
revoke all on function public.atualizar_status_servico(uuid,public.status_servico,text) from public,anon;
grant execute on function public.atualizar_status_servico(uuid,public.status_servico,text) to authenticated;

-- Validações também no banco. NOT VALID preserva linhas legadas, validando novas escritas.
alter table public.itens_solicitacao add constraint item_quantidade_positiva check(quantidade>0) not valid;
alter table public.ajudantes_prestador add constraint ajudantes_valores_validos check(quantidade_disponivel>=0 and valor_por_ajudante>=0) not valid;
alter table public.veiculos add constraint veiculo_valores_validos check(valor_km>=0 and capacidade_kg>=0 and largura_m>=0 and altura_m>=0 and comprimento_m>=0) not valid;
alter table public.solicitacoes add constraint solicitacao_valores_validos check(quantidade_ajudantes>=0 and volume_estimado_m3>=0 and distancia_km>=0 and duracao_estimada_min>=0) not valid;
alter table public.orcamentos add constraint orcamento_valores_validos check(valor_km_aplicado>=0 and valor_transporte>=0 and quantidade_ajudantes>=0 and valor_ajudantes>=0 and valor_total_estimado=valor_transporte+valor_ajudantes) not valid;


create function public.criar_solicitacao_com_itens(p_solicitacao jsonb,p_origem jsonb,p_destino jsonb,p_itens jsonb)
returns void language plpgsql security invoker set search_path='' as $$
declare item jsonb;
begin
 if auth.uid() is null or (p_solicitacao->>'cliente_id')::uuid is distinct from auth.uid() then
  raise exception 'Cliente não autorizado';
 end if;
 if p_solicitacao->>'endereco_origem_id' is distinct from p_origem->>'id'
 or p_solicitacao->>'endereco_destino_id' is distinct from p_destino->>'id' then
  raise exception 'Endereços não correspondem à solicitação';
 end if;
 if (p_origem->>'usuario_id' is not null and (p_origem->>'usuario_id')::uuid<>auth.uid())
 or (p_destino->>'usuario_id' is not null and (p_destino->>'usuario_id')::uuid<>auth.uid()) then
  raise exception 'Endereço de outro usuário';
 end if;
 p_origem := p_origem || jsonb_build_object('usuario_id',auth.uid());
 p_destino := p_destino || jsonb_build_object('usuario_id',auth.uid());
insert into public.enderecos(id,usuario_id,tipo,cep,logradouro,numero,complemento,bairro,cidade,estado,latitude,longitude,tem_elevador,andar) select r.id,r.usuario_id,r.tipo,r.cep,r.logradouro,r.numero,r.complemento,r.bairro,r.cidade,r.estado,r.latitude,r.longitude,r.tem_elevador,r.andar from jsonb_populate_record(null::public.enderecos,p_origem) r on conflict(id) do update set usuario_id=excluded.usuario_id,tipo=excluded.tipo,cep=excluded.cep,logradouro=excluded.logradouro,numero=excluded.numero,complemento=excluded.complemento,bairro=excluded.bairro,cidade=excluded.cidade,estado=excluded.estado,latitude=excluded.latitude,longitude=excluded.longitude,tem_elevador=excluded.tem_elevador,andar=excluded.andar;
insert into public.enderecos(id,usuario_id,tipo,cep,logradouro,numero,complemento,bairro,cidade,estado,latitude,longitude,tem_elevador,andar) select r.id,r.usuario_id,r.tipo,r.cep,r.logradouro,r.numero,r.complemento,r.bairro,r.cidade,r.estado,r.latitude,r.longitude,r.tem_elevador,r.andar from jsonb_populate_record(null::public.enderecos,p_destino) r on conflict(id) do update set usuario_id=excluded.usuario_id,tipo=excluded.tipo,cep=excluded.cep,logradouro=excluded.logradouro,numero=excluded.numero,complemento=excluded.complemento,bairro=excluded.bairro,cidade=excluded.cidade,estado=excluded.estado,latitude=excluded.latitude,longitude=excluded.longitude,tem_elevador=excluded.tem_elevador,andar=excluded.andar;
insert into public.solicitacoes(id,cliente_id,endereco_origem_id,endereco_destino_id,data_desejada,horario_desejado,tipo_servico,volume_estimado_m3,necessita_ajudantes,quantidade_ajudantes,distancia_km,duracao_estimada_min,status,observacoes) select r.id,r.cliente_id,r.endereco_origem_id,r.endereco_destino_id,r.data_desejada,r.horario_desejado,r.tipo_servico,r.volume_estimado_m3,r.necessita_ajudantes,r.quantidade_ajudantes,r.distancia_km,r.duracao_estimada_min,r.status,r.observacoes from jsonb_populate_record(null::public.solicitacoes,p_solicitacao) r;

 for item in select value from jsonb_array_elements(p_itens) loop
  if item->>'solicitacao_id' is distinct from p_solicitacao->>'id' then
   raise exception 'Item de outra solicitação';
  end if;
insert into public.itens_solicitacao(id,solicitacao_id,nome,categoria,quantidade,fragil,observacoes) select r.id,r.solicitacao_id,r.nome,r.categoria,r.quantidade,r.fragil,r.observacoes from jsonb_populate_record(null::public.itens_solicitacao,item) r;
 end loop;
end $$;

create function public.salvar_prestador_com_relacoes(p_prestador jsonb,p_criar boolean,p_regioes jsonb,p_veiculos jsonb,p_ajudantes jsonb default null)
returns void language plpgsql security invoker set search_path='' as $$
declare item jsonb;
begin
 if auth.uid() is null or (p_prestador->>'usuario_id')::uuid is distinct from auth.uid() then
  raise exception 'Prestador não autorizado';
 end if;
 if p_criar then
insert into public.prestadores(usuario_id,cpf_cnpj,status_disponibilidade) select r.usuario_id,r.cpf_cnpj,r.status_disponibilidade from jsonb_populate_record(null::public.prestadores,p_prestador) r;

 else
  update public.prestadores set cpf_cnpj=p_prestador->>'cpf_cnpj',
   status_disponibilidade=(p_prestador->>'status_disponibilidade')::public.status_disponibilidade
   where usuario_id=auth.uid();
  if not found then raise exception 'Prestador não encontrado'; end if;
 end if;
 for item in select value from jsonb_array_elements(p_regioes) loop
  if (item->>'prestador_id')::uuid is distinct from auth.uid() then raise exception 'Região de outro prestador'; end if;
insert into public.regioes_atendimento(id,prestador_id,cidade,estado,raio_km) select r.id,r.prestador_id,r.cidade,r.estado,r.raio_km from jsonb_populate_record(null::public.regioes_atendimento,item) r on conflict(id) do update set prestador_id=excluded.prestador_id,cidade=excluded.cidade,estado=excluded.estado,raio_km=excluded.raio_km;
 end loop;
 for item in select value from jsonb_array_elements(p_veiculos) loop
 if (item->>'prestador_id')::uuid is distinct from auth.uid() then raise exception 'Veículo de outro prestador'; end if;
insert into public.veiculos(id,prestador_id,tipo,marca,modelo,ano,capacidade_kg,largura_m,altura_m,comprimento_m,valor_km,status,foto_url) select r.id,r.prestador_id,r.tipo,r.marca,r.modelo,r.ano,r.capacidade_kg,r.largura_m,r.altura_m,r.comprimento_m,r.valor_km,r.status,r.foto_url from jsonb_populate_record(null::public.veiculos,item) r on conflict(id) do update set prestador_id=excluded.prestador_id,tipo=excluded.tipo,marca=excluded.marca,modelo=excluded.modelo,ano=excluded.ano,capacidade_kg=excluded.capacidade_kg,largura_m=excluded.largura_m,altura_m=excluded.altura_m,comprimento_m=excluded.comprimento_m,valor_km=excluded.valor_km,status=excluded.status,foto_url=excluded.foto_url;
 end loop;
 if p_ajudantes is not null and p_ajudantes <> 'null'::jsonb then
 if (p_ajudantes->>'prestador_id')::uuid is distinct from auth.uid() then raise exception 'Ajudantes de outro prestador'; end if;
insert into public.ajudantes_prestador(prestador_id,oferece_ajudantes,quantidade_disponivel,valor_por_ajudante) select r.prestador_id,r.oferece_ajudantes,r.quantidade_disponivel,r.valor_por_ajudante from jsonb_populate_record(null::public.ajudantes_prestador,p_ajudantes) r on conflict(prestador_id) do update set oferece_ajudantes=excluded.oferece_ajudantes,quantidade_disponivel=excluded.quantidade_disponivel,valor_por_ajudante=excluded.valor_por_ajudante;
 end if;
end $$;

revoke all on function public.criar_solicitacao_com_itens(jsonb,jsonb,jsonb,jsonb),
 public.salvar_prestador_com_relacoes(jsonb,boolean,jsonb,jsonb,jsonb) from public,anon;
grant execute on function public.criar_solicitacao_com_itens(jsonb,jsonb,jsonb,jsonb),
 public.salvar_prestador_com_relacoes(jsonb,boolean,jsonb,jsonb,jsonb) to authenticated;

-- O bloqueio da solicitação serializa aceites concorrentes.
create function public.aceitar_orcamento(p_orcamento_id uuid)
returns jsonb language plpgsql security definer set search_path='' as $$
declare o public.orcamentos; s public.solicitacoes; v public.servicos;
begin
 select * into strict o from public.orcamentos where id=p_orcamento_id;
 select * into strict s from public.solicitacoes where id=o.solicitacao_id for update;
 select * into strict o from public.orcamentos where id=p_orcamento_id for update;
 if auth.uid() is distinct from s.cliente_id or not public.usuario_ativo() then raise exception 'Cliente não autorizado'; end if;
 -- Repetir a mesma solicitação é seguro após uma resposta perdida na rede.
 select * into v from public.servicos where orcamento_id=o.id;
 if found then return to_jsonb(v); end if;
 if s.status<>'aguardando_prestador' or o.status<>'pendente' or (o.expira_em is not null and o.expira_em<=now())
 or exists(select 1 from public.servicos where solicitacao_id=s.id) then
  raise exception 'Orçamento indisponível para aceite';
 end if;
 perform 1 from public.veiculos where id=o.veiculo_id and prestador_id=o.prestador_id and status='ativo' for update;
 if not found then raise exception 'Veículo indisponível'; end if;
 update public.orcamentos set status=case when id=o.id then 'aceito'::public.status_orcamento else 'recusado'::public.status_orcamento end
 where solicitacao_id=s.id and status='pendente';
 update public.solicitacoes set status='prestador_selecionado' where id=s.id;
 insert into public.servicos(solicitacao_id,orcamento_id,cliente_id,prestador_id,veiculo_id,valor_total,data_agendada,horario_agendado)
 values(s.id,o.id,s.cliente_id,o.prestador_id,o.veiculo_id,o.valor_total_estimado,s.data_desejada,s.horario_desejado)
 returning * into v;
 insert into public.historico_status_servico(servico_id,status_anterior,status_novo,alterado_por)
 values(v.id,null,'agendado',auth.uid());
 return to_jsonb(v);
end $$;
revoke all on function public.aceitar_orcamento(uuid) from public,anon;
grant execute on function public.aceitar_orcamento(uuid) to authenticated;

create function public.recalcular_avaliacao_prestador()
returns trigger language plpgsql security definer set search_path='' as $$
begin
 perform 1 from public.prestadores where usuario_id=new.prestador_id for update;
 update public.prestadores set
  avaliacao_media=(select avg(nota) from public.avaliacoes where prestador_id=new.prestador_id),
  total_avaliacoes=(select count(*) from public.avaliacoes where prestador_id=new.prestador_id)
 where usuario_id=new.prestador_id;
 return new;
end $$;
revoke all on function public.recalcular_avaliacao_prestador() from public,anon,authenticated;
create trigger trg_avaliacao_prestador after insert on public.avaliacoes
 for each row execute function public.recalcular_avaliacao_prestador();

create function public.atualizar_status_solicitacao(p_solicitacao_id uuid,p_status public.status_solicitacao)
returns void language plpgsql security definer set search_path='' as $$
declare s public.solicitacoes;
begin
 select * into strict s from public.solicitacoes where id=p_solicitacao_id for update;
 if s.cliente_id is distinct from auth.uid() or not public.usuario_ativo() then raise exception 'Cliente não autorizado'; end if;
 if s.status=p_status then return; end if;
 if not ((s.status='criada' and p_status in ('aguardando_prestador','cancelada_pelo_cliente'))
 or (s.status='aguardando_prestador' and p_status='cancelada_pelo_cliente')) then
  raise exception 'Transição de solicitação não permitida';
 end if;
 update public.solicitacoes set status=p_status where id=s.id;
 if p_status='cancelada_pelo_cliente' then
  update public.orcamentos set status='recusado' where solicitacao_id=s.id and status='pendente';
 end if;
end $$;
revoke all on function public.atualizar_status_solicitacao(uuid,public.status_solicitacao) from public,anon;
grant execute on function public.atualizar_status_solicitacao(uuid,public.status_solicitacao) to authenticated;

commit;
