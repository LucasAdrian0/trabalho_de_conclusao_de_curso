# Aplicativo de Fretes e Mudanças

Aplicativo Flutter para conectar clientes e prestadores de frete urbano. O
projeto usa Supabase Auth e PostgreSQL/Supabase para perfis, endereços,
veículos, ajudantes, solicitações, itens de mudança, orçamentos, serviços,
pagamentos, avaliações, notificações e histórico de status.

## Arquitetura

O código segue Clean Architecture por camadas:

- `domain`: entidades, enums, validações e contratos de repositório puros;
- `application`: casos de uso e regras de autorização da aplicação;
- `data`: models, mapeamento dos enums SQL, datasources Supabase e
  implementações dos repositórios;
- `presentation`: widgets e telas Flutter;
- `core`: configuração e composição das dependências.

As dependências apontam para dentro: `domain` não conhece Flutter ou Supabase,
e `application` depende apenas dos contratos do domínio. O acesso ao SDK fica
restrito aos datasources e ao composition root.

## Configuração

Não armazene chaves em arquivos versionados. Inicie o app informando a URL e a
chave pública do Supabase:

```powershell
flutter run --dart-define=SUPABASE_URL=https://SEU-PROJETO.supabase.co `
  --dart-define=SUPABASE_PUBLISHABLE_KEY=SUA_CHAVE_PUBLICA
```

Nunca distribua a chave `secret` ou `service_role` no aplicativo.

## Banco e validação

O diretório `supabase` contém a migration complementar de Auth, RLS e funções
atômicas, além do teste SQL local. Leia `supabase/README.md` antes de aplicá-la.

```powershell
flutter analyze
flutter test --no-pub
```
