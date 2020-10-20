//Preamble
clear
version 16
set more off

//Macros
local neighborhoods "n_s_corncrib n_southern_cross n_imperial n_st_helena n_haversham n_barday n_hampton_valley"


local date_time "201014_0600"
local date_time "201015_2140"

local data_date "201004_1700"

use "${clean_data}wake_voter_data_househunt_analysis.dta", clear

foreach x of local neighborhoods {
    di "`x'"
	tab party_cd if `x' & status_cd == "A"
	tab race_clean if `x' & status_cd == "A"
	di ""
	di ""
}