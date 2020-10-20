/*

"""
House Hunting Voter Data Cleaning

This does a small amount of cleaning to the voter file


"""
*/

//Preamble
clear
version 16
set more off

//Macros
*IN hh_00a_macros.do


local ages "age_18_24 age_25_34 age_35_44 age_45_54 age_55_64 age_65_plus age_yeah_right"
local residential_address_variables "res_street_address res_city_desc"


local date_time "201014_0600" // added only_street_num
local date_time "201014_0900"

local data_date "201004_1700"


//Data
import delimited "${raw_data}ncvoter92.txt"


//Variable Manipluation

//Keep variables
/*
Keep:
Drop: county_id county_desc reason_cd full_phone_number precinct_desc municipality_desc ward_desc cong_dist_abbrv super_court_abbrv judic_dist_abbrv nc_senate_abbrv nc_house_abbrv county_commiss_abbrv county_commiss_desc township_abbrv township_desc school_dist_desc fire_dist_abbrv fire_dist_desc water_dist_abbrv water_dist_desc sewer_dist_abbrv sewer_dist_desc sanit_dist_abbrv sanit_dist_desc rescue_dist_abbrv rescue_dist_desc munic_dist_abbrv munic_dist_desc dist_1_abbrv dist_1_desc dist_2_abbrv dist_2_desc
????: mail_addr1 mail_addr2 mail_addr3 mail_addr4 mail_city mail_state mail_zipcode precint_abbrv municipality_abbrv 

*/
drop county_id county_desc reason_cd full_phone_number precinct_desc municipality_desc ward_desc cong_dist_abbrv super_court_abbrv judic_dist_abbrv nc_senate_abbrv nc_house_abbrv county_commiss_abbrv county_commiss_desc township_abbrv township_desc school_dist_desc fire_dist_abbrv fire_dist_desc water_dist_abbrv water_dist_desc sewer_dist_abbrv sewer_dist_desc sanit_dist_abbrv sanit_dist_desc rescue_dist_abbrv rescue_dist_desc munic_dist_abbrv munic_dist_desc dist_1_abbrv dist_1_desc dist_2_abbrv dist_2_desc


gen out_of_state_mailing_address = mail_state != "NC"
replace out_of_state_mailing_address = . if missing(mail_state)


//Not sure about these drops
drop mail_addr1 mail_addr2 mail_addr3 mail_addr4 mail_city mail_state mail_zipcode precinct_abbrv municipality_abbrv 


//Upper Case Addresses
foreach var of local residential_address_variables	{
    replace `var' = upper(`var')
}

//Race
gen race_clean = .
replace race_clean = 1 if race_code == "I"
replace race_clean = 6 if race_code == "M"
replace race_clean = 7 if race_code == "P"
replace race_clean = 8 if race_code == "O"
replace race_clean = 2 if race_code == "A"
replace race_clean = 3 if ethnic_code == "HL"
replace race_clean = 4 if race_code == "B"
replace race_clean = 5 if race_code == "W"

label define race_clean_labels 1 "American Indian/Alaska Native"

label define race_clean_labels 2 "Asian", add
label define race_clean_labels 3 "Hispanic", add
label define race_clean_labels 4 "Black", add
label define race_clean_labels 5 "White", add
label define race_clean_labels 6 "Multiple Races", add
label define race_clean_labels 7 "Hawaiian Native/Other Pacific Islander", add
label define race_clean_labels 8 "Other", add

label values race_clean race_clean_labels
//Race Dummies
gen r_hisp = race_clean == 3
gen r_black = race_clean == 4
gen r_white = race_clean == 5
gen r_other = race_clean < 3 & race_clean > 5 & !missing(race_clean)

//Age Dummies
local ages "age_18_24 age_25_34 age_35_44 age_45_54 age_55_64 age_65_plus age_yeah_right"

foreach age of local ages {
    gen `age' = 1
}

replace age_18_24 = 0 if birth_age > 24
replace age_25_34 = 0 if birth_age > 34
replace age_35_44 = 0 if birth_age > 44
replace age_45_54 = 0 if birth_age > 54
replace age_55_64 = 0 if birth_age > 64

replace age_65_plus = 0 if birth_age < 65
replace age_55_64 = 0 if birth_age < 55
replace age_45_54 = 0 if birth_age < 45
replace age_35_44 = 0 if birth_age < 35
replace age_25_34 = 0 if birth_age < 25
replace age_18_24 = 0 if birth_age < 18


foreach age of local ages {
    replace `age' = . if missing(birth_age)
}

//Political Party Dummies
gen party_dem = party_cd == "DEM"
gen party_rep = party_cd == "REP"
gen party_una = party_cd == "UNA"

gen party_oth = 1
replace party_oth = 0 if party_dem == 1
replace party_oth = 0 if party_rep == 1
replace party_oth = 0 if party_una == 1

//Street Numbers
gen only_street_num = regexs(1) if regexm(res_street, "([0-9]+)")
destring only_street_num, replace

//Roads
gen only_street_name = regexr(res_street_address, "[0-9]+", "")
replace only_street_name = regexr(only_street_name, "[0-9]+", "")
replace only_street_name = regexr(only_street_name, "\#", "")

//Cities
gen cary = regexm(res_city_desc, "CARY")
gen apex = regexm(res_city_desc, "APEX")
gen raleigh = regexm(res_city_desc, "RALEIGH")
gen holly_springs = regexm(res_city_desc, "HOLLY")


note: Data as of: `data_date'

save "${clean_data}wake_voter_data_househunt_base.dta", replace

save "${archive}wake_voter_data_househunt_base_`date_time'.dta", replace