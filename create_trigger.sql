CREATE TRIGGER audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON my_table
FOR EACH ROW EXECUTE PROCEDURE audit_trigger_func();