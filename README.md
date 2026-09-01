# 🏥 Avalia UBS

Aplicativo mobile desenvolvido em **Flutter** para avaliação e consulta de **Unidades Básicas de Saúde (UBS)**. O projeto permite que usuários encontrem unidades de saúde, consultem informações e registrem avaliações sobre os serviços prestados.

O projeto foi desenvolvido com foco em **desenvolvimento mobile, integração com Firebase, persistência de dados, geolocalização e experiência do usuário**.

---

## 📱 Sobre o projeto

O **Avalia UBS** tem como objetivo facilitar o acesso a informações sobre Unidades Básicas de Saúde e permitir que usuários compartilhem suas experiências com os serviços oferecidos.

A aplicação permite consultar UBS cadastradas, visualizar informações da unidade e realizar avaliações relacionadas à qualidade do atendimento.

O projeto também foi utilizado como oportunidade para aplicar conceitos de:

* Desenvolvimento mobile com Flutter
* Gerenciamento de estado
* Autenticação de usuários
* Banco de dados NoSQL
* Integração com serviços do Firebase
* Geolocalização
* Consumo e tratamento de dados
* Arquitetura e organização de código
* Testes e versionamento com Git

---

## ✨ Funcionalidades

### 👤 Usuários

* Cadastro de usuários
* Login e autenticação
* Gerenciamento de informações do usuário
* Controle de acesso às funcionalidades da aplicação

### 🏥 Unidades de Saúde

* Listagem de UBS
* Visualização dos dados da unidade
* Informações de localização
* Consulta de unidades próximas
* Visualização da localização utilizando latitude e longitude

### ⭐ Avaliações

* Avaliação das unidades de saúde
* Registro das experiências dos usuários
* Consulta das avaliações realizadas
* Organização das informações para facilitar a visualização

### 🔎 Pesquisa

* Pesquisa de unidades por nome
* Filtros e consultas no banco de dados
* Tratamento de informações para melhorar a busca

### 🔐 Administração

O projeto também possui funcionalidades administrativas para gerenciamento das informações utilizadas pela aplicação.

---

## 🛠️ Tecnologias utilizadas

### Mobile

* **Flutter**
* **Dart**
* Material Design

### Gerenciamento de estado

* **Provider**

### Backend / Serviços

* **Firebase Authentication**
* **Cloud Firestore**

### Banco de dados

* **Cloud Firestore**

### Desenvolvimento

* **Git**
* **GitHub**
* **VS Code**
* Android Studio

---

## 🏗️ Arquitetura

O projeto foi estruturado buscando separar responsabilidades entre apresentação, gerenciamento de estado, modelos e acesso aos dados.

Uma estrutura simplificada do projeto:

```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
│
├── models/
│   ├── ubs_model.dart
│   └── user_model.dart
│
├── entities/
│   └── ubs_entity.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── ubs_provider.dart
│   └── admin_provider.dart
│
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
│
├── screens/
│   ├── login/
│   ├── home/
│   ├── ubs/
│   ├── evaluation/
│   └── admin/
│
├── widgets/
│
└── main.dart
```

> A estrutura pode variar conforme a versão atual do projeto.

---

## 🔥 Firebase

O projeto utiliza o Firebase para fornecer recursos de backend.

### Firebase Authentication

Responsável pelo gerenciamento da autenticação dos usuários.

```text
Usuário
   │
   ▼
Firebase Authentication
   │
   ▼
Aplicação Flutter
```

### Cloud Firestore

Utilizado para armazenar informações relacionadas aos usuários, UBS e avaliações.

Exemplo simplificado:

```text
Firestore
│
├── users
│   └── {userId}
│
├── ubs
│   └── {ubsId}
│
└── avaliações
    └── {evaluationId}
```

As regras de segurança do Firestore são utilizadas para controlar quais operações podem ser realizadas por cada tipo de usuário.

---

## 📍 Geolocalização

As unidades possuem informações de localização utilizando coordenadas geográficas:

```text
Latitude
Longitude
```

Essas informações permitem trabalhar com a localização das UBS e futuramente possibilitam recursos como:

* UBS mais próxima
* Distância entre usuário e unidade
* Exibição em mapa
* Rotas até a unidade

---

## 🚀 Como executar o projeto

### Pré-requisitos

Antes de executar o projeto, certifique-se de possuir:

* Flutter instalado
* Dart SDK
* Android Studio ou outro ambiente compatível
* Android SDK
* Git
* Uma conta/projeto configurado no Firebase

Verifique a instalação do Flutter:

```bash
flutter doctor
```

---

### 📥 Clonando o projeto

```bash
git clone https://github.com/VictorsSMenezesV/avalia-ubs.git
```

Entre na pasta:

```bash
cd avalia-ubs
```

---

### 📦 Instalando as dependências

Execute:

```bash
flutter pub get
```

---

### 🔥 Configuração do Firebase

O projeto necessita de uma configuração válida do Firebase.

Caso esteja configurando o projeto em um novo ambiente, utilize o FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Depois:

```bash
flutterfire configure
```

Selecione o projeto Firebase e as plataformas desejadas.

> Não versione credenciais ou arquivos contendo informações sensíveis no repositório.

---

### ▶️ Executando

Com um dispositivo físico ou emulador conectado:

```bash
flutter run
```

Para verificar os dispositivos disponíveis:

```bash
flutter devices
```

---

## 🧪 Testes

Os testes podem ser executados através de:

```bash
flutter test
```

Para executar análise estática:

```bash
flutter analyze
```

---

## 🔄 CI/CD

O projeto também pode ser integrado a pipelines de **CI/CD utilizando GitHub Actions**.

Um pipeline pode executar automaticamente:

```text
Push / Pull Request
        │
        ▼
GitHub Actions
        │
        ├── flutter pub get
        │
        ├── flutter analyze
        │
        ├── flutter test
        │
        └── Build APK
```

Essa abordagem permite identificar problemas antes que alterações sejam integradas à branch principal.

---

## 📸 Screenshots

> Adicione aqui screenshots da aplicação para apresentar visualmente o projeto.

Exemplo:

```text
docs/
├── login.png
├── home.png
├── ubs_details.png
├── evaluation.png
└── profile.png
```

Depois, as imagens podem ser adicionadas ao README:

```markdown
![Tela inicial](docs/home.png)
```

---

## 🎯 Objetivos do projeto

O projeto foi desenvolvido para colocar em prática conhecimentos de desenvolvimento de aplicações mobile e integração com serviços backend.

Entre os principais objetivos estão:

* Desenvolver uma aplicação Flutter completa
* Trabalhar com arquitetura e separação de responsabilidades
* Implementar autenticação
* Trabalhar com banco de dados NoSQL
* Integrar o Flutter com Firebase
* Trabalhar com geolocalização
* Implementar gerenciamento de estado
* Aplicar boas práticas de desenvolvimento
* Utilizar Git e GitHub para versionamento

---

## 📚 Principais conhecimentos aplicados

Durante o desenvolvimento foram utilizados conceitos de:

**Flutter**

* Widgets
* Navegação
* Formulários
* Gerenciamento de estado
* Responsividade
* Ciclo de vida
* Integração com plugins

**Firebase**

* Authentication
* Cloud Firestore
* Regras de segurança
* Consultas e filtros
* Estruturação de coleções

**Desenvolvimento**

* Clean Code
* Separação de responsabilidades
* Modelos e entidades
* Tratamento de erros
* Debugging
* Versionamento com Git
* CI/CD

---

## 🔮 Próximas melhorias

Algumas funcionalidades que podem ser adicionadas ao projeto:

* [ ] Integração com mapas
* [ ] Cálculo de distância até a UBS
* [ ] Rotas utilizando localização do usuário
* [ ] Sistema de notificações
* [ ] Melhorias no sistema de avaliações
* [ ] Dashboard administrativo
* [ ] Testes unitários
* [ ] Testes de integração
* [ ] Testes automatizados de UI
* [ ] Melhorias de acessibilidade
* [ ] Pipeline completo de CI/CD

---

## 👨‍💻 Desenvolvedor

**Victor Souza Menezes Vicente**

Desenvolvedor com foco em **Flutter, Java, APIs REST, Docker, Linux e desenvolvimento Full Stack**.

### Tecnologias

```text
Flutter • Dart • Java • JavaScript • SQL
Firebase • REST APIs • Docker • Linux
Git • GitHub • MySQL • PostgreSQL • SQLite
```

---

## 📄 Licença

Este projeto foi desenvolvido para fins de **estudo, portfólio e demonstração de conhecimentos técnicos**.
