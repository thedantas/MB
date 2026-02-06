# CoinMarketCap iOS App

Projeto desenvolvido como desafio técnico para o Mercado Bitcoin.

## 📱 Sobre o Projeto

Aplicativo iOS que consome a API do CoinMarketCap para exibir informações sobre exchanges de criptomoedas, incluindo listagem de exchanges, detalhes de cada exchange e suas moedas disponíveis.

## 🏗️ Arquitetura

O projeto segue os princípios de **Clean Architecture** com **VIP-C** (VIP + Coordinator):

- **VIP-C (VIP + Coordinator)**: Separação clara de responsabilidades entre View, Interactor, Presenter e Coordinator
- **SOLID**: Princípios aplicados em todas as camadas
- **View Code**: Interface construída programaticamente (sem Storyboard)
- **Clean Architecture**: Separação em camadas (Domain, Data, Features)
- **Dependency Injection**: Container centralizado para gerenciamento de dependências
- **Protocol-Oriented**: Uso extensivo de protocolos para desacoplamento

### Estrutura de Camadas

```
CoinMarketCapApp
│
├── App                    # Configuração inicial e Coordinators
├── Core                   # Componentes compartilhados
│   ├── Networking         # HTTPClient, Endpoint, APIError
│   ├── DI                 # Dependency Injection Container
│   └── Utils              # Extensões e utilitários
├── Data                   # Camada de dados
│   ├── Services           # Implementação dos serviços
│   └── DTO                # Data Transfer Objects
├── Domain                 # Regras de negócio
│   ├── Models             # Entidades do domínio
│   └── UseCases           # Casos de uso
└── Features               # Features da aplicação
    ├── ExchangesList      # Lista de exchanges
    └── ExchangeDetail     # Detalhes da exchange
```

## ✨ Funcionalidades

- ✅ Listagem de Exchanges com volume e data de lançamento
- ✅ Detalhes da Exchange com descrição completa
- ✅ Listagem de moedas disponíveis na exchange
- ✅ Tratamento de erros com feedback visual
- ✅ Loading states durante requisições
- ✅ Interface moderna e responsiva
- ✅ Navegação fluida entre telas

## 🛠️ Tecnologias

- **Swift 5+**
- **UIKit** (View Code)
- **URLSession** para networking
- **XCTest** para testes unitários e UI
- **VIP-C** para arquitetura
- **SOLID** principles

## 📋 Pré-requisitos

- Xcode 14.0 ou superior
- iOS 15.0 ou superior
- API Key do CoinMarketCap

## 🚀 Como Rodar

1. Clone o repositório:
```bash
git clone <repository-url>
cd MB/CoinMarketCapApp
```

2. Configure a API Key:
   - Crie o arquivo `CoinMarketCapApp/.xcconfig/Secrets.xcconfig`
   - Adicione sua API Key:
   ```
   CMC_API_KEY = sua_api_key_aqui
   ```
   - ⚠️ **IMPORTANTE**: O arquivo `Secrets.xcconfig` está no `.gitignore` e não será commitado

3. Abra o projeto no Xcode:
```bash
open CoinMarketCapApp.xcodeproj
```

4. Build e execute o projeto (⌘ + R)

## 🧪 Testes

O projeto inclui testes unitários e testes de UI:

### Executar Testes Unitários
```bash
⌘ + U no Xcode
```

### Cobertura de Testes
- `ExchangesListInteractorTests`: Testa a lógica de negócio da lista de exchanges
- `ExchangeDetailInteractorTests`: Testa a lógica de negócio dos detalhes
- `MockHTTPClient`: Mock para testes de networking
- `AppUITests`: Testes de interface do usuário

## 📐 Decisões Técnicas

### VIP-C Architecture
- **View**: Responsável apenas pela apresentação visual
- **Interactor**: Contém a lógica de negócio
- **Presenter**: Formata dados para apresentação
- **Coordinator**: Gerencia navegação entre telas

### SOLID Principles
- **Single Responsibility**: Cada classe tem uma única responsabilidade
- **Open/Closed**: Extensível via protocolos, fechado para modificação
- **Liskov Substitution**: Implementações podem ser substituídas via protocolos
- **Interface Segregation**: Protocolos específicos e focados
- **Dependency Inversion**: Dependências via protocolos, não implementações concretas

### Networking
- Protocol `HTTPClient` permite fácil mock para testes
- `Endpoint` struct para construção de URLs
- Tratamento de erros com `APIError` enum

### Dependency Injection
- `AppContainer` centraliza todas as dependências
- Facilita testes e manutenção
- Permite troca de implementações facilmente

## 📁 Estrutura de Arquivos

```
CoinMarketCapApp/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
├── Core/
│   ├── Networking/
│   │   ├── HTTPClient.swift
│   │   ├── URLSessionHTTPClient.swift
│   │   ├── Endpoint.swift
│   │   └── APIError.swift
│   ├── DI/
│   │   └── AppContainer.swift
│   └── Utils/
│       └── DateFormatter+.swift
├── Data/
│   ├── Services/
│   │   └── CoinMarketCapService.swift
│   └── DTO/
│       ├── ExchangeDTO.swift
│       └── CurrencyDTO.swift
├── Domain/
│   ├── Models/
│   │   ├── Exchange.swift
│   │   └── Currency.swift
│   └── UseCases/
│       ├── FetchExchangesUseCase.swift
│       ├── FetchExchangeDetailUseCase.swift
│       └── FetchCurrenciesUseCase.swift
└── Features/
    ├── ExchangesList/
    │   ├── ExchangesListViewController.swift
    │   ├── ExchangesListView.swift
    │   ├── ExchangesListInteractor.swift
    │   ├── ExchangesListPresenter.swift
    │   ├── ExchangesListModels.swift
    │   └── ExchangesListCoordinator.swift
    └── ExchangeDetail/
        ├── ExchangeDetailViewController.swift
        ├── ExchangeDetailView.swift
        ├── ExchangeDetailInteractor.swift
        ├── ExchangeDetailPresenter.swift
        ├── ExchangeDetailModels.swift
        └── ExchangeDetailCoordinator.swift
```

## 🔒 Segurança

- API Key armazenada em arquivo `.xcconfig` local
- Arquivo `Secrets.xcconfig` adicionado ao `.gitignore`
- Nunca commitar credenciais no repositório

## 📝 Checklist de Submissão

- ✅ Repositório organizado e estruturado
- ✅ README claro e completo
- ✅ Arquitetura VIP-C implementada
- ✅ Código testável com testes unitários
- ✅ API Key protegida (não commitada)
- ✅ Sem Storyboard (View Code)
- ✅ UI fluida e moderna
- ✅ Padrões iOS respeitados
- ✅ SOLID aplicado
- ✅ Clean Architecture

## 👨‍💻 Autor

André Costa Dantas

## 📄 Licença

Este projeto foi desenvolvido como parte de um desafio técnico.
