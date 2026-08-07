# Movetech --Projeto Final

Ponto de partida da **Competência 3 — Desenvolvimento e Operação de Aplicações (DevOps)**.


> Parte do curso **Move Tech** — Magalu × Prósper Digital Skills  
> Formação em Cloud Computing 

---

## O que tem aqui

Uma API simples de micro e-commerce com pedidos e itens, construída em Python com FastAPI.

A aplicação armazena os dados em memória. Ainda não tem deploy na nuvem — isso é exatamente o que você vai fazer nesta competência.

### Endpoints disponíveis

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/health` | Verifica se a API está no ar |
| `POST` | `/orders` | Cria um novo pedido |
| `GET` | `/orders` | Lista todos os pedidos |
| `GET` | `/orders/{id}` | Retorna um pedido com seus itens |
| `DELETE` | `/orders/{id}` | Cancela um pedido |
| `POST` | `/orders/{id}/items` | Adiciona um item ao pedido |
| `GET` | `/orders/{id}/items` | Lista os itens de um pedido |

---

## O que você vai fazer nesta competência

Ao final da Competência 3, a aplicação deve estar **versionada, conteinerizada e publicada na Magalu Cloud**.

- [ ] Publicar a imagem no Container Registry da Magalu Cloud
- [ ] Criar o manifest Kubernetes (`k8s/app.yaml`)
- [ ] Fazer o deploy no cluster Kubernetes da Magalu Cloud
- [ ] Configurar o pipeline de CI/CD no GitHub Actions

---

## O Dockerfile

O repositório já inclui um `Dockerfile` pronto. Ele define como a aplicação é empacotada em uma imagem Docker:

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

O `docker-compose.yml` usa esse Dockerfile para construir e rodar a aplicação localmente. Na nuvem, o pipeline faz o mesmo — constrói a imagem e publica no registry.

> **Referência:** [Dockerfile — Documentação oficial Docker](https://docs.docker.com/reference/dockerfile/)

---

## Como rodar localmente

**Pré-requisito:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado (Mac e Windows) ou [Docker Engine](https://docs.docker.com/engine/install/) (Linux).

```bash
docker compose up --build
```

Acesse a documentação interativa em: http://localhost:8000/docs

---

> Inspirado no tutorial [Construindo APIs robustas utilizando Python](https://github.com/luizalabs/tutorial-python-brasil) do LuizaLabs.

# Competência 4 — Gestão de Dados e Persistência

Nesta competência, o objetivo é conectar a aplicação a um banco de dados PostgreSQL gerenciado na Magalu Cloud, garantindo que os dados persistam.  

## O que você vai fazer nesta competência

Ao final da Competência 4, os dados devem **persistir em banco de dados** mesmo quando o container reinicia.

O código de integração com o banco já está pronto neste repositório. Seu trabalho é modelar os dados, provisionar e conectar o banco na Magalu Cloud.

- [ ] Criar o documento de modelagem de dados da aplicação (`docs/data-model.md`)
- [ ] Criar uma instância PostgreSQL no DBaaS da Magalu Cloud
- [ ] Criar o Kubernetes Secret com a string de conexão (`DATABASE_URL`)
- [ ] Fazer o deploy da aplicação
- [ ] Validar que os dados persistem após reiniciar o container

---

## Como rodar localmente

**Pré-requisito:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado (Mac e Windows) ou [Docker Engine](https://docs.docker.com/engine/install/) (Linux).

```bash
docker compose up --build
```

Acesse a documentação interativa em: http://localhost:8000/docs

---

## Secrets necessários no GitHub

Configure estes secrets no seu repositório (Settings → Secrets and variables → Actions):

| Secret | Descrição |
|--------|-----------|
| `MGC_REGISTRY_USER` | Usuário do Container Registry da MGC |
| `MGC_REGISTRY_PASSWORD` | Senha do Container Registry da MGC |
| `MGC_REGISTRY_NAME` | Nome do seu registry na MGC |
| `MGC_KUBECONFIG` | Conteúdo do arquivo `kubeconfig.yaml` (cole o conteúdo diretamente) |
| `DATABASE_URL` | String de conexão do PostgreSQL (`postgresql://user:pass@host/orders`) |
---

# Competência 5 — Observabilidade e Resiliência

Nesta competência você vai configurar o monitoramento, criar alertas e observar como o Kubernetes se recupera de falhas automaticamente.

## O que você vai fazer nesta competência

Ao final da Competência 5, a aplicação deve estar **monitorada e resiliente**.

O código de observabilidade já está no repositório — logs em JSON, `/health` com verificação do banco, `/stats` com contagens e `/metrics` em formato Prometheus. Seu trabalho é configurar o monitoramento e observar a aplicação em produção.

- [ ] Fazer o deploy da aplicação
- [ ] Verificar os logs estruturados via `kubectl logs`
- [ ] Consultar `/health`, `/stats` e `/metrics` em produção
- [ ] Instalar Prometheus e Grafana via Helm no cluster K3s (`kube-prometheus-stack`)
- [ ] Criar o `ServiceMonitor` e confirmar a aplicação como target UP no Prometheus
- [ ] Simular uma falha e observar a recuperação automática pelo Kubernetes

---

## Como rodar localmente

**Pré-requisito:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado (Mac e Windows) ou [Docker Engine](https://docs.docker.com/engine/install/) (Linux).

```bash
docker compose up --build
```

Acesse a documentação interativa em: http://localhost:8000/docs

---

## Secrets necessários no GitHub

| Secret | Descrição |
|--------|-----------|
| `MGC_REGISTRY_USER` | Usuário do Container Registry da MGC |
| `MGC_REGISTRY_PASSWORD` | Senha do Container Registry da MGC |
| `MGC_REGISTRY_NAME` | Nome do seu registry na MGC |
| `MGC_KUBECONFIG` | Conteúdo do arquivo `kubeconfig.yaml` (cole o conteúdo diretamente) |
| `DATABASE_URL` | String de conexão do PostgreSQL (`postgresql://user:pass@host/orders`) |

---

# Competência 6 — Arquitetura de Soluções em Nuvem

Você construiu uma aplicação completa na nuvem — com deploy automatizado, banco de dados gerenciado e observabilidade. Agora chegou a hora de documentar e analisar o que foi construído: entender as decisões técnicas, os trade-offs envolvidos e como a arquitetura pode evoluir.

## O que você vai fazer nesta competência

Ao final da Competência 6, você terá **documentado e analisado a arquitetura** da solução que construiu.

- [ ] Desenhar o diagrama de arquitetura da solução na Magalu Cloud
- [ ] Documentar as decisões técnicas tomadas ao longo do curso (ADR)
- [ ] Analisar os trade-offs das escolhas: custo, escalabilidade, disponibilidade
- [ ] Identificar pontos de melhoria e próximos passos

---

## Como rodar localmente

**Pré-requisito:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado (Mac e Windows) ou [Docker Engine](https://docs.docker.com/engine/install/) (Linux).

```bash
docker compose up --build
```

Acesse a documentação interativa em: http://localhost:8000/docs

---

## Secrets necessários no GitHub

| Secret | Descrição |
|--------|-----------|
| `MGC_REGISTRY_USER` | Usuário do Container Registry da MGC |
| `MGC_REGISTRY_PASSWORD` | Senha do Container Registry da MGC |
| `MGC_REGISTRY_NAME` | Nome do seu registry na MGC |
| `MGC_KUBECONFIG` | Conteúdo do arquivo `kubeconfig.yaml` (cole o conteúdo diretamente) |
| `DATABASE_URL` | String de conexão do PostgreSQL (`postgresql://user:pass@host/orders`) |
---

## Deploy e observabilidade

O workflow `Deploy` publica a imagem no Container Registry e aplica os manifestos em `k8s/`:

- `app.yaml`: Deployment com duas réplicas, probes de saúde (`/health`), recursos de CPU/memória e Service do tipo `LoadBalancer`;
- `hpa.yaml`: HPA baseado em utilização de CPU, mantendo entre 2 e 6 réplicas;
- `servicemonitor.yaml`: ServiceMonitor que coleta as métricas da aplicação em `/metrics` a cada 15 segundos.

O HPA requer que o cluster tenha o Metrics Server instalado. O ServiceMonitor requer o Prometheus Operator e utiliza o label `release: monitoring`; ajuste esse valor caso o nome da instalação do Prometheus no cluster seja diferente.

O endpoint `/metrics` é disponibilizado pelo `prometheus-fastapi-instrumentator`. O `Service` possui o label `app: cloud-application`, usado pelo ServiceMonitor para localizar os pods da aplicação.

## Teste de carga com k6

O workflow manual `Teste de carga (k6)` executa `load/k6/load-test.js` contra a aplicação implantada. Para executá-lo:

1. Acesse **Actions > Teste de carga (k6) > Run workflow**.
2. Informe a URL pública do Service (`base_url`), a quantidade de usuários virtuais (`vus`), a duração do patamar (`duration`), o tempo de rampa (`ramp`) e o SLO de P95 (`p95_alvo_ms`).
3. Consulte o resumo gerado no GitHub Actions e os artefatos `resumo.md` e `resultado.json`.

O teste valida o health check, criação e consulta de pedidos, inclusão de itens, listagem de pedidos, taxa de erros e latência P95. Os valores padrão são 20 VUs, 2 minutos de carga, rampa de 30 segundos e P95 máximo de 500 ms.

## Solução completa de referência

Ao concluir esta competência, a solução final de referência estará disponível em:  
[move-tech-cloud-application-final](https://github.com/move-tech-cloud-computing/move-tech-cloud-application-final)
