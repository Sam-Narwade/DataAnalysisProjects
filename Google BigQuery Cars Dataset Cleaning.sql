
/*  Data cleaning using Google BigQuery
    Used DISTINCT, LENGTH, MIN, MAX & TRIM Functions */


-----------------------------------------------------------------------------------------------------------------------------------------------

SELECT *
From cars.car_info;

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Checking for Null fields in num_of_doors column


SELECT *
From `vast-dock-336312.cars.car_info`
WHERE num_of_doors is NULL; 


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Updating the Null fields with required values


Update 
    `vast-dock-336312.cars.car_info`
SET 
    num_of_doors = 'four'
WHERE 
    make = 'mazda'
    And fuel_type = 'diesel'
    And body_style = 'sedan';
    
    
Update 
    `vast-dock-336312.cars.car_info`
SET 
    num_of_doors = 'four'
WHERE 
    make = 'dodge'
    And fuel_type = 'gas'
    And body_style = 'sedan';    
    
    
-----------------------------------------------------------------------------------------------------------------------------------------------
-- Checking for Spelling errors in num_of_cylinders column


SELECT 
    DISTINCT num_of_cylinders
From 
    `vast-dock-336312.cars.car_info`;    


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Updating the incorrect spelling


Update 
    `vast-dock-336312.cars.car_info`
SET 
    num_of_cylinders = 'two'
Where 
    num_of_cylinders = 'tow';   



-----------------------------------------------------------------------------------------------------------------------------------------------
-- Checking compression ration if between range 7 to 23


SELECT 
    MIN(compression_ratio) As min_compression_ratio,
    MAX(compression_ratio) As max_compression_ration
FROM 
    `vast-dock-336312.cars.car_info`;
    

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Locating rows where compression ratio is above the required limit


SELECT  
    *
FROM  
    `vast-dock-336312.cars.car_info`
WHERE
    compression_ratio > 23;         


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Updating incorrect compression ratio for rows above required limit


UPDATE 
    `vast-dock-336312.cars.car_info`
SET 
    compression_ratio = 7.0
WHERE 
    compression_ratio = 70;      
    

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Checking for extra spaces or spelling errors in drive_wheels column by using length function


SELECT  
    DISTINCT drive_wheels,
    LENGTH (drive_wheels) As no_of_chars
From 
    `vast-dock-336312.cars.car_info`;


-----------------------------------------------------------------------------------------------------------------------------------------------
-- Removing all extra spaces from drive_wheels column


SELECT  
    drive_wheels = TRIM(drive_wheels)
From 
    `vast-dock-336312.cars.car_info`
WHERE 
    True;  
    
    
-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------


