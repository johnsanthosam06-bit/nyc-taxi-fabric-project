CREATE procedure stg.stg_data_cleaning
@startdate DATETIME2,
@enddate DATETIME2
as 
delete from stg.nyctaxi_yellow where stg.nyctaxi_yellow.tpep_pickup_datetime < @startdate or stg.nyctaxi_yellow.tpep_pickup_datetime > @enddate;
