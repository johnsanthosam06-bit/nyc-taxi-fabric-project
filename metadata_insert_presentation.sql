create procedure metadata.insert_presentation_metadata
@pipeline_run_id VARCHAR(255),
@table_name VARCHAR(255),
@processed_date as DATETIME2
AS
insert into metadata.processing_log(pipeline_run_id ,table_processed,rows_processed,latest_processed_pickup,processed_date_time)
select @pipeline_run_id as pipeline_run_id,
@table_name as table_processed,
count(*) as rows_processed,
max(tpep_pickup) as latest_processed_pickup,
@processed_date as processed_date_time
from dbo.nyctaxi_yellow;