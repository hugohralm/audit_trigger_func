# PostgreSQL Auditing Script

This project consists of an auditing script for PostgreSQL that logs all changes made to any table in the database. It is useful for tracking Insert, Update, and Delete activities, along with information about who performed the operation.

## Setup

1. **Creating the audit table:**

   First, we create a table called `audit_logs` where we will store all audit logs. It has the following columns:

   - `id`: An auto-incrementing primary key.
   - `table_name`: The name of the table where the operation was performed.
   - `row_id`: The ID of the row that was altered.
   - `operation`: The type of operation (INSERT, UPDATE, DELETE).
   - `changes`: A text field that stores a JSON object with the changes. For UPDATE operations, it contains the old and new value of each altered field.
   - `executed_by`: The user who executed the operation.
   - `updated_at`: The date and time the operation was performed.

2. **Creating the trigger function:**

   The `audit_trigger_func` function is invoked whenever an INSERT, UPDATE, or DELETE operation is performed on a table. This function collects information about the operation and inserts a record into the `audit_logs` table.

   - For UPDATE operations, the function compares the old and new value of each field. If a field was changed, the function stores the old and new values in the `changes` column.
   - For DELETE operations, the function stores all values of the row that was deleted in the `changes` column.
   - For INSERT operations, the function stores all values of the new row in the `changes` column.

3. **Creating the trigger:**

   Finally, we create a trigger named `audit_trigger` that calls the `audit_trigger_func` function whenever an INSERT, UPDATE, or DELETE operation is performed on a table.

   Note that this trigger is defined for a specific table (in this example, `my_table`). If you want to track operations on multiple tables, you will need to create a trigger for each one.

## How to Use

After setup, the auditing system will operate automatically. Whenever an INSERT, UPDATE, or DELETE operation is performed on a monitored table, a new record will be inserted into the `audit_logs` table.

You can query the `audit_logs` table at any time to see the history of operations.

## Contributing

Contributions to the project are always welcome. If you've found a bug or have an idea for a new feature, feel free to open an issue or a pull request.
