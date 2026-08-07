# ADR 001 - Usar K3s para deploy da aplicação
**Status:** Aceito
**Data:** 2026-08-04

## Contexto
A aplicação precisa ser implantada na Magalu Cloud de forma acessível publicamente, resiliente a falhas e com capacidade de escalar.

## Alternativas consideradas
- **K3s em VM:** Kubernetes leve; cobra só a VM; provisionamento < 2 min; sem alta disponibilidade nativa[cite: 1].
- **MKS (Kubernetes Gerenciado):** Control plane e alta disponibilidade gerenciados; custo maior; provisionamento de 5 a 10 min[cite: 1].
- **VM com Docker Compose:** Mais simples de subir; sem orquestração, self-healing nem escala declarativa[cite: 1].

## Decisão
Usar K3s em uma VM BV2-2-40 (Ubuntu 24.04) com Klipper ServiceLB para expor a aplicação na porta 80 do IP público da VM[cite: 1]. O script `k3s-mgc` automatiza todo o provisionamento[cite: 1]. Critério: menor custo e provisionamento mais rápido, com manifests idênticos a qualquer Kubernetes[cite: 1].

## Consequências
**Positivas:**
- Custo menor que o MKS (cobra apenas pela VM e não pelo control plane)[cite: 1]
- Provisionamento em menos de 2 minutos[cite: 1]
- Manifests YAML idênticos a qualquer Kubernetes padrão (sem lock-in)[cite: 1]
- Restart automático em caso de falha (*liveness probe*)[cite: 1]
- Escalabilidade horizontal simples (basta aumentar o número de réplicas)[cite: 1]

**Negativas:**
- *Single point of failure*: sem alta disponibilidade nativa (tudo em uma VM)[cite: 1]
- Armazenamento efêmero: volumes locais desaparecem se a VM for recriada[cite: 1]
- Sem *auto-scaling* de nós: capacidade fixa (2 vCPU, 2 GB)[cite: 1]
- IP público muda se a VM for substituída[cite: 1]