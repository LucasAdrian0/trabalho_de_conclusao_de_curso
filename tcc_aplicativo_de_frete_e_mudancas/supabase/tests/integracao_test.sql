\set ON_ERROR_STOP on

GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;
REVOKE SELECT, UPDATE ON usuarios FROM authenticated;
GRANT SELECT (
  id, tipo, nome, email, telefone, foto_perfil_url, ativo,
  criado_em, atualizado_em
) ON usuarios TO authenticated;
GRANT UPDATE (nome, telefone, foto_perfil_url, ativo) ON usuarios TO authenticated;

BEGIN;
INSERT INTO auth.users (id, email, raw_user_meta_data) VALUES
  ('00000000-0000-0000-0000-000000000001', 'cliente@example.com', '{"tipo":"cliente","nome":"Cliente"}'),
  ('00000000-0000-0000-0000-000000000002', 'prestador@example.com', '{"tipo":"prestador","nome":"Prestador"}'),
  ('00000000-0000-0000-0000-000000000003', 'outro@example.com', '{"tipo":"cliente","nome":"Outro"}');

SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000002', true);
UPDATE prestadores
SET cpf_cnpj = '12345678901',
    regiao_atendimento = 'Ourinhos',
    status_disponibilidade = 'disponivel'
WHERE usuario_id = auth.uid();
INSERT INTO veiculos (id, prestador_id, tipo_veiculo, valor_por_km, status)
VALUES ('20000000-0000-0000-0000-000000000001', auth.uid(), 'fiorino', 5, 'ativo');
INSERT INTO ajudantes (id, prestador_id, quantidade_disponivel, valor_por_ajudante)
VALUES ('21000000-0000-0000-0000-000000000001', auth.uid(), 1, 50);

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT criar_solicitacao_com_itens(
  '{"id":"30000000-0000-0000-0000-000000000001","cliente_id":"00000000-0000-0000-0000-000000000001","data_desejada":"2026-10-01","tipo_servico":"frete","necessita_ajudantes":true,"quantidade_ajudantes":1,"distancia_km":20}',
  '{"id":"40000000-0000-0000-0000-000000000001","logradouro":"Rua A","cidade":"Ourinhos","estado":"SP"}',
  '{"id":"40000000-0000-0000-0000-000000000002","logradouro":"Rua B","cidade":"Ourinhos","estado":"SP"}',
  '[{"id":"50000000-0000-0000-0000-000000000001","descricao":"Caixa","quantidade":1}]'
);

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM orcamentos
    WHERE solicitacao_id = '30000000-0000-0000-0000-000000000001'
      AND valor_transporte = 100
      AND valor_ajudantes = 50
      AND valor_total = 150
  ) THEN
    RAISE EXCEPTION 'Cotação automática não foi calculada corretamente';
  END IF;
END $$;

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000003', true);
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM solicitacoes) THEN
    RAISE EXCEPTION 'Outro cliente acessou uma solicitação privada';
  END IF;
  BEGIN
    PERFORM senha_hash FROM usuarios;
    RAISE EXCEPTION 'senha_hash ficou exposta';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END $$;

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000002', true);
SELECT count(*) FROM orcamentos
WHERE solicitacao_id = '30000000-0000-0000-0000-000000000001';

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
SELECT aceitar_orcamento((
  SELECT id FROM orcamentos
  WHERE solicitacao_id = '30000000-0000-0000-0000-000000000001'
  LIMIT 1
));

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000002', true);
SELECT atualizar_status_servico((SELECT id FROM servicos LIMIT 1), 'em_andamento');
SELECT atualizar_status_servico((SELECT id FROM servicos LIMIT 1), 'concluido');

SELECT set_config('request.jwt.claim.sub', '00000000-0000-0000-0000-000000000001', true);
INSERT INTO avaliacoes (servico_id, cliente_id, prestador_id, nota)
SELECT id, auth.uid(), prestador_id, 5 FROM servicos;

DO $$
BEGIN
  IF (SELECT count(*) FROM historico_status) <> 3 THEN
    RAISE EXCEPTION 'Histórico incompleto';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM prestadores
    WHERE usuario_id = '00000000-0000-0000-0000-000000000002'
      AND avaliacao_media = 5
      AND total_avaliacoes = 1
  ) THEN
    RAISE EXCEPTION 'Média de avaliações não foi atualizada';
  END IF;
END $$;

ROLLBACK;
\echo 'Integração SQL concluída com sucesso.'
