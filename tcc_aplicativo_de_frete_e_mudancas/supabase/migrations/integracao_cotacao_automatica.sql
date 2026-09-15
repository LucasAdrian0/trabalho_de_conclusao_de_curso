-- Gera orçamentos a partir da distância da solicitação e do preço por km.
-- Execute depois de integracao.sql.

CREATE OR REPLACE FUNCTION public.gerar_cotacoes_automaticas(
  p_solicitacao_id uuid
)
RETURNS SETOF public.orcamentos
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cliente_id uuid;
  v_status status_solicitacao;
  v_distancia_km numeric;
  v_cidade text;
  v_estado text;
  v_necessita_ajudantes boolean;
  v_quantidade_ajudantes smallint;
  v_regioes text[];
BEGIN
  SELECT
    s.cliente_id,
    s.status,
    s.distancia_km,
    origem.cidade,
    origem.estado,
    s.necessita_ajudantes,
    COALESCE(s.quantidade_ajudantes, 0)
  INTO
    v_cliente_id,
    v_status,
    v_distancia_km,
    v_cidade,
    v_estado,
    v_necessita_ajudantes,
    v_quantidade_ajudantes
  FROM solicitacoes s
  JOIN enderecos origem ON origem.id = s.endereco_origem_id
  WHERE s.id = p_solicitacao_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Solicitação não encontrada' USING ERRCODE = 'P0002';
  END IF;
  IF auth.uid() IS NULL OR auth.uid() <> v_cliente_id THEN
    RAISE EXCEPTION 'Solicitação não pertence ao usuário autenticado'
      USING ERRCODE = '42501';
  END IF;
  IF v_status <> 'aguardando_prestador' THEN
    RAISE EXCEPTION 'Solicitação não está recebendo orçamentos'
      USING ERRCODE = 'P0001';
  END IF;
  IF v_distancia_km IS NULL OR v_distancia_km <= 0 THEN
    RAISE EXCEPTION 'Calcule a distância da rota antes de gerar orçamentos'
      USING ERRCODE = '23514';
  END IF;
  IF v_necessita_ajudantes AND v_quantidade_ajudantes <= 0 THEN
    RAISE EXCEPTION 'Quantidade de ajudantes inválida'
      USING ERRCODE = '23514';
  END IF;

  v_regioes := ARRAY[
    lower(trim(v_cidade)),
    lower(trim(v_cidade || '/' || v_estado)),
    lower(trim(v_cidade || ' - ' || v_estado))
  ];

  RETURN QUERY
  WITH candidatos AS (
    SELECT
      p.usuario_id AS prestador_id,
      v.id AS veiculo_id,
      CASE WHEN v_necessita_ajudantes THEN a.id ELSE NULL END AS ajudantes_id,
      CASE
        WHEN v_necessita_ajudantes THEN v_quantidade_ajudantes
        ELSE 0
      END AS quantidade_ajudantes_cotada,
      round(v_distancia_km * v.valor_por_km, 2) AS valor_transporte,
      CASE
        WHEN v_necessita_ajudantes
          THEN round(v_quantidade_ajudantes * a.valor_por_ajudante, 2)
        ELSE 0::numeric
      END AS valor_ajudantes
    FROM prestadores p
    JOIN veiculos v ON v.prestador_id = p.usuario_id
    LEFT JOIN LATERAL (
      SELECT ajudante.id, ajudante.valor_por_ajudante
      FROM ajudantes ajudante
      WHERE ajudante.prestador_id = p.usuario_id
        AND ajudante.disponivel
        AND ajudante.quantidade_disponivel >= v_quantidade_ajudantes
      ORDER BY ajudante.valor_por_ajudante, ajudante.id
      LIMIT 1
    ) a ON v_necessita_ajudantes
    WHERE p.status_disponibilidade = 'disponivel'
      AND v.status = 'ativo'
      AND lower(trim(p.regiao_atendimento)) = ANY(v_regioes)
      AND (
        v.regiao_atendimento IS NULL
        OR trim(v.regiao_atendimento) = ''
        OR lower(trim(v.regiao_atendimento)) = ANY(v_regioes)
      )
      AND (NOT v_necessita_ajudantes OR a.id IS NOT NULL)
  )
  INSERT INTO orcamentos (
    solicitacao_id,
    prestador_id,
    veiculo_id,
    ajudantes_id,
    quantidade_ajudantes_cotada,
    valor_transporte,
    valor_ajudantes,
    valor_total,
    status
  )
  SELECT
    p_solicitacao_id,
    candidato.prestador_id,
    candidato.veiculo_id,
    candidato.ajudantes_id,
    candidato.quantidade_ajudantes_cotada,
    candidato.valor_transporte,
    candidato.valor_ajudantes,
    candidato.valor_transporte + candidato.valor_ajudantes,
    'pendente'
  FROM candidatos candidato
  ON CONFLICT (solicitacao_id, prestador_id, veiculo_id)
  DO UPDATE SET
    ajudantes_id = excluded.ajudantes_id,
    quantidade_ajudantes_cotada = excluded.quantidade_ajudantes_cotada,
    valor_transporte = excluded.valor_transporte,
    valor_ajudantes = excluded.valor_ajudantes,
    valor_total = excluded.valor_total
  WHERE orcamentos.status = 'pendente'
  RETURNING orcamentos.*;
END;
$$;

CREATE OR REPLACE FUNCTION public.disparar_cotacoes_automaticas()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.gerar_cotacoes_automaticas(new.id);
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_gerar_cotacoes_automaticas
ON public.solicitacoes;
CREATE TRIGGER trg_gerar_cotacoes_automaticas
AFTER INSERT ON public.solicitacoes
FOR EACH ROW
WHEN (new.status = 'aguardando_prestador')
EXECUTE FUNCTION public.disparar_cotacoes_automaticas();

REVOKE ALL ON FUNCTION public.gerar_cotacoes_automaticas(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.disparar_cotacoes_automaticas() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.gerar_cotacoes_automaticas(uuid)
TO authenticated;
