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
