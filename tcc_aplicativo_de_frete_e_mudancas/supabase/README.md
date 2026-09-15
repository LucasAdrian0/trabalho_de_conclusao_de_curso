# Integração Supabase

O arquivo `migrations/integracao.sql` complementa o schema fornecido para o
projeto. Ele conecta `auth.users` a `usuarios`, ativa RLS e cria as funções
atômicas usadas pelos datasources:

- `criar_solicitacao_com_itens`
- `atualizar_status_solicitacao`
- `aceitar_orcamento`
- `atualizar_status_servico`
- `gerar_cotacoes_automaticas`

Execute primeiro o schema principal, depois `migrations/integracao.sql` e por
último `migrations/integracao_cotacao_automatica.sql`. A integração torna
`usuarios.senha_hash` opcional porque a senha passa a ser responsabilidade do
Supabase Auth; a coluna também fica sem acesso para `anon` e `authenticated`.

Execute o app com `SUPABASE_URL` e `SUPABASE_PUBLISHABLE_KEY` passados por
`--dart-define`. Use apenas a chave pública no aplicativo. Pagamentos devem ser
confirmados por um backend ou webhook autorizado pelo gateway.

## Teste SQL local

Em um PostgreSQL descartável, execute nesta ordem:

1. `tests/auth_fixture.sql`
2. o schema principal fornecido
3. `migrations/integracao.sql`
4. `migrations/integracao_cotacao_automatica.sql`
5. `tests/integracao_test.sql`

O fixture apenas simula Auth e as roles do Supabase; ele não deve ser executado
no projeto remoto.
