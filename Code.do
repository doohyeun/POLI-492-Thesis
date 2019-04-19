
*POLI 492 Thesis Paper Code
*written by Doo-Hyeun Roh












*VARIABLES. 


*1) Presidential Positions. 
*combine Member Vote (president's vote) with Congressional Vote (aggregate vote)

*All aggregate Congressional votes.   
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/HS_rollcalls.dta"
keep if congress > 43
keep if congress < 113
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HS_rollcalls_shortened dataset.dta"
*70,251 observations, 18 variables


*original dataset of Member Votes HS without shortening; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/HSall_votes stata dataset.dta"
keep if icpsr>99000
keep if congress>43
keep if congress < 113
*this results in our 'stata shortened dataset'
drop if icpsr == 99342 
drop if icpsr == 99542
drop if icpsr == 99767
drop if icpsr == 99369
*this removes vicepresidents. 

*HSall-votes stata shortened dataset; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HSall_votes stata shortened dataset.dta"
*note, I am assuming that the congressional 'total' roll call vote dataset and the member rollcall vote dataset use the same 'rollnumber'. 
sort congress chamber rollnumber
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HSall_votes stata shortened dataset.dta", replace
*starts from congress 44 - 113
*59,299 observations, 6 variables

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HS_rollcalls_shortened dataset.dta"
sort congress chamber rollnumber
joinby  congress chamber rollnumber using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HSall_votes stata shortened dataset.dta"
*result is 21 variables and 57,440 observations
*it appears most observations did indeed match. 
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/merged_roll_call_votes_april1.dta"




















































*Analysis

*Dataset 1

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Final Dataset 1.dta"
drop if missing(meansig)

rename federaldeficitfedpercentgdp deficit 

gen pressuccess_incabstain = 1
recode pressuccess_incabstain 1=0 if cast_code == 6 | cast_code == 9
label variable pressuccess_incabstain "Pres.Success(incab)"

gen pressuccess_excabstain = 1
recode pressuccess_excabstain 1=0 if cast_code == 6
recode pressuccess_excabstain 1=. if cast_code == 9
label variable pressuccess_excabstain "Pres.Success(excab)"

summ pressuccess_incabstain pressuccess_excabstain Foreignaffairs_all meansig approval preshouse pressenate wars1yes gdpchained deficit polars polarh

logit pressuccess_incabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh
*this gives the table in the thesis. Note, advised not to use, since it is likely meaningless. 
drop if pressuccess_excabstain==.
logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit
*nothing is significant, also had to drop polarization variables. 
*Positive coefficients on foreign policy and significance variable, but not significant. 

label variable approval "Pres. Approval Ratings"
label variable preshouse "House Majority"
label variable pressenate "Senate Majority"
label variable wars1yes "Wars"
label variable polars "Polarization(S)"
label variable polarh "Polarization(H)"
label define ForeignAffairs_all 1 "Foreign Affairs" 0 "Domestic Affairs"
label values ForeignAffairs_all ForeignAffairs_all

logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval 
estimates store m1, title(Model 1)
logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate 
estimates store m2, title(Model 2)
logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes 
estimates store m3, title(Model 3)
logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes c.gdpchained 
estimates store m4, title(Model 4)
logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit
estimates store m5, title(Model 5)
logit pressuccess_excabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh
estimates store m6, title(Model 6)
logit pressuccess_incabstain Foreignaffairs_all##c.meansig approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh
estimates store m7, title(Model 7)
estout m1 m2 m3 m4 m5 m6 m7, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
esttab m1 m2 m3 m4 m5 m6 m7 using "~/Documents/UBC Year 5/POLI 492/Thesis Final Draft/FinalDataset1 Presidential Success Regression" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace








*Final Dataset 2
*This has one rcvote per bill. 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"

label variable approval "Pres. Approval Ratings"
label variable preshouse "House Majority"
label variable pressenate "Senate Majority"
label variable wars1yes "Wars"
label variable polars "Polarization(S)"
label variable polarh "Polarization(H)"
label define ForeignAffairs 1 "Foreign Affairs" 2 "Domestic Affairs"
label variable pressuccess_incabstain "Pres. Success"

summ pressuccess_excabstain  ForeignAffairs approval preshouse pressenate wars1yes gdpchained deficit polars polarh icpsr if rcvcb==3 & pressuccess_excabstain==1 | pressuccess_excabstain==0
summ pressuccess_incabstain  ForeignAffairs approval preshouse pressenate wars1yes gdpchained deficit polars polarh icpsr if rcvcb==3



*Margins Plots with CI's
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"
keep if rcvcb==3


logit pressuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr
margins, at(ForeignAffairs=(0 1))
marginsplot, recast(scatter) aspectratio(1) xscale(range(-0.3 1.3)) yscale(range(.6 .8))
*This shows the 95% confidence interval, b/w Foreign and Domestic affairs. This does NOT assume means for the other controls. 
*Same as above, but with icpsr added in. 
*Now the results are even more clearer, and BEST OF ALL, CI's do not overlap. 

*This could be strong evidence that Presidents do in fact have an advantage in Foreign Policy, in terms of roll-call votes for Bills. 





*This is a margins plot, depending on majority control. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"
keep if rcvcb==3
quietly logit pressuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr, nolog
margins, dydx(ForeignAffairs) at(preshouse=(0 1) pressenate=(0 1)) 
*1 = minority government, 2 and 3 are split, 4 = majority control. 
*this seems to show that being Foreign Affairs has the biggest impact on Success Rates when 
*president is in a minority government. 
marginsplot, recast(scatter) xscale(range(-.3 1.3)) yscale(range(-.03 .2))






*using my own version of legsig, using # of rcvotes. 
*'dup' shows this number. 


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"

label variable approval "Pres. Approval Ratings"
label variable preshouse "House Majority"
label variable pressenate "Senate Majority"
label variable wars1yes "Wars"
label variable polars "Polarization(S)"
label variable polarh "Polarization(H)"
label define ForeignAffairs 1 "Foreign Affairs" 2 "Domestic Affairs"
label variable pressuccess_incabstain "Pres. Success"
label variable dup "Leg.Sig"
recode dup 0=1

*test, regular regression with all controls
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
*now we add in 'dup'
logit pressuccess_excabstain ForeignAffairs dup approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
*excluding abstains, ForeignAffairs stays significant, although smaller. 
*dup is negative and significant; the more rcvotes were held on a bill, the less likely Presidents succeeded... 
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & dup > 1
*if dup > 1, ForeignAffairs loses significance. 
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & dup== 1
*if dup == 1 however, ForeignAffairs gains significance (z=3.78 compared to 2.45 without dup and 2.57 with dup).
*coefficient is also .9724 if dup < 1, .46 without dup, .485 with dup 
*so it seems for bills that had only one vote, ForeignAffairs mattered alot, while for bills with multiple votes, it mattered less. 
*is this an indication of the presidential strategic choice in play? That normally they strategically lose in domestic and win in foreign, 
*but for important (more rcvotes) bills this does not apply? 

logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
estimates store m1, title(Model 1)
logit pressuccess_excabstain ForeignAffairs dup approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
estimates store m2, title(Model 2)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & dup > 1
estimates store m3, title(Model 3)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & dup== 1
estimates store m4, title(Model 4)

estout m1 m2 m3 m4, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
esttab m1 m2 m3 m4 using "~/Documents/UBC Year 5/POLI 492/Thesis Final Draft/FinalDataset2 LegSig" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace



* ANother hypothesis; test the years. 


* a) with a single roll call vote per bill. 


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"

label variable approval "Pres. Approval Ratings"
label variable preshouse "House Majority"
label variable pressenate "Senate Majority"
label variable wars1yes "Wars"
label variable polars "Polarization(S)"
label variable polarh "Polarization(H)"
label define ForeignAffairs 1 "Foreign Affairs" 2 "Domestic Affairs"
label variable pressuccess_incabstain "Pres. Success"

logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3

*now, if we try years? year = 1957-2014

*year < 1970
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year < 1970
*INSIGNIFICANT ForeignAffairs when before 1970's. 

*year < 1990
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year < 1990
*Significant ForeignAffairs when before the 1990s

*year > 1990
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year > 1990 
*INSIGNIFICANT ForeignAffairs when after 1990s

*year > 2000
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year > 2000
*SIGNIFICANT ForeignAffairs when after 2000s, coefficient is huge (1.678)
*make margins plot of this? 




logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
estimates store m1, title(Model 1)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year < 1970
estimates store m2, title(Model 2)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year < 1990
estimates store m3, title(Model 3)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year > 1990 
estimates store m4, title(Model 4)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3 & year > 2000
estimates store m5, title(Model 5)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit i.icpsr if rcvcb==3 & year > 2000
estimates store m6, title(Model 6)
estout m1 m2 m3 m4 m5 m6, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
esttab m1 m2 m3 m4 m5 m6 using "~/Documents/UBC Year 5/POLI 492/Thesis Final Draft/FinalDataset2 eras" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace

logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit i.icpsr if rcvcb==3 & year > 2000
margins, at(ForeignAffairs=(0 1))
marginsplot, recast(scatter) aspectratio(1) xscale(range(-0.3 1.3)) yscale(range(.5 1))










*Dataset 3


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/voteview-comparativeagenda all bills merged with controls.dta"

*note, each roll-call vote here may have multiple bills attatched to them. 
gen net_count = yea_count - nay_count
gen Billpass = 0
recode Billpass 0=1 if net_count >0
*Now, for each roll call vote, we know if the bill attatched to them were pass/fail.
*Note, Billpass: 1 = pass, 0 = fail.  

*cast code: 1 = yes, 6 = nay, 9 = abstain. 
gen PresSuccess_excabstain = 0
recode PresSuccess_excabstain 0 = 1 if Billpass==1 & cast_code==1
recode PresSuccess_excabstain 0 = 1 if Billpass==0 & cast_code==6
recode PresSuccess_excabstain 0 = . if cast_code==9

gen PresSuccess_incabstain = 0
recode PresSuccess_incabstain 0 = 1 if Billpass==1 & cast_code==1
recode PresSuccess_incabstain 0 = 1 if Billpass==0 & cast_code==6
recode PresSuccess_incabstain 0 = 1 if Billpass==0 & cast_code==9
*here, when i include abstain, i'm judging it equivalent to 'no'

rename federaldeficitfedpercentgdp deficit 

label variable ForeignAffairs "Foreign Affairs"
label variable approval "Presidential Approval Ratings"
label variable preshouse "President has Majority in House"
label variable pressenate "President has Majority in Senate"
label variable wars1yes "Wars"
label define wars1yes 1 "yes" 0 "no"
label variable gdpchained "Chained GDP"
label variable deficit "Deficit as % of GDP"
label variable polars "Polarization in Senate"
label variable polarh "Polarization in House"
label variable icpsr "Presidents"
label define ForeignAffairs 1 "Foreign Affairs" 2 "Domestic Affairs"
label values ForeignAffairs ForeignAffairs 

gen rcvote_code = cast_code 
label variable rcvote_code "President's Vote"
label define rcvote_code 1 "yea" 6 "nay" 9 "abstain"
label values rcvote_code rcvote_code
tab rcvote_code

label variable approval "Pres. Approval Ratings"
label variable preshouse "House Majority"
label variable pressenate "Senate Majority"
label variable wars1yes "Wars"
label variable polars "Polarization(S)"
label variable polarh "Polarization(H)"
label define ForeignAffairs 1 "Foreign Affairs" 2 "Domestic Affairs"
label variable PresSuccess_incabstain "Pres. Success(I)"
label variable PresSuccess_excabstain "Pres. Success(X)"


logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr
margins, at(ForeignAffairs=(0 1))
marginsplot, recast(scatter) aspectratio(1) xscale(range(-.3 1.3)) yscale(range(.6 .73))

























