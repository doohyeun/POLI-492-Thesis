*Final Code - Controls



*CONTROL VARIABLES
*from last year; 1957-2014 data. 
*Note, this particular dataset is at; https://docs.google.com/spreadsheets/d/1UUxDfLvVmhYNyT1lT7rXtpt_D-cFWIpzFLtJFiP5Tq8/edit?usp=sharing
*This was a datset created for my POLI 420C class, with Lindsey Cox and Josh Martin, for the paper “Presidential Leverage and Foreign Aid Policy Outcomes: A Time-Series Analysis”

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/control variables.dta"


*Polarization congress 46-113 (1879-2013)
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/house_polarization46_113.dta"
rename polar polarH
rename moderates moderatesH
sort cong 
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/house_polarization46_113.dta", replace
*match based on cong (difference in party means)
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/senate_polarization46_113.dta"
rename polar polarS
rename moderates moderatesS
sort cong 
merge 1:1 cong using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/house_polarization46_113.dta", generate(plr)
*perfect match
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/PolarizationHS.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/PolarizationHS.dta"
*keep cong year polarH polarS moderatesH moderatesS
drop moderatedems moderatereps overlap overlapdems overlapreps allmean1 allmean2 demmean1 demmean2 repmean1 repmean2 ndemmean1 ndemmean2 sdemmean1 sdemmean2 plr
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/PolarizationHS.dta", replace
*now i manually took this dataset out, used excel to add in the congresses for each year that was skipped, then pasted it back into stata. 
rename cong congress
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/PolarizationHS.dta", replace

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/PolarizationHS.dta"
*now, always use both congress and year when merging. 


*US Deficit 1930-2018
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/USDeficit.dta"

*note, this dataset includes congress, which i added in manually for each year. 

*now to merge the controls


*US Deficit 1930-2018
clear all 
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/USDeficit.dta"
sort year congress
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/USDeficit.dta", replace
*polarization; year 1879-2013
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/PolarizationHS.dta"
sort year congress
joinby year congress using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/USDeficit.dta"
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Control-deficit_polar.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Control-deficit_polar.dta"


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Control-deficit_polar.dta"
sort year 
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Control-deficit_polar.dta", replace

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/control variables.dta"
sort year  
joinby year using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Control-deficit_polar.dta"
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
*this is all the controls, from year 1957-2014 (congress 85-113)


