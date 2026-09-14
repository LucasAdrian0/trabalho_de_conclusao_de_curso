# Integração com o banco existente

O código Dart agora segue as tabelas e enums do SQL fornecido pelo projeto. A migration `migrations/integracao.sql` é **complementar**: exige que esse schema já exista e deve ser aplicada uma vez. Ela não recria as tabelas. Nenhum comando deste trabalho foi executado no Supabase remoto.

## Aplicação

1. Confira se o schema do ambiente corresponde ao fornecido, especialmente as colunas de `orcamentos`, `pagamentos`, `veiculos` e as relações de `solicitacoes`.
2. Execute o conteúdo da migration no SQL Editor do Supabase. O arquivo usa uma transação: uma falha reverte o conjunto de alterações.
3. Habilite autenticação por e-mail e configure URLs de confirmação/recuperação e a política de senha no painel Auth. O app valida no mínimo oito caracteres no cadastro; a política do servidor pode ser mais restritiva.
4. Execute o Flutter com a URL e a chave pública do projeto:

```powershell
flutter run --dart-define=SUPABASE_URL=https://SEU-PROJETO.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=SUA_CHAVE_PUBLICA
```

Use a chave publishable; não coloque chave secret/service_role no aplicativo. A proteção dos dados depende das permissões e políticas RLS, não de ocultar a chave pública.

## Contratos corrigidos

- Enums possuem `databaseValue`; o banco recebe snake_case e os valores exatos, como `criada` e `reembolsado`. Valores desconhecidos geram erro, sem virar silenciosamente outro status.
- Orçamento usa `solicitacaoId`, `veiculoId` e os valores do snapshot de precificação. A consulta chama-se `buscarPorSolicitacao`. Não existe coluna `observacao` em orçamento no schema fornecido.
- Veículo usa `TipoVeiculo` e persiste dimensões em `largura_m`, `altura_m`, `comprimento_m`.
- Pagamento lê o cliente pela relação com serviço e utiliza `metodo` e `gateway_transacao_id`. A busca por serviço retorna a tentativa mais recente, pois o SQL permite múltiplos pagamentos.
- Notificações usam `TipoNotificacao` e têm uma única implementação de datasource. Os arquivos antigos exportam a implementação para compatibilidade.
- Campos opcionais de endereço/veículo e estimativas usam valores vazios/zero no domínio quando o SQL retorna null. Horários vazios voltam ao SQL como null; endereço avulso preserva usuário nulo na leitura.

## Autenticação e perfis

`AuthRepository` implementa cadastro, login, logout, recuperação e stream do usuário da sessão. O cadastro envia nome/tipo ao Auth. O trigger cria o perfil com **o mesmo ID de `auth.users`** e cria a extensão de cliente quando apropriado. Prestadores completam CPF/CNPJ, regiões, veículos e ajudantes em `PrestadorRepository.salvar` após autenticar.

`UsuarioRepository.salvar/atualizar` atualizam o perfil já criado pelo Auth; não criam credenciais. E-mail e confirmação pertencem ao Auth. `ClienteRepository.salvar` usa upsert para completar o perfil criado pelo trigger.

A coluna `senha_hash` legada foi mantida, tornou-se opcional e perdeu acesso via API. `recuperacoes_senha` também não fica acessível ao aplicativo. **Contas legadas não são migradas automaticamente:** se já houver usuários com IDs diferentes dos IDs de Auth, será necessário planejar a vinculação antes de usar essas contas. Um e-mail legado igual ao de um novo cadastro pode impedir o trigger por unicidade. Não foram apagados ou reidentificados usuários.

## Operações e permissões

- `criar_solicitacao_com_itens`: grava endereços, solicitação e itens em uma transação. Valida os vínculos e vincula endereços avulsos ao cliente autenticado.
- `salvar_prestador_com_relacoes`: grava o prestador e faz upsert das regiões, veículos e ajudantes fornecidos. Coleções vazias e ajudantes nulos **não removem** registros existentes. `atualizar` exige prestador existente.
- `ServicoRepository.aceitarOrcamento`: aceita o orçamento, recusa os demais pendentes, seleciona o prestador, cria serviço e histórico. Aceites concorrentes são serializados pelo bloqueio da solicitação. Repetir o mesmo aceite retorna o serviço existente.
- `atualizar_status_servico`: valida autor e transição, grava status, datas e histórico juntos. Início/conclusão cabem ao prestador; cancelamentos respeitam o papel de cada participante.
- `atualizar_status_solicitacao`: permite abertura/cancelamento pelo cliente. Seleção do prestador acontece exclusivamente pelo aceite. Expiração requer um job de backend, ainda não implementado.
- Avaliações só podem ser criadas pelo cliente do serviço concluído. O trigger atualiza média e contagem; conclusão atualiza o total de serviços.
- Pagamentos são somente leitura para o app. Métodos de registro/confirmação existentes no datasource/repositório exigem backend autorizado; não devem ser chamados com a sessão do cliente. Gateway e webhook ainda precisam ser implementados.
- Notificações podem ser lidas e marcadas como lidas pelo destinatário. Criação exige backend; entrega push/Realtime ainda não está implementada.
- Dados cadastrais de prestadores são legíveis por usuários ativos; perfis de clientes/endereço de solicitação são visíveis ao próprio cliente e prestadores autorizados pelo fluxo/região. Revise essa exposição conforme os requisitos finais do produto.

`AppRepositories` monta as dependências e é passado ao `MyApp`. A interface ainda é o exemplo Flutter; telas, controllers, mapas, uploads e integrações externas são etapas seguintes, não foram apresentadas como concluídas.

## Validação local

```powershell
flutter analyze
flutter test --no-pub
```

Para verificar SQL, use uma instância PostgreSQL **descartável** e execute, nesta ordem, com `psql -v ON_ERROR_STOP=1`:

1. `tests/fixture_schema.sql` — reproduz tipos, colunas e restrições do schema fornecido, com stubs de Auth. Não é migration e nunca deve ser executado no Supabase.
2. `migrations/202609130001_integracao.sql`.
3. `tests/integracao_test.sql` — testa transação/rollback, isolamento entre clientes, senha inacessível, aceite idempotente, transições, histórico, estatísticas e bloqueio de confirmação de pagamento pelo cliente. Reverte os dados de teste ao terminar.

Os testes locais não substituem a validação das relações PostgREST e dos redirects de Auth no projeto Supabase real.
