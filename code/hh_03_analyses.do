//Preamble
clear
version 16
set more off

//Macros
global house_folder "C:\Users\JaysC\Dropbox\_My Computer\House\"
global repo "${house_folder}house-hunt\"
global data "${repo}data\"
global raw_data "${data}raw_data\"
global clean_data "${data}clean_data\"
global archive "${data}archive\"

local ages "age_18_24 age_25_34 age_35_44 age_45_54 age_55_64 age_65_plus age_yeah_right"
local residential_address_variables "res_street_address res_city_desc"

local streets "corncrib bay_dr_cary blueberry_woods"
local streets "bay_dr_cary s_corncrib southern_cross"

local corncrib_streets "woodshed vineyard tropical bellemead westhaven su_john hillside electra"
local southern_cross_streets "silver_lake yates_garden purple_martin goldfinch school_creek bryarton_woods antebellum orabelle nautia olivias goldeneye"
local st_helena_streets "st_julian senoma beringer vintage_grove inglenook samara"
local haversham_streets "houndschase delchester charing_cross wigan woodham trillingham"

local neighborhoods "n_s_corncrib n_southern_cross n_imperial n_st_helena n_haversham"
//Maybe should add a Bay drve neighborhood variable: n_bay_dr_cary 
local date_time "201014_0600"

local data_date "201004_1700"

*use "${clean_data}wake_voter_data_househunt_analysis.dta", clear

//Crosstabs & Analysis
tab party_cd if bay_dr_cary
tab race_clean if bay_dr_cary

l res_street_address race_clean party_cd if bay_dr_cary

foreach x of local neighborhoods {
    di "`x'"
	tab party_cd if `x' & status_cd == "A"
	tab race_clean if `x' & status_cd == "A"
	di ""
	di ""
}