# Arquitetura da Solução

## Diagrama de Arquitetura (C2)

```mermaid
graph TD
    Client([Usuário / Tráfego Externo])
    
    subgraph GitHub
        Actions[GitHub Actions]
    end

    subgraph MGC [Magalu Cloud]
        Registry[Container Registry]
        DB[(DBaaS PostgreSQL)]
        
        subgraph VM [VM BV2-2-40 - K3s]
            LB[Klipper ServiceLB]
            API1[Pod 1 - cloud-application]
            API2[Pod 2 - cloud-application]
            
            LB -->|HTTP / Tráfego| API1
            LB -->|HTTP / Tráfego| API2
        end
    end

    Client -->|HTTP Request| LB
    API1 -->|PostgreSQL Protocol| DB
    API2 -->|PostgreSQL Protocol| DB
    
    Actions -->|Push Docker Image| Registry
    Actions -->|Deploy via kubectl| VM
    VM -.->|Pull Image| Registry
```

## Componentes da Arquitetura

| Componente | Serviço MGC | Função |
| :--- | :--- | :--- |
| **API** | K3s (VM single node) 2 réplicas | Processa as requisições HTTP[cite: 2] |
| **Banco de dados** | DBaaS PostgreSQL | Persiste pedidos e itens[cite: 2] |
| **Imagens** | Container Registry | Armazena versões da aplicação[cite: 2] |
| **Tráfego externo** | Klipper ServiceLB (IP da VM, porta 80) | Distribui entre as réplicas e fornece acesso externo[cite: 2] |
| **CI/CD** | GitHub Actions | Automatiza testes, build e deploy[cite: 2] |

## Requisitos Não-Funcionais

| Requisito | Como medir | Alvo |
| :--- | :--- | :--- |
| **Disponibilidade** | Erros 5xx e uptime das probes no Grafana[cite: 2] | 99,5% mensal[cite: 2] |
| **Latência** | `histogram_quantile(0.95, ...)` do `/metrics`[cite: 2] | P95 < 500 ms[cite: 2] |
| **Escalabilidade** | Teste de carga (k6) + `rate(http_requests_total)`[cite: 2] | 300 req/s sem degradar[cite: 2] |
| **Custo** | VM + DBaaS + IP na calculadora MGC[cite: 2] | Teto definido em ADR[cite: 2] |

## Estilo Arquitetural

A solução segue o estilo de um **monolito em camadas** (apresentação → serviço → dados), implantado como container único com duas réplicas[cite: 2]. O estilo-alvo, caso o domínio de notificações cresça, seria extrair um segundo serviço[cite: 2].

## Análise de Trade-offs

| Aspecto | Decisão tomada | Alternativa não escolhida | Motivo da escolha |
| :--- | :--- | :--- | :--- |
| **Deploy** | K3s em VM[cite: 2] | MKS (Kubernetes Gerenciado)[cite: 2] | Custo menor, provisionamento < 2 min, manifests idênticos[cite: 2] |
| **Banco** | DBaaS gerenciado[cite: 2] | PostgreSQL em container[cite: 2] | Backup automático, sem administração[cite: 2] |
| **CI/CD** | GitHub Actions[cite: 2] | Deploy manual[cite: 2] | Consistência e rastreabilidade[cite: 2] |
| **Réplicas** | 2 pods[cite: 2] | 1 pod[cite: 2] | Disponibilidade mínima sem custo excessivo[cite: 2] |
| **API** | FastAPI (Python)[cite: 2] | Node.js, Go, Java[cite: 2] | Curva de aprendizado baixa, alta produtividade[cite: 2] |

## Pontos de Melhoria e Próximos Passos

A aplicação é stateless, então escala na horizontal - mais réplicas atrás do balanceador[cite: 2]. Hoje são 2 réplicas fixas; o próximo passo natural é o HPA (Horizontal Pod Autoscaler), que ajusta esse número automaticamente pela utilização de CPU (ex.: mínimo 2, máximo 6, alvo de 70%)[cite: 2]. Vale registrar também que mais réplicas não resolvem um gargalo de banco - o PostgreSQL escala na vertical e costuma saturar primeiro[cite: 2].

| Melhoria | Por quê |
| :--- | :--- |
| **HTTPS/TLS** | Toda API em produção deve ser acessada por HTTPS[cite: 2] |
| **Autoscaler (HPA)** | Escala automaticamente conforme a carga[cite: 2] |
| **Versionamento de API** | `/v1/orders` permite evoluir sem quebrar clientes[cite: 2] |
| **Rate limiting** | Evita abuso e protege o banco de sobrecargas[cite: 2] |
| **Cache (Redis)** | Reduz consultas repetidas ao banco[cite: 2] |
| **Migrações de schema (Alembic)** | Controle de versão das mudanças no banco[cite: 2] |
| **Testes de carga** | Valida o comportamento sob alto tráfego[cite: 2] |
| **Migrar para MKS** | Quando precisar de HA real: basta trocar o kubeconfig - os manifests YAML são idênticos[cite: 2] |