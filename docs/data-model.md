# Modelagem de Dados

## Entidades

### Pedido (orders)

| Coluna       | Tipo                      | Descrição                                                  |
|--------------|---------------------------|--------------------------------------------------------------|
| id           | String (UUID)             | Identificador único do pedido, gerado automaticamente        |
| customer     | String                    | Nome do cliente que fez o pedido                              |
| status       | String                    | Status do pedido (padrão: open)                                |
| created_at   | DateTime (com timezone)   | Data/hora de criação do pedido, em UTC                         |

### Item (items)

| Coluna       | Tipo                      | Descrição                                                  |
|--------------|---------------------------|--------------------------------------------------------------|
| id           | String (UUID)             | Identificador único do item, gerado automaticamente           |
| order_id     | String (FK -> orders.id)  | Referência ao pedido ao qual o item pertence                   |
| sku          | String                    | Código (SKU) do produto                                        |
| description  | String                    | Descrição do item                                               |
| quantity     | Integer                   | Quantidade do item no pedido                                    |

## Relacionamento

Um Pedido (Order) pode conter múltiplos Itens (Items) — relacionamento 1:N.

- Cada Item referencia um único Order através da coluna order_id (chave estrangeira).
- A relação usa cascade="all, delete-orphan": ao excluir um pedido, todos os itens associados a ele são excluídos automaticamente junto.
- Representação simplificada: Order (1) se relaciona com N registros de Item, ligados pela coluna order_id.

## Como as tabelas são criadas

As tabelas são criadas automaticamente pela aplicação na inicialização, via SQLAlchemy, através do comando Base.metadata.create_all(bind=engine).

Isso significa que não há necessidade de rodar migrations manuais nesta etapa do projeto — ao conectar a aplicação a um novo banco PostgreSQL (vazio), as tabelas orders e items são criadas automaticamente na primeira execução, desde que o banco de dados (orders) já exista previamente no servidor.
