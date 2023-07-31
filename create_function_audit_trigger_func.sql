CREATE EXTENSION IF NOT EXISTS hstore;

CREATE OR REPLACE FUNCTION audit_trigger_func() RETURNS TRIGGER AS $audit_trigger_func$
DECLARE
    v_old_data JSONB;
    v_new_data JSONB;
    v_result JSONB := '{}'::JSONB;
    v_key TEXT;
    v_row_id TEXT := NULL;
BEGIN
    IF (TG_OP = 'INSERT') THEN
    	IF hstore(NEW) ? 'id' THEN
            v_row_id := NEW.id::text;
        END IF;
        v_result := to_jsonb(NEW);
    ELSEIF (TG_OP = 'DELETE') THEN
        IF hstore(OLD) ? 'id' THEN
            v_row_id := OLD.id::text;
        END IF;
        v_result := to_jsonb(OLD);
    ELSEIF (TG_OP = 'UPDATE') then
        IF hstore(NEW) ? 'id' THEN
            v_old_data := to_jsonb(OLD);
            v_new_data := to_jsonb(NEW);
            v_row_id := NEW.id::text;

            FOR v_key IN 
            SELECT key FROM jsonb_each_text(v_old_data)
            LOOP
                IF v_old_data -> v_key <> v_new_data -> v_key THEN
                    v_result = v_result || jsonb_build_object(v_key, jsonb_build_object('old', v_old_data -> v_key, 'new', v_new_data -> v_key));
                END IF;
            END LOOP;
        ELSE
            v_row_id := NULL;
            v_result := to_jsonb(NEW);
        END IF;
    END IF;

    -- Insert v_result into the audit table only if a change was made
    IF v_result <> '{}'::JSONB THEN
        INSERT INTO audit.audit_logs (table_name, row_id, operation, changes, executed_by) 
        VALUES (TG_TABLE_NAME, v_row_id, TG_OP, v_result, current_user);
    END IF;

    RETURN NEW;
END;
$audit_trigger_func$ LANGUAGE plpgsql;
