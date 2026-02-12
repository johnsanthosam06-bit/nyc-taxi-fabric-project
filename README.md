# Microsoft Fabric Mini Project

## 📌 Project Overview
This project demonstrates end-to-end data analytics of Newyork Taxi details using Microsoft Fabric. I have used TLC Trip record data, stored in a Fabric Data Lakehouse, and transform it through staging and presentation layers using Data Factory activities, Dataflows, and Stored Procedures.

## 🛠 Tools Used
- Microsoft Fabric
- Power BI
- SQL
- Warehouse
- Dataflow Gen2
- JSON configuration
- Lakehouse

## 📊 Project Architecture
1. Data Ingestion
2. Data Transformation
3. Semantic Model Creation
4. Power BI Reporting

## 📁 Project Files
- SQL scripts for transformation
- JSON configuration files
- Power BI dashboard (.pbix)

## 📷 Dashboard Preview
<img width="2142" height="1050" alt="image" src="https://github.com/user-attachments/assets/205e0048-3f8c-4705-a29d-b2c4dd8b8783" />


 ## Code used in Pipeline: pl_stg_processing_nyctaxi

Overall Pipeline

<img width="2384" height="384" alt="image" src="https://github.com/user-attachments/assets/35866660-dd04-48f7-bcb2-f5a52586c901" />


Latest Processed Data
For the Script Activity “Latest Processed Data”

select top 1 
latest_processed_pickup 
from metadata.processing_log 
where table_processed = 'staging_nyctaxi_yellow'
order by latest_processed_pickup desc;


## v_date
Pipeline expression for v_date Set Variable activity

@formatDateTime(addToTime(activity('Latest Processed Date').output.resultSets[0].rows[0].latest_processed_pickup, 1, 'Month'), 'yyyy-MM')


## Copy to Staging

Pre Copy Script

<img width="1024" height="386" alt="image" src="https://github.com/user-attachments/assets/31f4e734-e4c0-4935-bbe8-a29c4d112cc1" />


## v_end_date
Pipeline expression for v_end_date Set Variable activity

@addToTime(concat(variables('v_date'), '-01'),1,'Month')

## SP Removing Outlier Dates
For the Stored Procedure Activity “SP Removing Outlier Dates”.

Create the Stored Procedure stg.data_cleaning_stg in the Data Warehouse using the code below.

CREATE procedure stg.stg_data_cleaning
@startdate DATETIME2,
@enddate DATETIME2
as 
delete from stg.nyctaxi_yellow where stg.nyctaxi_yellow.tpep_pickup_datetime < @startdate or stg.nyctaxi_yellow.tpep_pickup_datetime > @enddate;
<img width="1402" height="382" alt="image" src="https://github.com/user-attachments/assets/1aaea5e1-017f-4df5-8ef0-5bed0a6ec6aa" />


## SP Loading Staging Metadata
For the Stored Procedure Activity “SP Loading Staging Metadata”.

Code to create the metadata.processing_log table.
'''
create schema metadata;
'''
create table metadata.processing_log
(
	pipeline_run_id varchar(255), 
	table_processed varchar(255), 
	rows_processed INT, 
	latest_processed_pickup datetime2(6),
	processed_datetime datetime2(6)
);

Created the Stored Procedure metadata.insert_staging_metadata in the Data Warehouse using the code below.

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

<img width="1408" height="438" alt="image" src="https://github.com/user-attachments/assets/4fbccb68-47ec-46c2-82cb-48e2f84eb8fb" />

## 02. Code used in Pipeline: pl_pres_presentation_pipeline

This is a view of the pipeline using the Stored Procedure rather than the Dataflow Gen2. If you're using a Dataflow you can ignore the code for the SP Process Presentation activity

<img width="1108" height="294" alt="image" src="https://github.com/user-attachments/assets/ee3138f2-7fa6-419b-a231-f57fa48259db" />

## Create the dbo.nyctaxi_yellow table
This is the initial empty table so we can load the data from the Dataflow/Stored Procedure acivities

create table dbo.nyctaxi_yellow
(
vendor VARCHAR(50),
tpep_pickup date,
tpep_dropoff date,
pu_borough VARCHAR(200),
pu_zone VARCHAR(200),
do_borough VARCHAR(200),
do_zone VARCHAR(200),
payment_method VARCHAR(50),
passenger_count int,
trip_distance FLOAT,
total_amount FLOAT
);

## Before moving to presentation table , The data need to cleanse and transform using Dataflow gen2 . 

This is a view of the data model using Dataflow gen2 (df_presentation_nyctaxi).

<img width="2506" height="408" alt="image" src="https://github.com/user-attachments/assets/8da59988-f274-431d-b316-e904b303706d" />

<img width="2578" height="378" alt="image" src="https://github.com/user-attachments/assets/6ce52160-c4f3-45ed-af1f-6080686c9fb5" />


## SP Loading Presentation Metadata
For the Stored Procedure Activity “SP Loading Staging Metadata”.

Create the Stored Procedure metadata.insert_presentation_metadata in the Data Warehouse using the code below.

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

<img width="1366" height="434" alt="image" src="https://github.com/user-attachments/assets/c00ca92c-4095-496f-9f9b-efdcb4264835" />
