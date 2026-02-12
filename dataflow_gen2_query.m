let
  Source = Fabric.Warehouse(null),
  Navigation = Source{[workspaceId = "31c1992c-0ce4-444e-8bd1-25a3aba0dcd6"]}[Data],
  #"Navigation 1" = Navigation{[warehouseId = "e2dff097-9a16-4a73-b1ef-d17ad2703abb"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Schema = "stg", Item = "nyctaxi_yellow"]}[Data],
  #"Removed columns" = Table.RemoveColumns(#"Navigation 2", {"RatecodeID", "store_and_fwd_flag", "fare_amount", "extra", "mta_tax", "tip_amount", "tolls_amount", "improvement_surcharge", "congestion_surcharge", "Airport_fee", "cbd_congestion_fee"}),
  #"Inserted conditional column" = Table.AddColumn(#"Removed columns", "vendor", each if [VendorID] = 1 then "Creative Mobile Technologies" else if [VendorID] = 2 then "VeriFone" else "Unknown"),
  #"Reordered columns" = Table.ReorderColumns(#"Inserted conditional column", {"vendor", "VendorID", "tpep_pickup_datetime", "tpep_dropoff_datetime", "passenger_count", "trip_distance", "PULocationID", "DOLocationID", "payment_type", "total_amount"}),
  #"Removed columns 1" = Table.RemoveColumns(#"Reordered columns", {"VendorID"}),
  #"Inserted conditional column 1" = Table.AddColumn(#"Removed columns 1", "payment_method", each if [payment_type] = 1 then "Credit Card" else if [payment_type] = 2 then "Cash" else if [payment_type] = 3 then "No Charge" else if [payment_type] = 4 then "Dispute" else if [payment_type] = 5 then "Unknown" else if [payment_type] = 6 then "Voided Trip" else "Unknown"),
  #"Removed columns 2" = Table.RemoveColumns(#"Inserted conditional column 1", {"payment_type"}),
  #"Renamed columns" = Table.RenameColumns(#"Removed columns 2", {{"PULocationID", "pu_location_id"}, {"DOLocationID", "do_location_id"}}),
  #"Calculated date" = Table.TransformColumns(#"Renamed columns", {{"tpep_pickup_datetime", each DateTime.Date(_), type nullable date}, {"tpep_dropoff_datetime", each DateTime.Date(_), type nullable date}}),
  #"Changed column type" = Table.TransformColumnTypes(#"Calculated date", {{"vendor", type text}, {"payment_method", type text}})
in
  #"Changed column type"