*Final Code - CL Foreign vs Domestic. 


*note; 
*to bring Clinton-Lapinski data. go to https://my.vanderbilt.edu/joshclinton/data/, 
*use "Measures of Significant Legislation, 1877-1994"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/clinton-lapinski dataset raw.dta"





*FOREIGN APPROPRIATIONS SECTION

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/All Appropriations 1974-2019 dataset.dta"  
*Note, this is a dataset of foreign appropriations bills (enacted only) that i personally compiled using filtered results in congress.gov

sort year congress pl 
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/All Appropriations 1974-2019 dataset.dta", replace 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/clinton-lapinski dataset raw.dta"
sort year congress pl
merge m:1 year congress pl using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/All Appropriations 1974-2019 dataset.dta", force
*the 150 'not-matched' observations from using (_merge==2) are all 1994+, which is not covered by Clinton-Lapinski. 

*to check, clinton-lapinski originally had 18 variables and 38,100 observations
*after merging we have 22 variables and 38250 observations, of which 150 additional observations came from 1994+ appropriations data. 

tab topic

*Issues with time; Clinton-Lapinski dataset is 1877-1994, but the Foreign Appropriations dataset is only from 1974 onwrds. 




*Foreign (Non-appropriations) section 


*creating a variable in Clinton-Lapinski that isolates 'Foreign Affairs (non-appropriations)
gen Foreignaffairs_nonA = 0
label variable Foreignaffairs_nonA "Foreignaffairs_nonA"
label values Foreignaffairs_nonA Foreignaffairs_nonA
recode Foreignaffairs_nonA 0 = 1 if sencom == "Foreign Relations"
recode Foreignaffairs_nonA 0 = 1 if sencom == "Committee on Foreign Relations"
recode Foreignaffairs_nonA 0 = 1 if sencom == "Interstate and Foreign Commerce"
recode Foreignaffairs_nonA 0 = 1 if housecom == "Committee on Foreign Affairs"
recode Foreignaffairs_nonA 0 = 1 if housecom == "Foreign AFfairs"
recode Foreignaffairs_nonA 0 = 1 if housecom == "Interstate and Foreign Commerce"
recode Foreignaffairs_nonA 0 = 1 if housecom == "Committee on Interstate and Foreign Commerce"
recode Foreignaffairs_nonA 0=.

tab year Foreignaffairs_nonA

*Now, to create the combined 'Foreign Affairs' and 'Domestic Affairs' variable; 

label variable topic "topic"
label values topic topic 

gen Foreignaffairs_all = 0
label variable Foreignaffairs_all "Foreignaffairs_all"
label values Foreignaffairs_all Foreignaffairs_all
recode Foreignaffairs_all 0 = 1 if _merge==3
*this _merge==3 are all the Foreign Affairs Appropriations within lapinski's dataset. 
recode Foreignaffairs_all 0 = 1 if Foreignaffairs_nonA == 1

tab Foreignaffairs_all
*this is all foreign affairs bills that were enacted, with 0 = Domestic affairs and 1 = Foreign affairs

*now we save this

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic.dta"
*SUMMARY
*this dataset has foreign affairs(appropriations) seperated, as well as foreign affairs (non-appropriations)
*the result is the variable 'Foreignaffairs_all', which gives 1 = Foreign affairs and 0 = Domestic Affairs. 

***Importantly, for testing within lapinski data, all years 1994+ should be discarded since clinton-lapinski do not cover them. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic.dta"

