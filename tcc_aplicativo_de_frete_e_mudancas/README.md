# PI — Aplicativo de Fretes e Mudanças

> **Trabalho de Conclusão de Curso (TCC)**  
> Sistema para intermediação e gestão de fretes, transportes e mudanças residenciais/comerciais.

---

## Sobre o Projeto

O **PI (Plataforma de Fretes e Mudanças)** é uma solução mobile desenvolvida em **Flutter** que conecta clientes que precisam realizar transportes de cargas ou mudanças a prestadores de serviços autônomos. A plataforma permite desde a solicitação detalhada de itens até o orçamento, agendamento, acompanhamento do status do serviço e pagamentos.

### Principais Funcionalidades

- **Clientes:**
  - Cadastro de solicitações de fretes e mudanças com detalhamento dos itens (quantidade, fragilidade, etc.).
  - Endereços flexíveis de origem e destino com suporte a geolocalização.
  - Solicitação de ajudantes para transporte de carga/descarga.
  - Recebimento e comparação de orçamentos de diferentes prestadores.
  - Acompanhamento do status do serviço em tempo real e avaliação ao final.

- **Prestadores:**
  - Gestão de perfil, regiões de atendimento e raio de cobertura (km).
  - Cadastro e gestão da frota de veículos (tipos, capacidade em kg/m³, valor por km).
  - Configuração de disponibilidade e serviços de ajudantes.
  - Envio de orçamentos personalizados para solicitações da sua região.
  - Histórico de serviços prestados e métricas de avaliações.

---

## Arquitetura do Software

O aplicativo foi desenvolvido utilizando a **Clean Architecture** (Arquitetura Limpa) organizada na abordagem **Layer-First (por camadas)**. Esta escolha garante desacoplamento de código, alta testabilidade e clara separação de responsabilidades.

```text
lib/
├── core/                # Utilitários, constantes, temas, erros e injeção de dependência
│
├── domain/              # CAMADA DE DOMÍNIO (Regras de Negócio Puras)
│   ├── entities/        # Entidades do sistema (ex: Solicitacao, Usuario, Veiculo)
│   ├── enums/           # Enumeradores de estado e tipos (ex: StatusServico, TipoVeiculo)
│   └── repositories/    # Interfaces e contratos dos repositórios
│
├── data/                # CAMADA DE DADOS (Integração e Persistência)
│   ├── datasources/     # Comunicação direta com a API/Supabase (Remote Data Sources)
│   ├── models/          # DTOs para conversão e manipulação do JSON (.fromJson/.toJson)
│   └── repositories/    # Implementação concreta das interfaces do Domain
│
└── presentation/        # CAMADA DE APRESENTAÇÃO (Interface do Usuário)
    ├── controllers/     # Gerenciamento de Estado (BLoC / Cubit / Provider)
    ├── pages/           # Telas do aplicativo
    └── widgets/         # Componentes visuais reutilizáveis