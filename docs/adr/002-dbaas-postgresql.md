# ADR 002 - Usar DBaaS PostgreSQL da Magalu Cloud
**Status:** Aceito
**Data:** 2026-08-04

## Contexto
A aplicação precisa de persistência de dados[cite: 1]. O banco precisa sobreviver a reinicializações de containers e estar disponível para múltiplas réplicas da API simultaneamente[cite: 1].

## Alternativas consideradas
- **DBaaS PostgreSQL gerenciado (externo):** Backup, patch e alta disponibilidade pelo provedor; custo maior; menos controle fino[cite: 1].
- **PostgreSQL em pod com PVC:** Custo baixo, tudo em um lugar; volume, backup e recuperação por nossa conta; o dado morre junto com o cluster[cite: 1].

## Decisão
Usar o serviço DBaaS PostgreSQL da Magalu Cloud — um banco gerenciado, sem necessidade de operar o servidor de banco de dados[cite: 1]. Critério: disponibilidade e custo de operação (estado é caro de operar manualmente)[cite: 1].

## Consequências
**Positivas:**
- Backup automático gerenciado pelo provedor[cite: 1]
- Sem custo operacional de administração do banco[cite: 1]
- Conexões simultâneas de múltiplos pods sem conflito[cite: 1]
- Alta disponibilidade incluída no serviço[cite: 1]

**Negativas:**
- Custo por hora de uso, mesmo com pouco tráfego[cite: 1]
- Menor controle sobre configurações avançadas do PostgreSQL[cite: 1]
- Dependência do provedor para upgrades de versão[cite: 1]