/*
"""
******* House Hunting Project *******

This project takes the NC Voter Registration file from Wake County and runs simple demographic analyses on neighborhoods near houses. The neighborhood part is manual and needs to be handled by coding street names/addresses from a map. 

Future Work: 
-Move to Python
-Incorporate ArcGIS to automate the neighborhood piece

"""
*/

//Preamble
clear
version 16
set more off

local date_time "201014_0600" // added only_street_num
local date_time "201014_0900"

local data_date "201004_1700"

do "${code}hh_00a_macros.do"			//Filepaths/Macros
do "${code}hh_01_clean_voter_file.do"	//Clean Voter File
do "${code}hh_02_neighborhoods.do"		//Code Neighborhood Files
do "${code}hh_03_analyses.do"			//Quick Demographic Analyses