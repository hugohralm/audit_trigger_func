CREATE SCHEMA IF NOT EXISTS audit;

CREATE TABLE audit.audit_logs (
    id serial4 NOT NULL,
    table_name varchar(150) NOT NULL,
    row_id varchar(50) NULL,
    operation varchar(50) NOT NULL,
    changes jsonb NULL,
    executed_by varchar(150) NOT NULL,
    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT audit_logs_pkey PRIMARY KEY (id)
);
