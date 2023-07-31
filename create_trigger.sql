--"Cria triggers de auditoria para todas as tabelas no esquema atual, exceto 'audit_logs', usando a função audit_trigger_func()."
--"Creates audit triggers for all tables in the current schema, excluding 'audit_logs', using the audit_trigger_func() function."

DO $$ 
DECLARE 
   table_name TEXT;
BEGIN 
   -- Percorre todas as tabelas no esquema atual, ignorando 'audit_logs' e criando triggers.
   -- Loop through all tables in the current schema, ignoring 'audit_logs' and creating triggers.
   FOR table_name IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename <> 'audit_logs') 
   LOOP
      EXECUTE format('
         DROP TRIGGER IF EXISTS audit_trigger ON %I;
         CREATE TRIGGER audit_trigger
         AFTER INSERT OR UPDATE OR DELETE ON %I
         FOR EACH ROW EXECUTE PROCEDURE audit_trigger_func();
      ', table_name, table_name);
   END LOOP;
END $$;


--"Cria uma trigger audit_trigger que executa a função audit_trigger_func() após cada operação de INSERT, UPDATE ou DELETE em my_table."
--"Creates a trigger audit_trigger that executes the audit_trigger_func() function after each INSERT, UPDATE, or DELETE operation on my_table."
CREATE TRIGGER audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON my_table
FOR EACH ROW EXECUTE PROCEDURE audit_trigger_func();
