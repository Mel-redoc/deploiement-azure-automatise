# Deploiement Azure Automatise - CI/CD avec ASP.NET Core

Projet L3 Informatique de Gestion - ENI - Projets .NET 2026

## Description

Application ASP.NET Core Web API couplee a un pipeline CI/CD complet via GitHub Actions, permettant :
- Build et tests automatises (xUnit)
- Analyse de qualite de code (SonarCloud)
- Conteneurisation (Docker)
- Deploiement continu vers deux environnements (staging et production)
- Rollback automatique en cas d'echec du controle de sante

## Architecture
┌─────────────┐ ┌──────────────┐ ┌─────────────────┐
│ GitHub │───▶│ GitHub │───▶│ SonarCloud │
│ (push) │ │ Actions │ │ (qualité code) │
└─────────────┘ └──────┬───────┘ └─────────────────┘
│
┌──────▼───────┐
│ Staging │
│ (Render.com)│
└──────┬───────┘
│ health check OK
┌──────▼───────┐
│ Production │
│ (Render.com)│
└──────────────┘

## Stack technique

- **Backend** : ASP.NET Core (.NET 10), Web API
- **Tests** : xUnit, Microsoft.AspNetCore.Mvc.Testing (tests d'integration)
- **Qualite de code** : SonarCloud
- **Conteneurisation** : Docker (multi-stage build)
- **CI/CD** : GitHub Actions
- **Hebergement** : Render.com (staging + production)

## Pipeline CI/CD

Le pipeline (.github/workflows/ci-cd.yml) se declenche a chaque push sur main et comprend 3 jobs sequentiels :

1. **Build, Test and Analyze** : restauration des dependances, build, execution des tests, analyse SonarCloud
2. **Deploy to Staging** : deploiement sur l'environnement de staging, verification du endpoint /health
3. **Deploy to Production** : deploiement en production (uniquement si staging reussit), verification de sante, rollback automatique si echec

## Endpoints disponibles

| Endpoint | Description |
|---|---|
| /health | Verifie que l'application est operationnelle |
| /weatherforecast | Endpoint d'exemple (donnees meteo aleatoires) |
| /swagger | Documentation interactive de l'API |

## Lancer le projet en local

```bash
git clone https://github.com/Mel-redoc/deploiement-azure-automatise.git
cd deploiement-azure-automatise
dotnet restore
dotnet build
dotnet run --project src/MonApi
```

L'API sera accessible sur http://localhost:5255/swagger

## Lancer avec Docker

```bash
docker build -t monapi .
docker run -d -p 8080:8080 monapi
```

L'API sera accessible sur http://localhost:8080/health

## Lancer les tests

```bash
dotnet test
```

## Environnements deployes

- **Staging** : https://monapi-staging.onrender.com/health
- **Production** : https://monapi-production.onrender.com/health

## Qualite de code

Rapport SonarCloud disponible ici : https://sonarcloud.io/project/overview?id=Mel-redoc_deploiement-azure-automatise

## Auteur

**Mel** (Mel-redoc) - ENI, L3 Informatique de Gestion
