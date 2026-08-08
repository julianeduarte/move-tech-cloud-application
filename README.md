# MoveTech — Projeto Final

> Parte do curso **Move Tech** — Magalu × Prósper Digital Skills  
> Formação em Cloud Computing 

---

## 📌 Sobre o Projeto

Este repositório consolida a trilha prática completa da Formação em Cloud Computing. Evoluímos dos fundamentos de infraestrutura até uma aplicação **Cloud Native** robusta, escalável e resiliente, operando integralmente na Magalu Cloud.

### 🛠 Tecnologias Utilizadas

- **Linguagens e Frameworks:** Python 3.11, FastAPI, SQLAlchemy, JavaScript (k6), Shell Script.
- **DevOps e Infraestrutura:** Docker, Docker Compose, Kubernetes (K3s), Magalu Cloud (Container Registry, DBaaS, VMs).
- **Automação e Monitoramento:** GitHub Actions (CI/CD), Prometheus, Grafana, k6 (Testes de Carga).

---

## 📂 Estrutura do Repositório

```text
├── .github/workflows/  # Pipelines de CI/CD (Deploy automatizado e testes)
├── app/                # Código-fonte da API REST (FastAPI, modelos e lógica)
├── docs/               # Documentação de Arquitetura, ADRs e Modelagem de Dados
├── k8s/                # Manifestos Kubernetes (Deployment, Service, ServiceMonitor)
├── load/k6/            # Scripts de teste de carga em JavaScript
├── tests/               # Testes automatizados da aplicação
├── .gitignore          # Arquivos ignorados pelo Git
├── Dockerfile          # Receita de empacotamento da aplicação
├── docker-compose.yml  # Orquestração local para desenvolvimento
├── pyproject.toml      # Gerenciamento de dependências via Poetry
└── run-load-test.sh    # Script Shell para execução de testes
```

## 🧠 Competências 1 e 2 — Fundamentos e Serviços Essenciais de Cloud

As bases técnicas e operacionais que sustentam toda a arquitetura desenvolvida:

- **Competência 1 (Fundamentos de Sistemas e Infraestrutura):** Focada no domínio do sistema operacional Linux, hierarquia FHS, gerenciamento de processos, permissões granulares (modelo RWX e octal), redes básicas e automação de rotinas utilizando scripts em Bash.
- **Competência 2 (Serviços Essenciais de Cloud Computing):** Introdução aos blocos de construção da nuvem (IaaS, PaaS, SaaS), compreendendo o uso de Máquinas Virtuais, instâncias de banco de dados gerenciadas (DBaaS), arquitetura de redes virtuais (VPC, sub-redes públicas e privadas) e estratégias de armazenamento.

## 🚀 Competência 3 — DevOps e Deploy

Ponto de partida para colocar a aplicação na nuvem de forma automatizada.

### O que foi feito:

- **Empacotamento:** Criação da imagem Docker utilizando o `Dockerfile`.
- **Container Registry:** Publicação das imagens no Container Registry da Magalu Cloud.
- **Deploy no Kubernetes:** Configuração do cluster K3s na Magalu Cloud e aplicação dos manifests (`k8s/app.yaml`) com Liveness e Readiness Probes.
- **CI/CD:** Automação completa do fluxo de testes, build e deploy utilizando o GitHub Actions.

### O Dockerfile

O `docker-compose.yml` e o pipeline utilizam a seguinte estrutura de empacotamento:

```dockerfile
FROM python:3.11-slim          # Imagem base com Python 3.11

WORKDIR /app                   # Diretório de trabalho dentro do container

RUN pip install poetry==1.8.3  # Instala o gerenciador de dependências

COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.create false && \
    poetry install --without dev --no-root  # Instala apenas as dependências de produção

COPY app/ ./app/               # Copia o código da aplicação

EXPOSE 8000                    # Porta que a aplicação vai escutar

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Endpoints disponíveis na API

| **Método** | **Rota**             | **Descrição**                    |
| ---------- | --------------------- | --------------------------------- |
| `GET`      | `/health`             | Verifica se a API está no ar     |
| `POST`     | `/orders`             | Cria um novo pedido              |
| `GET`      | `/orders`             | Lista todos os pedidos           |
| `GET`      | `/orders/{id}`        | Retorna um pedido com seus itens |
| `DELETE`   | `/orders/{id}`        | Cancela um pedido                |
| `POST`     | `/orders/{id}/items`  | Adiciona um item ao pedido       |
| `GET`      | `/orders/{id}/items`  | Lista os itens de um pedido      |

## 💾 Competência 4 — Gestão de Dados e Persistência

Evolução da persistência para garantir que os dados não se percam ao reiniciar os pods.

### O que foi feito:

- **Modelagem de Dados:** Documentação detalhada estruturada em `docs/data-model.md`.
- **DBaaS Magalu Cloud:** Provisionamento de uma instância PostgreSQL gerenciada na nuvem.
- **Segurança:** Configuração da string de conexão injetada de forma segura no cluster através de **Kubernetes Secrets** (`db-secret`).
- **Validação:** Confirmação da persistência dos dados mesmo após novos deploys e reinicializações.

### Secrets necessários no GitHub

| Secret | Descrição |
|--------|-----------|
| `MGC_REGISTRY_USER` | Usuário do Container Registry da MGC |
| `MGC_REGISTRY_PASSWORD` | Senha do Container Registry da MGC |
| `MGC_REGISTRY_NAME` | Nome do seu registry na MGC |
| `MGC_KUBECONFIG` | Conteúdo do arquivo `kubeconfig.yaml` (cole o conteúdo diretamente) |
| `DATABASE_URL` | String de conexão do PostgreSQL (`postgresql://user:pass@host/orders`) |
---

## 📈 Competência 5 — Observabilidade e Resiliência

Configuração de monitoramento avançado e garantia de alta disponibilidade no Kubernetes.

### O que foi feito:

- **Observabilidade:** Instrumentação com logs estruturados em JSON, endpoints dedicados (`/health`, `/stats`) e métricas no formato Prometheus (`/metrics`) geradas pelo `prometheus-fastapi-instrumentator`.
- **Monitoramento Centralizado:** Instalação do Prometheus e Grafana via Helm no cluster, utilizando o `ServiceMonitor` para coleta automática de métricas.
- **Resiliência:** Validação das liveness e readiness probes — simulação de falha de pod e confirmação da recuperação automática pelo Kubernetes.

## 📐 Competência 6 — Arquitetura de Soluções em Nuvem

Documentação formal e análise crítica do ecossistema construído.

### O que foi feito:

- **Diagramas de Arquitetura:** Modelagem da solução completa implementada na Magalu Cloud.
- **ADRs (Architecture Decision Records):** Documentação formal de todas as decisões técnicas e trade-offs adotados (custo, disponibilidade, escolha de banco gerenciado vs. auto-hospedado).

## ⚡ Teste de Carga com k6

Como iniciativa adicional ao escopo proposto pelo projeto, foi implementada uma estrutura de testes de carga utilizando **k6**, com o objetivo de avaliar o comportamento da aplicação sob condições de estresse e ampliar a validação de sua performance.

* **Scripts de teste:** Criação da pasta **`load/k6`**, contendo scripts de testes de carga escritos em **JavaScript**, linguagem utilizada pelo k6 para definir os cenários e comportamentos dos testes.
* **Automação:** Criação do arquivo **`run-load-test.sh`** na raiz do projeto, um script em **Shell** desenvolvido para automatizar a execução dos testes de carga.
* **Execução:** A combinação entre os scripts em **k6 (JavaScript)** e o script de automação em **Shell** permite executar os testes de forma simplificada e reproduzível.

### Como executar localmente:

```bash
./run-load-test.sh
```

O teste valida o comportamento dos endpoints de pedidos sob estresse, checando taxas de erro e garantindo que a latência P95 permaneça dentro dos limites aceitáveis.

## ⚙️ Como Rodar Localmente

**Pré-requisito:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado.

```bash
docker compose up --build
```

Acesse a documentação interativa em: `http://localhost:8000/docs`

## 🏁 Conclusão da Jornada

Este repositório consolida a trilha prática da Formação em Cloud Computing (Move Tech — Magalu × Prósper Digital Skills). Ao longo das Competências 1 a 6, evoluímos desde a base de sistemas operacionais e redes até uma aplicação **Cloud Native** robusta, escalável e resiliente, operando integralmente na nuvem.

**Principais entregas e tecnologias aplicadas:**

- **Fundamentos e Serviços de Nuvem:** Domínio de ambientes Linux, redes privadas (VPC) e arquiteturas de computação e armazenamento.
- **DevOps e Conteinerização:** Empacotamento com Docker e automação de CI/CD via GitHub Actions para deploy contínuo no Kubernetes.
- **Persistência e Segurança:** Utilização de banco de dados PostgreSQL (DBaaS) e gestão segura de credenciais com Kubernetes Secrets.
- **Observabilidade e Resiliência:** Instrumentação com logs estruturados, health checks, Prometheus, Grafana e recuperação automática de pods.
- **Arquitetura e Performance:** Documentação de decisões técnicas (ADRs), diagramas de arquitetura e testes de carga automatizados com k6.

O resultado é uma infraestrutura moderna, bem documentada e preparada para produção, refletindo as melhores práticas do mercado em engenharia de nuvem.

> Inspirado no tutorial [Construindo APIs robustas utilizando Python](https://github.com/luizalabs/tutorial-python-brasil) do LuizaLabs.