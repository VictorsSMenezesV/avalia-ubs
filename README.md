# AvaliaUBS

Aplicativo mobile para avaliação de Unidades Básicas de Saúde (UBS), desenvolvido em **Flutter** com **Firebase** como backend. Usuários podem se cadastrar ou navegar como visitantes, consultar UBS próximas, avaliar unidades já utilizadas e acompanhar o status de suas próprias avaliações.

> ⚠️ Projeto em desenvolvimento ativo. Este README reflete o estado atual da arquitetura e das funcionalidades implementadas.

## Sobre o projeto

O AvaliaUBS conecta dados públicos de Unidades Básicas de Saúde (baseados no CNES/DATASUS) a avaliações reais de usuários, permitindo que a comunidade avalie tempo de espera, lotação, disponibilidade de medicamentos e qualidade do atendimento de cada unidade.

O app **não possui vínculo oficial** com o Ministério da Saúde, secretarias estaduais/municipais ou qualquer órgão público — é uma iniciativa independente que reutiliza dados abertos governamentais.

## Perfis de acesso

| Perfil | O que pode fazer |
|---|---|
| **Visitante** | Consultar UBS e ler avaliações públicas, sem necessidade de cadastro |
| **Usuário cadastrado** | Tudo do visitante, além de avaliar UBS, favoritar unidades, ver seu histórico de avaliações e editar/excluir/denunciar avaliações |
| **Administrador** | Painel completo: gerenciar UBS, moderar avaliações (aprovar/rejeitar), gerenciar usuários e revisar denúncias |

A definição de administrador é feita via **Custom Claims** do Firebase Authentication — nunca é um valor configurável pelo próprio app.

## Principais funcionalidades

- Cadastro, login e navegação como visitante (Firebase Authentication)
- Busca de UBS por nome, com filtragem em tempo real
- Busca de UBS próximas por geolocalização (GPS do dispositivo ou fallback de cadastro)
- Avaliação de UBS com nota (1-5), comentário opcional e campos estruturados (tempo de espera, lotação, disponibilidade de medicamento)
- **Moderação automática por regra de negócio**: avaliações apenas com dados estruturados são publicadas direto; avaliações com comentário livre entram em fila de análise administrativa
- Histórico pessoal de avaliações, com status visível (publicada / em análise / não aprovada)
- Edição e exclusão da própria avaliação
- Denúncia de avaliações de terceiros
- Favoritar UBS e consultar lista de favoritos
- Painel administrativo: CRUD de UBS, moderação de avaliações, gestão de usuários

## Stack técnica

- **Flutter** — interface e lógica de app
- **Firebase Authentication** — autenticação e controle de acesso (Custom Claims)
- **Cloud Firestore** — banco de dados NoSQL
- **Firebase Cloud Functions** — operações administrativas privilegiadas (promoção de admin, moderação em lote)
- **go_router** — navegação declarativa, com rotas nomeadas e guardas de acesso por perfil
- **Provider** + **get_it** — gerenciamento de estado e injeção de dependência
- **geolocator** / **geoflutterfire_plus** — geolocalização e busca por proximidade

## Arquitetura

O projeto segue os princípios de **Clean Architecture**, organizado em três camadas independentes:

```
lib/
├── domain/          # Regras de negócio puras — entidades, contratos de repositório e usecases.
│                     # Não depende de Flutter, Firebase ou qualquer framework externo.
├── data/             # Implementação concreta — models, datasources (Firebase) e repositories.
│                     # Traduz entre o formato do Firestore e as entidades do domain.
├── presentation/     # UI — telas, controllers (ChangeNotifier) e widgets.
│                     # Consome usecases através de injeção de dependência.
└── core/             # Código transversal — rotas, injeção de dependência, tema, utilitários.
```

Cada funcionalidade (autenticação, UBS, avaliações, favoritos, denúncias) segue o mesmo fluxo:

```
UI → Controller → Usecase → Repository (contrato) → Datasource (Firebase) → Firestore
```

Princípios SOLID aplicados ao longo do projeto:
- **SRP**: cada classe tem uma única responsabilidade (busca, cadastro, mapeamento, estado de UI são sempre classes separadas)
- **DIP**: camadas superiores dependem de abstrações (`Repository`, `Datasource` como interfaces), nunca de implementações concretas do Firebase
- **OCP**: novas fontes de dado (cache local, outro backend) podem ser adicionadas sem alterar o domain ou a presentation

## Modelagem de dados (Firestore)

```
users/{userId}                          → perfil do usuário
users/{userId}/favoritos/{ubsId}        → UBS favoritadas pelo usuário

ubs/{ubsId}                             → dados da unidade (nome, endereço, geolocalização, CNES)

avaliacoes/{avaliacaoId}                → avaliações (coleção raiz, sem duplicação),
                                           filtradas por ubsId, userId ou status conforme a tela

denuncias/{denunciaId}                  → denúncias de avaliações, revisadas pelo admin

config/geral                            → configurações globais do app
legal/termosDeUso, legal/politicaPrivacidade → textos legais versionados
```

A segurança dos dados é garantida em duas camadas: validação client-side (para UX) e **Firestore Security Rules** (fonte de verdade real), que impõem as mesmas regras de negócio no servidor — incluindo a obrigatoriedade de moderação para avaliações com comentário.

## Regra de moderação de avaliações

Avaliação nasce com status:
- **`aprovada`** — quando contém apenas dados estruturados (nota, tempo de espera, lotação, medicamento), sem texto livre
- **`analise`** — quando inclui comentário escrito pelo usuário, aguardando revisão do administrador

Essa regra é reforçada tanto no usecase de criação/edição quanto nas Firestore Rules, impedindo que o cliente burle a moderação enviando um comentário já marcado como aprovado.

## Navegação

A navegação usa `go_router` com `ShellRoute`, mantendo Drawer e AppBar persistentes por área do app (usuário/visitante e administrador), com títulos gerados dinamicamente a partir da rota ativa. O acesso a rotas é controlado por um `redirect` centralizado, que reage ao estado de autenticação em tempo real.

## Status do projeto

Em desenvolvimento. Próximas implementações planejadas incluem evolução da tela inicial de busca para um sistema de filtros (categoria, status de funcionamento, nota mínima) e refinamentos no painel administrativo.

## Aspectos legais

O projeto reutiliza dados públicos governamentais (CNES/DATASUS) sob licença de dados abertos, com atribuição de fonte. Antes da publicação em lojas de aplicativos, itens como política de privacidade, termos de uso e conformidade com a LGPD devem ser finalizados — consulte a documentação interna do projeto para o checklist completo.

## Licença

*(defina aqui a licença do repositório, caso ainda não tenha escolhido uma — ex: MIT, Apache 2.0)*
