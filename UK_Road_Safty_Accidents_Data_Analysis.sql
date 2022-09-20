

create database UK_Road_Safety;

use UK_Road_Safety;


create or replace table accidents_2015
(
  Accident_Index varchar(30),
  Location_Easting_OSGR int,
  Location_Northing_OSGR int,
  Longitude int,
  Latitude int,
  Police_Force int,
  Accident_Severity int,
  Number_of_Vehicles int,
  Number_of_Casualties int,
  Date varchar(30),
  Day_of_Week int,
  Time varchar(30),
  Local_Authority_District int,
  Local_Authority_Highway varchar(30),
  First_Road_Class int,
  First_Road_Number int,
  Road_Type int,
  Speed_limit int,
  Junction_Detail int,
  Junction_Control int,
  Second_Road_Class int,
  Second_Road_Number int,
  Pedestrian_Crossing_Human_Control int,
  Pedestrian_Crossing_Physical_Facilities int,
  Light_Conditions int,
  Weather_Conditions int,
  Road_Surface_Conditions int,
  Special_Conditions_at_Site int,
  Carriageway_Hazards int,
  Urban_or_Rural_Area int,
  Did_Police_Officer_Attend_Scene_of_Accident int,
  LSOA_of_Accident_Location varchar(30)
);

--- while trying to upload the dataset it required a few cleaning in excel, 
--- the dataset date formats are not in proper formats so is uploaded as a varchar for now
---- the last row entry was missing so , last row is deleted.

select * from accidents_2015;

create or replace table vehicles_2015
(
  Accident_Index varchar(30),
  Vehicle_Reference int,
  Vehicle_Type int,
  Towing_and_Articulation int,
  Vehicle_Manoeuvre int,
  Vehicle_Location_Restricted_Lane int,
  Junction_Location int,
  Skidding_and_Overturning int,
  Hit_Object_in_Carriageway int,
  Vehicle_Leaving_Carriageway int,
  Hit_Object_off_Carriageway int,
  First_Point_of_Impact int,
  Was_Vehicle_Left_Hand_Drive int,
  Journey_Purpose_of_Driver int,
  Sex_of_Driver int,
  Age_of_Driver int,
  Age_Band_of_Driver int,
  Engine_Capacity_CC int,
  Propulsion_Code int,
  Age_of_Vehicle int,
  Driver_IMD_Decile int,
  Driver_Home_Area_Type int,
  Vehicle_IMD_Decile int
);

--- this time no cleaning was required the data was clean and was able to upload into snowflake in one shot.  

select * from vehicles_2015;


create or replace table vehicles_type
(
  code int,
  label varchar(100)
);

select * from vehicles_type;


-- Q1. Evaluate the median severity value of accidents caused by various Motorcycles
-- Approach
-- We can see we have different motor cycle types in table vehicles_type
-- for each different types we can find out the median severity value
-- Now we have a column in table vehicles_2015 having vehicle_type in integers 


select distinct t.label,
percentile_cont(0.50) within group(order by a.accident_severity) over (partition by t.label)
as median_accident_severity
from accidents_2015 a
inner join vehicles_2015 v on v.accident_index = a.accident_index
inner join vehicles_type t on t.code = v.vehicle_type
where t.label like '%otorcycle%';



--- Q2: Evaluate Accident Severity and Total Accidents per Vehicle Type

select t.label, count(a.accident_index) as Total_accidents, avg(a.accident_Severity) as Accident_Severity
from accidents_2015 a
inner join vehicles_2015 v on v.accident_index = a.accident_index
inner join vehicles_type t on t.code = v.vehicle_type
group by t.label
;


---- Q3. Calculate the Average Severity by vehicle type.

select t.label, avg(a.accident_Severity) as Average_Severity
from accidents_2015 a
inner join vehicles_2015 v on v.accident_index = a.accident_index
inner join vehicles_type t on t.code = v.vehicle_type
group by t.label;

--- Q4. Calculate the Average Severity and Total Accidents by Motorcycle.

select t.label, count(a.accident_index) as Total_accidents, avg(a.accident_Severity) as Accident_Severity
from accidents_2015 a
inner join vehicles_2015 v on v.accident_index = a.accident_index
inner join vehicles_type t on t.code = v.vehicle_type
where t.label like '%otorcycle%'
group by t.label
;


