create table metadata.processing_log
(
pipeline_run_id VARCHAR(100),
table_processed VARCHAR(200),
rows_processed int,
latest_processed_pickup DATETIME2(6),
processed_date_time DATETIME2(6)
);