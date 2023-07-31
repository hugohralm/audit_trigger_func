# Script de Auditoria PostgreSQL

Este projeto consiste em um script de auditoria para PostgreSQL que armazena todas as alterações feitas em qualquer tabela do banco de dados. Ele é útil para rastrear atividades de Insert, Update e Delete, juntamente com informações de quem executou a ação.

## Configuração

1. **Criação da tabela de auditoria:**

   Primeiro, criamos uma tabela chamada `audit_logs` onde armazenaremos todos os logs de auditoria. Ela tem as seguintes colunas:

   - `id`: uma chave primária autoincrementável.
   - `table_name`: o nome da tabela onde a operação foi realizada.
   - `row_id`: o ID da linha que foi alterada.
   - `operation`: o tipo de operação (INSERT, UPDATE, DELETE).
   - `changes`: um campo de texto que armazena um objeto JSON com as alterações. Para operações de UPDATE, ele contém o valor antigo e o novo valor de cada campo alterado.
   - `executed_by`: o usuário que executou a operação.
   - `updated_at`: a data e hora em que a operação foi realizada.

2. **Criação da função de gatilho:**

   A função `audit_trigger_func` é chamada sempre que uma operação de INSERT, UPDATE ou DELETE é realizada em uma tabela. Esta função coleta informações sobre a operação e insere um registro na tabela `audit_logs`.

   - Para operações de UPDATE, a função compara o valor antigo e o novo valor de cada campo. Se um campo foi alterado, a função armazena o valor antigo e o novo valor na coluna `changes`.
   - Para operações de DELETE, a função armazena todos os valores da linha que foi excluída na coluna `changes`.
   - Para operações de INSERT, a função armazena todos os valores da nova linha na coluna `changes`.

3. **Criação do gatilho:**

   Finalmente, criamos um gatilho `audit_trigger` que chama a função `audit_trigger_func` sempre que uma operação de INSERT, UPDATE ou DELETE é realizada em uma tabela.

   Observe que este gatilho é definido para uma tabela específica (`my_table` neste exemplo). Se você quiser rastrear operações em várias tabelas, precisará criar um gatilho para cada uma.

## Como usar

Após a configuração, o sistema de auditoria funcionará automaticamente. Sempre que uma operação de INSERT, UPDATE ou DELETE for realizada em uma tabela monitorada, um novo registro será inserido na tabela `audit_logs`.

Você pode consultar a tabela `audit_logs` a qualquer momento para ver o histórico de operações.

## Contribuição

Contribuições para o projeto são sempre bem-vindas. Se você encontrou um bug ou tem uma ideia para uma nova funcionalidade, sinta-se à vontade para abrir uma issue ou um pull request.
