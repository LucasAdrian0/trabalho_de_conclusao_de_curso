-- Integra o schema do projeto ao Supabase Auth e expõe operações atômicas.
-- Execute depois do schema principal fornecido no projeto.

ALTER TABLE public.usuarios ALTER COLUMN senha_hash DROP NOT NULL;
REVOKE SELECT, UPDATE ON public.usuarios FROM anon, authenticated;
GRANT SELECT (
  id, tipo, nome, email, telefone, foto_perfil_url, ativo,
  criado_em, atualizado_em
) ON public.usuarios TO authenticated;
GRANT UPDATE (nome, telefone, foto_perfil_url, ativo)
ON public.usuarios TO authenticated;

CREATE OR REPLACE FUNCTION public.criar_perfil_auth()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_tipo tipo_usuario;
BEGIN
  v_tipo := COALESCE(new.raw_user_meta_data ->> 'tipo', 'cliente')::tipo_usuario;
  INSERT INTO public.usuarios (id, tipo, nome, email)
  VALUES (
    new.id,
    v_tipo,
    COALESCE(NULLIF(trim(new.raw_user_meta_data ->> 'nome'), ''), split_part(new.email, '@', 1)),
    new.email
  )
  ON CONFLICT (id) DO UPDATE
    SET email = excluded.email,
        nome = excluded.nome,
        tipo = excluded.tipo;

  IF v_tipo = 'cliente' THEN
    INSERT INTO public.clientes (usuario_id) VALUES (new.id)
    ON CONFLICT (usuario_id) DO NOTHING;
  ELSE
    INSERT INTO public.prestadores (usuario_id) VALUES (new.id)
    ON CONFLICT (usuario_id) DO NOTHING;
  END IF;
  RETURN new;
END;
$$;

DROP TRIGGER IF EXISTS trg_criar_perfil_auth ON auth.users;
CREATE TRIGGER trg_criar_perfil_auth
AFTER INSERT OR UPDATE OF email, raw_user_meta_data ON auth.users
FOR EACH ROW EXECUTE FUNCTION public.criar_perfil_auth();

CREATE OR REPLACE FUNCTION public.atualizar_avaliacao_media()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE prestadores
  SET avaliacao_media = (
        SELECT round(avg(nota)::numeric, 2)
        FROM avaliacoes
        WHERE prestador_id = new.prestador_id
      ),
      total_avaliacoes = (
        SELECT count(*)
        FROM avaliacoes
        WHERE prestador_id = new.prestador_id
      )
  WHERE usuario_id = new.prestador_id;
  RETURN new;
END;
$$;

CREATE OR REPLACE FUNCTION public.definir_atualizado_em()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  new.atualizado_em = now();
  RETURN new;
END;
$$;

DO $$
DECLARE
  v_tabela text;
BEGIN
  FOREACH v_tabela IN ARRAY ARRAY['usuarios', 'solicitacoes', 'pagamentos']
  LOOP
    EXECUTE format(
      'DROP TRIGGER IF EXISTS trg_definir_atualizado_em ON public.%I',
      v_tabela
    );
    EXECUTE format(
      'CREATE TRIGGER trg_definir_atualizado_em
       BEFORE UPDATE ON public.%I
       FOR EACH ROW EXECUTE FUNCTION public.definir_atualizado_em()',
      v_tabela
    );
  END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION public.usuario_pode_acessar_solicitacao(p_id uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM solicitacoes s
    WHERE s.id = p_id
      AND (
        s.cliente_id = auth.uid()
        OR (
          s.status = 'aguardando_prestador'
          AND EXISTS (
            SELECT 1 FROM prestadores p WHERE p.usuario_id = auth.uid()
          )
        )
        OR EXISTS (
          SELECT 1 FROM orcamentos o
          WHERE o.solicitacao_id = s.id AND o.prestador_id = auth.uid()
        )
        OR EXISTS (
          SELECT 1 FROM servicos sv
          WHERE sv.solicitacao_id = s.id AND sv.prestador_id = auth.uid()
        )
      )
  );
$$;

CREATE OR REPLACE FUNCTION public.criar_solicitacao_com_itens(
  p_solicitacao jsonb,
  p_origem jsonb,
  p_destino jsonb,
  p_itens jsonb DEFAULT '[]'::jsonb
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_usuario uuid := auth.uid();
  v_solicitacao_id uuid := COALESCE((p_solicitacao ->> 'id')::uuid, gen_random_uuid());
  v_origem_id uuid := COALESCE((p_origem ->> 'id')::uuid, gen_random_uuid());
  v_destino_id uuid := COALESCE((p_destino ->> 'id')::uuid, gen_random_uuid());
  v_item jsonb;
BEGIN
  IF v_usuario IS NULL OR (p_solicitacao ->> 'cliente_id')::uuid <> v_usuario THEN
    RAISE EXCEPTION 'Solicitação não pertence ao usuário autenticado'
      USING ERRCODE = '42501';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM clientes WHERE usuario_id = v_usuario) THEN
    RAISE EXCEPTION 'Cadastro de cliente não encontrado' USING ERRCODE = 'P0002';
  END IF;

  INSERT INTO enderecos (
    id, usuario_id, tipo, logradouro, numero, complemento, bairro,
    cidade, estado, cep, latitude, longitude
  ) VALUES (
    v_origem_id, v_usuario, 'origem',
    p_origem ->> 'logradouro', p_origem ->> 'numero',
    p_origem ->> 'complemento', p_origem ->> 'bairro',
    p_origem ->> 'cidade', p_origem ->> 'estado', p_origem ->> 'cep',
    (p_origem ->> 'latitude')::numeric, (p_origem ->> 'longitude')::numeric
  )
  ON CONFLICT (id) DO UPDATE SET
    tipo = 'origem', logradouro = excluded.logradouro, numero = excluded.numero,
    complemento = excluded.complemento, bairro = excluded.bairro,
    cidade = excluded.cidade, estado = excluded.estado, cep = excluded.cep,
    latitude = excluded.latitude, longitude = excluded.longitude
  WHERE enderecos.usuario_id = v_usuario;

  INSERT INTO enderecos (
    id, usuario_id, tipo, logradouro, numero, complemento, bairro,
    cidade, estado, cep, latitude, longitude
  ) VALUES (
    v_destino_id, v_usuario, 'destino',
    p_destino ->> 'logradouro', p_destino ->> 'numero',
    p_destino ->> 'complemento', p_destino ->> 'bairro',
    p_destino ->> 'cidade', p_destino ->> 'estado', p_destino ->> 'cep',
    (p_destino ->> 'latitude')::numeric, (p_destino ->> 'longitude')::numeric
  )
  ON CONFLICT (id) DO UPDATE SET
    tipo = 'destino', logradouro = excluded.logradouro, numero = excluded.numero,
    complemento = excluded.complemento, bairro = excluded.bairro,
    cidade = excluded.cidade, estado = excluded.estado, cep = excluded.cep,
    latitude = excluded.latitude, longitude = excluded.longitude
  WHERE enderecos.usuario_id = v_usuario;

  INSERT INTO solicitacoes (
    id, cliente_id, endereco_origem_id, endereco_destino_id, data_desejada,
    tipo_servico, volume_estimado_m3, necessita_ajudantes,
    quantidade_ajudantes, distancia_km, rota_geojson, status
  ) VALUES (
    v_solicitacao_id, v_usuario, v_origem_id, v_destino_id,
    (p_solicitacao ->> 'data_desejada')::date,
    (p_solicitacao ->> 'tipo_servico')::tipo_servico_solicitacao,
    (p_solicitacao ->> 'volume_estimado_m3')::numeric,
    COALESCE((p_solicitacao ->> 'necessita_ajudantes')::boolean, false),
    COALESCE((p_solicitacao ->> 'quantidade_ajudantes')::smallint, 0),
    (p_solicitacao ->> 'distancia_km')::numeric,
    p_solicitacao -> 'rota_geojson',
    'aguardando_prestador'
  );

  FOR v_item IN SELECT value FROM jsonb_array_elements(COALESCE(p_itens, '[]'::jsonb))
  LOOP
    INSERT INTO itens_mudanca (id, solicitacao_id, descricao, quantidade, volume_m3)
    VALUES (
      COALESCE((v_item ->> 'id')::uuid, gen_random_uuid()),
      v_solicitacao_id,
      v_item ->> 'descricao',
      COALESCE((v_item ->> 'quantidade')::smallint, 1),
      (v_item ->> 'volume_m3')::numeric
    );
  END LOOP;
  RETURN v_solicitacao_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.atualizar_status_solicitacao(
  p_solicitacao_id uuid,
  p_status text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_atual status_solicitacao;
BEGIN
  SELECT status INTO v_atual FROM solicitacoes
  WHERE id = p_solicitacao_id AND cliente_id = auth.uid()
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Solicitação não encontrada' USING ERRCODE = 'P0002';
  END IF;
  IF NOT (
    (v_atual = 'criada' AND p_status = 'aguardando_prestador')
    OR (
      v_atual IN ('criada', 'aguardando_prestador', 'pagamento_pendente', 'pagamento_recusado')
      AND p_status = 'cancelado_cliente'
    )
  ) THEN
    RAISE EXCEPTION 'Transição de solicitação inválida' USING ERRCODE = 'P0001';
  END IF;
  UPDATE solicitacoes SET status = p_status::status_solicitacao
  WHERE id = p_solicitacao_id;
  INSERT INTO historico_status (
    solicitacao_id, status_anterior, status_novo, alterado_por
  ) VALUES (p_solicitacao_id, v_atual::text, p_status, auth.uid());
END;
$$;

CREATE OR REPLACE FUNCTION public.aceitar_orcamento(p_orcamento_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_orcamento orcamentos%ROWTYPE;
  v_servico servicos%ROWTYPE;
BEGIN
  SELECT o.* INTO v_orcamento
  FROM orcamentos o
  JOIN solicitacoes s ON s.id = o.solicitacao_id
  WHERE o.id = p_orcamento_id
    AND s.cliente_id = auth.uid()
    AND s.status = 'aguardando_prestador'
    AND o.status = 'pendente'
  FOR UPDATE OF o;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Orçamento indisponível' USING ERRCODE = 'P0002';
  END IF;

  UPDATE orcamentos SET status = CASE
    WHEN id = p_orcamento_id THEN 'aceito'::status_orcamento
    ELSE 'recusado'::status_orcamento
  END
  WHERE solicitacao_id = v_orcamento.solicitacao_id AND status = 'pendente';

  UPDATE solicitacoes SET status = 'prestador_selecionado'
  WHERE id = v_orcamento.solicitacao_id;

  INSERT INTO servicos (
    solicitacao_id, orcamento_id, prestador_id, veiculo_id, status
  ) VALUES (
    v_orcamento.solicitacao_id, v_orcamento.id,
    v_orcamento.prestador_id, v_orcamento.veiculo_id, 'agendado'
  )
  RETURNING * INTO v_servico;

  INSERT INTO historico_status (
    solicitacao_id, servico_id, status_anterior, status_novo, alterado_por
  ) VALUES (
    v_orcamento.solicitacao_id, v_servico.id,
    'aguardando_prestador', 'prestador_selecionado', auth.uid()
  );
  RETURN to_jsonb(v_servico);
END;
$$;

CREATE OR REPLACE FUNCTION public.atualizar_status_servico(
  p_servico_id uuid,
  p_status text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_servico servicos%ROWTYPE;
  v_cliente uuid;
  v_permitido boolean := false;
BEGIN
  SELECT sv.*
  INTO v_servico
  FROM servicos sv
  WHERE sv.id = p_servico_id
  FOR UPDATE OF sv;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Serviço não encontrado' USING ERRCODE = 'P0002';
  END IF;
  SELECT cliente_id INTO v_cliente
  FROM solicitacoes
  WHERE id = v_servico.solicitacao_id;

  IF auth.uid() = v_servico.prestador_id THEN
    v_permitido :=
      (v_servico.status = 'agendado' AND p_status IN ('a_caminho', 'em_andamento', 'cancelado_prestador'))
      OR (v_servico.status = 'a_caminho' AND p_status IN ('em_andamento', 'cancelado_prestador'))
      OR (v_servico.status = 'em_andamento' AND p_status = 'concluido');
  ELSIF auth.uid() = v_cliente THEN
    v_permitido := v_servico.status IN ('agendado', 'a_caminho')
      AND p_status = 'cancelado_cliente';
  END IF;
  IF NOT v_permitido THEN
    RAISE EXCEPTION 'Transição de serviço inválida' USING ERRCODE = 'P0001';
  END IF;

  UPDATE servicos SET
    status = p_status::status_solicitacao,
    data_inicio = CASE
      WHEN p_status = 'em_andamento' AND data_inicio IS NULL THEN now()
      ELSE data_inicio
    END,
    data_conclusao = CASE
      WHEN p_status = 'concluido' THEN now()
      ELSE data_conclusao
    END
  WHERE id = p_servico_id;
  UPDATE solicitacoes SET status = p_status::status_solicitacao
  WHERE id = v_servico.solicitacao_id;
  INSERT INTO historico_status (
    solicitacao_id, servico_id, status_anterior, status_novo, alterado_por
  ) VALUES (
    v_servico.solicitacao_id, p_servico_id,
    v_servico.status::text, p_status, auth.uid()
  );
END;
$$;

DO $$
DECLARE
  v_tabela text;
BEGIN
  FOREACH v_tabela IN ARRAY ARRAY[
    'usuarios', 'clientes', 'prestadores', 'enderecos', 'veiculos',
    'ajudantes', 'solicitacoes', 'itens_mudanca', 'orcamentos', 'servicos',
    'pagamentos', 'avaliacoes', 'notificacoes', 'historico_status'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', v_tabela);
  END LOOP;
END;
$$;

CREATE POLICY usuarios_ler ON usuarios FOR SELECT TO authenticated
USING (id = auth.uid() OR (ativo AND tipo = 'prestador'));
CREATE POLICY usuarios_atualizar ON usuarios FOR UPDATE TO authenticated
USING (id = auth.uid()) WITH CHECK (id = auth.uid());
CREATE POLICY clientes_proprio ON clientes FOR ALL TO authenticated
USING (usuario_id = auth.uid()) WITH CHECK (usuario_id = auth.uid());
CREATE POLICY prestadores_ler ON prestadores FOR SELECT TO authenticated USING (true);
CREATE POLICY prestadores_salvar ON prestadores FOR ALL TO authenticated
USING (usuario_id = auth.uid()) WITH CHECK (usuario_id = auth.uid());
CREATE POLICY enderecos_ler ON enderecos FOR SELECT TO authenticated
USING (
  usuario_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM solicitacoes s
    WHERE (s.endereco_origem_id = enderecos.id OR s.endereco_destino_id = enderecos.id)
      AND usuario_pode_acessar_solicitacao(s.id)
  )
);
CREATE POLICY enderecos_salvar ON enderecos FOR ALL TO authenticated
USING (usuario_id = auth.uid()) WITH CHECK (usuario_id = auth.uid());
CREATE POLICY veiculos_ler ON veiculos FOR SELECT TO authenticated USING (true);
CREATE POLICY veiculos_salvar ON veiculos FOR ALL TO authenticated
USING (prestador_id = auth.uid()) WITH CHECK (prestador_id = auth.uid());
CREATE POLICY ajudantes_ler ON ajudantes FOR SELECT TO authenticated USING (true);
CREATE POLICY ajudantes_salvar ON ajudantes FOR ALL TO authenticated
USING (prestador_id = auth.uid()) WITH CHECK (prestador_id = auth.uid());
CREATE POLICY solicitacoes_ler ON solicitacoes FOR SELECT TO authenticated
USING (usuario_pode_acessar_solicitacao(id));
CREATE POLICY itens_ler ON itens_mudanca FOR SELECT TO authenticated
USING (usuario_pode_acessar_solicitacao(solicitacao_id));
CREATE POLICY orcamentos_ler ON orcamentos FOR SELECT TO authenticated
USING (
  prestador_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM solicitacoes s
    WHERE s.id = solicitacao_id AND s.cliente_id = auth.uid()
  )
);
CREATE POLICY orcamentos_criar ON orcamentos FOR INSERT TO authenticated
WITH CHECK (
  prestador_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM veiculos v
    WHERE v.id = veiculo_id AND v.prestador_id = auth.uid() AND v.status = 'ativo'
  )
);
CREATE POLICY orcamentos_atualizar ON orcamentos FOR UPDATE TO authenticated
USING (prestador_id = auth.uid()) WITH CHECK (prestador_id = auth.uid());
CREATE POLICY servicos_ler ON servicos FOR SELECT TO authenticated
USING (
  prestador_id = auth.uid()
  OR EXISTS (
    SELECT 1 FROM solicitacoes s
    WHERE s.id = solicitacao_id AND s.cliente_id = auth.uid()
  )
);
CREATE POLICY pagamentos_ler ON pagamentos FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM servicos sv
    JOIN solicitacoes s ON s.id = sv.solicitacao_id
    WHERE sv.id = servico_id
      AND (sv.prestador_id = auth.uid() OR s.cliente_id = auth.uid())
  )
);
CREATE POLICY avaliacoes_ler ON avaliacoes FOR SELECT TO authenticated USING (true);
CREATE POLICY avaliacoes_criar ON avaliacoes FOR INSERT TO authenticated
WITH CHECK (
  cliente_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM servicos sv
    JOIN solicitacoes s ON s.id = sv.solicitacao_id
    WHERE sv.id = servico_id
      AND s.cliente_id = auth.uid()
      AND sv.prestador_id = prestador_id
      AND sv.status = 'concluido'
  )
);
CREATE POLICY notificacoes_proprio ON notificacoes FOR SELECT TO authenticated
USING (usuario_id = auth.uid());
CREATE POLICY notificacoes_atualizar ON notificacoes FOR UPDATE TO authenticated
USING (usuario_id = auth.uid()) WITH CHECK (usuario_id = auth.uid());
CREATE POLICY historico_ler ON historico_status FOR SELECT TO authenticated
USING (
  (solicitacao_id IS NOT NULL AND usuario_pode_acessar_solicitacao(solicitacao_id))
  OR EXISTS (
    SELECT 1 FROM servicos sv
    JOIN solicitacoes s ON s.id = sv.solicitacao_id
    WHERE sv.id = servico_id
      AND (sv.prestador_id = auth.uid() OR s.cliente_id = auth.uid())
  )
);

REVOKE ALL ON FUNCTION public.criar_perfil_auth() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.atualizar_avaliacao_media() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.definir_atualizado_em() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.criar_solicitacao_com_itens(jsonb, jsonb, jsonb, jsonb) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.atualizar_status_solicitacao(uuid, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.aceitar_orcamento(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.atualizar_status_servico(uuid, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.criar_solicitacao_com_itens(jsonb, jsonb, jsonb, jsonb) TO authenticated;
GRANT EXECUTE ON FUNCTION public.atualizar_status_solicitacao(uuid, text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.aceitar_orcamento(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.atualizar_status_servico(uuid, text) TO authenticated;
