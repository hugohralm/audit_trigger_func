CREATE OR REPLACE FUNCTION audit_trigger_func() RETURNS TRIGGER AS $audit_trigger_func$
DECLARE
    v_old_data JSONB;
    v_new_data JSONB;
    v_result JSONB := '{}'::JSONB;
    v_key TEXT;
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        v_old_data := to_jsonb(OLD);
        v_new_data := to_jsonb(NEW);

        FOR v_key IN 
        SELECT key FROM jsonb_each_text(v_old_data)
        LOOP
            IF v_old_data -> v_key <> v_new_data -> v_key THEN
                v_result = v_result || jsonb_build_object(v_key, jsonb_build_object('old', v_old_data -> v_key, 'new', v_new_data -> v_key));
            END IF;
        END LOOP;

        -- Insira v_result na tabela de auditoria
        INSERT INTO audit_logs (table_name, row_id, operation, changes, executed_by) 
        VALUES (TG_TABLE_NAME, NEW.id::text, TG_OP, v_result::text, current_user);
    ELSIF (TG_OP = 'DELETE') THEN
        v_old_data := to_jsonb(OLD);

        -- Insira v_old_data na tabela de auditoria
        INSERT INTO audit_logs (table_name, row_id, operation, changes, executed_by) 
        VALUES (TG_TABLE_NAME, OLD.id::text, TG_OP, v_old_data::text, current_user);
    ELSIF (TG_OP = 'INSERT') THEN
        v_new_data := to_jsonb(NEW);

        -- Insira v_new_data na tabela de auditoria
        INSERT INTO audit_logs (table_name, row_id, operation, changes, executed_by) 
        VALUES (TG_TABLE_NAME, NEW.id::text, TG_OP, v_new_data::text, current_user);
    END IF;
    RETURN NEW;
END;
$audit_trigger_func$ LANGUAGE plpgsql;
