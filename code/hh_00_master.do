//Preamble
clear
version 16
set more off

//Macros
global house_folder "C:\Users\JaysC\Dropbox\_My Computer\House\"
global repo "${house_folder}house-hunt\"
global code "${repo}code\"
global data "${repo}data\"
global raw_data "${data}raw_data\"
global clean_data "${data}clean_data\"
global archive "${data}archive\"

local streets "corncrib bay_dr_cary blueberry_woods"
local streets "bay_dr_cary s_corncrib southern_cross"
local ages "age_18_24 age_25_34 age_35_44 age_45_54 age_55_64 age_65_plus age_yeah_right"
local residential_address_variables "res_street_address res_city_desc"


local date_time "201014_0600" // added only_street_num
local date_time "201014_0900"

local data_date "201004_1700"


do "${code}hh_01_clean_voter_file.do"
do "${code}hh_02_neighborhoods.do"
do "${code}hh_03_analyses.do"