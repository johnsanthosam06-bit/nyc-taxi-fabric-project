create procedure metadata.insert_processing_log
@pipeline_run_id VARCHAR (255),
@table_processed VARCHAR (255),
@processed_date DATETIME2
AS
insert into metadata.processing_log(pipeline_run_id ,table_processed,rows_processed,latest_processed_pickup,processed_date_time)
select @pipeline_run_id as pipeline_run_id,
@table_processed as table_processed,
count(*) as rows_processed,
max(tpep_pickup_datetime) as latest_processed_pickup,
@processed_date as processed_date_time
from stg.nyctaxi_yellow;