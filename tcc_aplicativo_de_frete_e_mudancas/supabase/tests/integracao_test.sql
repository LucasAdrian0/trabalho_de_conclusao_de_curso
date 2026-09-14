-- Executar após fixture_schema.sql e a migration, somente em banco descartável.
\set ON_ERROR_STOP on
begin;
insert into auth.users(id,email,email_confirmed_at,raw_user_meta_data) values
 ('00000000-0000-0000-0000-000000000001','cliente@example.com',now(),'{"tipo":"cliente","nome":"Cliente"}'),
 ('00000000-0000-0000-0000-000000000002','prestador@example.com',now(),'{"tipo":"prestador","nome":"Prestador"}'),
 ('00000000-0000-0000-0000-000000000003','outro@example.com',now(),'{"tipo":"cliente","nome":"Outro"}');
set local role authenticated;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
select public.salvar_prestador_com_relacoes(
 '{"usuario_id":"00000000-0000-0000-0000-000000000002","cpf_cnpj":"12345678901","status_disponibilidade":"disponivel"}',true,
 '[{"id":"10000000-0000-0000-0000-000000000001","prestador_id":"00000000-0000-0000-0000-000000000002","cidade":"Ourinhos","estado":"SP","raio_km":10}]',
 '[{"id":"20000000-0000-0000-0000-000000000001","prestador_id":"00000000-0000-0000-0000-000000000002","tipo":"fiorino","valor_km":5,"status":"ativo"}]',
 '{"prestador_id":"00000000-0000-0000-0000-000000000002","oferece_ajudantes":true,"quantidade_disponivel":1,"valor_por_ajudante":50}');
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
do $$
declare
 pedido jsonb := '{"id":"30000000-0000-0000-0000-000000000001","cliente_id":"00000000-0000-0000-0000-000000000001","endereco_origem_id":"40000000-0000-0000-0000-000000000001","endereco_destino_id":"40000000-0000-0000-0000-000000000002","data_desejada":"2026-10-01","tipo_servico":"frete_pequeno","status":"aguardando_prestador","necessita_ajudantes":false,"quantidade_ajudantes":0}';
 origem jsonb := '{"id":"40000000-0000-0000-0000-000000000001","tipo":"origem","logradouro":"Rua A","cidade":"Ourinhos","estado":"SP"}';
 destino jsonb := '{"id":"40000000-0000-0000-0000-000000000002","tipo":"destino","logradouro":"Rua B","cidade":"Ourinhos","estado":"SP"}';
 itens jsonb := '[{"id":"50000000-0000-0000-0000-000000000001","solicitacao_id":"30000000-0000-0000-0000-000000000001","nome":"Caixa","quantidade":-1,"fragil":false}]';
begin
 begin
  perform public.criar_solicitacao_com_itens(pedido,origem,destino,itens);
  raise exception 'TESTE: deveria rejeitar quantidade negativa';
 exception when check_violation then null;
 end;
 if exists(select 1 from public.enderecos) or exists(select 1 from public.solicitacoes) then
  raise exception 'TESTE: falha não reverteu a transação';
 end if;
 itens := jsonb_set(itens,'{0,quantidade}','1');
 perform public.criar_solicitacao_com_itens(pedido,origem,destino,itens);
 if (select count(*) from public.itens_solicitacao)<>1 then raise exception 'TESTE: item não persistido'; end if;
end $$;

select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',true);
do $$ begin
 if exists(select 1 from public.solicitacoes) or exists(select 1 from public.enderecos) then
  raise exception 'TESTE: outro cliente consegue acessar a solicitação';
 end if;
 begin
  perform senha_hash from public.usuarios;
  raise exception 'TESTE: hash legado exposto';
 exception when insufficient_privilege then null;
 end;
end $$;

select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
insert into public.orcamentos(id,solicitacao_id,prestador_id,veiculo_id,valor_km_aplicado,valor_transporte,valor_total_estimado)
 values('60000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000001',
 '00000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000001',5,100,100);
do $$ begin
 begin
  perform public.aceitar_orcamento('60000000-0000-0000-0000-000000000001');
  raise exception 'TESTE: prestador aceitou pelo cliente';
 exception when raise_exception then
  if sqlerrm<>'Cliente não autorizado' then raise; end if;
 end;
end $$;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
select public.aceitar_orcamento('60000000-0000-0000-0000-000000000001');
select public.aceitar_orcamento('60000000-0000-0000-0000-000000000001');
do $$ begin
 if (select count(*) from public.servicos)<>1 then raise exception 'TESTE: aceite duplicou serviço'; end if;
 begin
  perform public.atualizar_status_servico((select id from public.servicos),'concluido');
  raise exception 'TESTE: cliente concluiu serviço agendado';
 exception when raise_exception then
  if sqlerrm<>'Transição de status não permitida' then raise; end if;
 end;
 if (select count(*) from public.historico_status_servico)<>1 then raise exception 'TESTE: histórico inválido'; end if;
end $$;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
select public.atualizar_status_servico((select id from public.servicos),'em_andamento');
select public.atualizar_status_servico((select id from public.servicos),'concluido');
do $$ begin
 if (select count(*) from public.historico_status_servico)<>3 then raise exception 'TESTE: histórico incompleto'; end if;
 if not exists(select 1 from public.servicos where iniciado_em is not null and concluido_em is not null) then
  raise exception 'TESTE: datas não preenchidas';
 end if;
end $$;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
insert into public.avaliacoes(servico_id,cliente_id,prestador_id,nota)
 select id,cliente_id,prestador_id,5 from public.servicos;
do $$ begin
 if not exists(select 1 from public.prestadores where total_avaliacoes=1 and avaliacao_media=5 and total_servicos_concluidos=1) then
  raise exception 'TESTE: estatísticas incorretas';
 end if;
 begin
  insert into public.pagamentos(servico_id,metodo,valor,status) select id,'pix',100,'aprovado' from public.servicos;
  raise exception 'TESTE: cliente confirmou pagamento';
 exception when insufficient_privilege then null;
 end;
end $$;
rollback;
\echo 'Integração SQL: todos os cenários passaram.'
