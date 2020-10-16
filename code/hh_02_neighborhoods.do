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
local streets "barday hampton_valley"

local corncrib_streets "woodshed vineyard tropical bellemead westhaven su_john hillside electra"
local southern_cross_streets "silver_lake yates_garden purple_martin goldfinch school_creek bryarton_woods antebellum orabelle nautia olivias goldeneye"
local st_helena_streets "st_julian senoma beringer vintage_grove inglenook samara"
local haversham_streets "houndschase delchester charing_cross wigan woodham trillingham"
local barday_streets "yates_garden goldfinch school_creek purple_martin silver_lake southern_cross"
local hampton_valley_streets "willowbrook oregon woodland oakridge holly brookcliff huntwood overview farmstead parkview"

local neighborhoods "n_s_corncrib n_bay_dr_cary n_southern_cross n_imperial n_st_helena n_haversham"
local neighborhoods "n_barday n_hampton_valley"

local date_time "201014_0600"
local date_time "201015_2130"


local data_date "201004_1700"

//Data
use "${clean_data}wake_voter_data_househunt_base.dta", clear

//Houses under consideration
//Bay Drive, Cary
gen bay_dr_cary = regexm(res_street_address, "BAY ") & regexm(res_street_address, "DR") & cary
replace bay_dr_cary = 0 if regexm(res_street_address, "PAMLICO") == 1

//108 S. Corncrib Court, Cary
gen s_corncrib = regexm(res_street_address, "S") & regexm(res_street_address, "CORNCRIB")

//5412 Southern Cross, Raleigh
gen southern_cross = regexm(res_street_address, "SOUTHERN CROSS")

//1112 Imperial Rd, Cary
gen imperial_cary = regexm(res_street_address, "IMPERIAL") & regexm(res_street_address, "RD") & cary

//1008 W. St Helena Rd, Apex
gen st_helena_apex = regexm(res_street, "HELENA") & regexm(res_street_address, "W")

//103 Haversham
gen haversham = regexm(res_street, "HAVERSHAM")

//2416 Barday Downs, Cary
gen barday = regexm(res_street, "BARDAY")

//1314 Hampton Valley
gen hampton_valley = regexm(res_street, "HAMPTON VALLEY")
//Nearby Roads/Addresses

//Imperial House
gen wellington_dr = regexm(res_street_address, "WELLINGTON") == 1
replace wellington_dr = 0 if regexm(res_city_desc, "CARY") == 0
replace wellington_dr = 0 if regexm(res_street_address, "RIDGE") == 1

gen n_imperial = imperial_cary
replace n_imperial = 1 if wellington_dr

//108 S. Corncrib Court

gen woodshed = regexm(res_street, "WOODSHED")
gen vineyard = regexm(res_street, "VINEYARD L")
gen tropical = regexm(res_street, "TROPICAL D")
gen bellemead = regexm(res_street, "BELLEMEAD")
gen westhaven = regexm(res_street, "WESTHAVEN")
gen su_john = regexm(res_street, "SU JOHN")
gen hillside = regexm(res_street, "HILLSIDE C")
replace hillside = 0 if !raleigh

gen electra = regexm(res_street, "ELECTRA")
replace electra = 0 if only_street_num > 500 & electra
replace electra = 1 if only_street_num > 6799 & electra
replace electra = 0 if only_street_num > 7300 & electra

gen n_s_corncrib = s_corncrib
foreach st of local corncrib_streets {
    replace n_s_corncrib = 1 if `st'
}

//5412 Southern Cross
gen silver_lake =  regexm(res_street, "SILVER LAKE")
gen yates_garden = regexm(res_street, "YATES GARDEN")
gen purple_martin =  regexm(res_street, "PURPLE MARTIN")
gen goldfinch = regexm(res_street, "GOLDFINCH WAY")
gen school_creek = regexm(res_street, "SCHOOL CREEK PL")
gen bryarton_woods =  regexm(res_street, "BRYARTON WOODS")
gen antebellum = regexm(res_street, "ANTEBELLUM RD")
gen orabelle =  regexm(res_street, "ORABELLE")
gen nautia = regexm(res_street, "NAUTIA")
gen olivias = regexm(res_street, "OLIVIAS L")
gen goldeneye = regexm(res_street, "GOLDENEYE ")

gen n_southern_cross = southern_cross
foreach st of local southern_cross_streets	{
    replace n_southern_cross = 1 if `st'
}

//1008 W. St. Helena
gen st_julian = regexm(res_street, "SAINT JUL")
gen senoma = regexm(res_street, "SENOMA")
gen beringer = regexm(res_street, "BERINGER PL")
gen vintage_grove = regexm(res_street, "VINTAGE GROVE")
gen inglenook = regexm(res_street, "INGLENOOK")
gen samara = regexm(res_street, "SAMARA")

gen n_st_helena = st_helena_apex
foreach st of local st_helena_streets	{
    replace n_st_helena = 1 if `st'
}

//103 Haversham
gen houndschase = regexm(res_street_address, "HOUNDSCHASE")
gen delchester = regexm(res_street_address, "DECLCHESTER")
gen charing_cross = regexm(res_street_address, "CHARING CROSS")
gen wigan = regexm(res_street_address, "WIGAN")
gen woodham = regexm(res_street_address, "WOODHAM")
gen trillingham = regexm(res_street, "TRILLINGHAM")

gen n_haversham = haversham
foreach st of local haversham_streets {
    replace n_haversham = 1 if `st'
}


//2416 Barday Downs
gen n_barday = barday
foreach st of local barday_streets	{
    replace n_barday = 1 if `st'
}

//Hampton Valley
gen willowbrook = regexm(res_street_address, "WILLOWBROOK")
gen oregon = regexm(res_street_address, "OREGON C")
gen woodland =  regexm(res_street_address, "WOODLAND CT")
gen holly = regexm(res_street_address, "HOLLY CIR") & cary
gen oakridge =  regexm(res_street_address, "OAKRIDGE RD")
gen brookcliff =  regexm(res_street_address, "BROOKCLIFF")
gen huntwood =  regexm(res_street_address, "HUNTWOOD")
gen farmstead =  regexm(res_street_address, "FARMSTEAD ")
gen parkview =  regexm(res_street_address, "PARKVIEW CIR") & cary
gen overview = regexm(res_street_address, "OVERVIEW") & cary
gen n_hampton_valley = hampton_valley
foreach st of local hampton_valley_streets	{
    replace n_hampton_valley = 1 if `st'
}

save "${clean_data}wake_voter_data_househunt_analysis.dta", replace
save "${archive}wake_voter_data_househunt_analysis_`date_time'.dta", replace
