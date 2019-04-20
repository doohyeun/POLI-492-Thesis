*Final Code - Dataset 2





*We need PresData + CBills, then + Controls to create Dataset 2 . 




*CBills; Comparative Agenda: The congressional bills project; 400k+ bills 1947-present
*For this dataset, we used Comparative Agenda; they have the dataset of 400,000 bills from 1947-2016, compiled by E. Scott Adler and John Wilkerson. 
*see https://www.comparativeagendas.net/us, under 'Parliamentary and Legislative', "Congressional Bills" section. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012.dta"

tab pap_majortopic
*19 = international affairs
*note i am excluding foreign military operations and foreign trade (18)
*99 = missing values. 

gen ForeignAffairs = 0
recode ForeignAffairs 0=1 if pap_majortopic==19
recode ForeignAffairs 0=. if pap_majortopic==99
*now, 0 = domestic affairs, 1 = foreign affairs

gen billnum = bill_type + string(bill_no)
replace billnum = upper(billnum)

rename cong congress
duplicates list congress year billnum
quietly by congress year billnum: gen dup1 = cond(_N==1, 0,_n)
tab dup1
drop if dup1 > 0

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta"































*To recap; 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions for roll call votes.dta", clear
*57,440 observations
*PresData

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
*all controlls

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta"
*CBills





*HOW TO GET FinalDataset2 from the thesis draft 1

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta"
sort congress year billnum
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta", replace


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/cl_test2.dta"
sort congress billnum year 
*this is presdata with all RCvotes dropped except the 'passing' vote. 

merge m:1 congress billnum year using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta", generate(rcvcb) force
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2.dta"


*Now merge with controls

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
sort year
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta", replace

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2.dta"
sort year
merge m:1 year using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta", generate(finalv1)
keep if finalv1==3

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls.dta"

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

*Now, cast_codes are either 1,6,or 9. 1 = yea, 6 = nay, 9=abstain. 
*Thus, Given these are enacted votes, if president votes '1', it is presidencial success. If they vote 6 or 9, it is a loss. 
gen pressuccess_incabstain = 1
recode pressuccess_incabstain 1=0 if cast_code == 6 | cast_code == 9
label variable pressuccess_incabstain "Presidential Success (with abstains)"

gen pressuccess_excabstain = 1
recode pressuccess_excabstain 1=0 if cast_code == 6
recode pressuccess_excabstain 1=. if cast_code == 9
label variable pressuccess_excabstain "Presidential Success (excluding abstains)"

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"



















*FinalDataset 2 - Presentation Day Code

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"

keep if rcvcb==3
gen rcvote_code = cast_code 
label variable rcvote_code "President's Vote"
label define rcvote_code 1 "yea" 6 "nay" 9 "abstain"
label values rcvote_code rcvote_code
tab rcvote_code
*this gives us the tab of cast_code. 


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

*Foreign Affairs: Binary, 1 vs 0 
*approval: continuous, 0 ~ 1
*preshouse and pressenate: binary, 1 vs 0
*wars1yes: binary, 1 vs 0
*gdpchained: continuous, -2.8~7.3    (this is a percentage)
*deficit: continuous, -2.3 ~ 9.78
*polars and polarh: continuous, .4~1.1
*icpsr: categorical. 


logit pressuccess_excabstain ForeignAffairs if rcvcb==3
estimates store m1, title(Model 1)
logit pressuccess_excabstain ForeignAffairs approval if rcvcb==3
estimates store m2, title(Model 2)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate if rcvcb==3
estimates store m3, title(Model 3)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes if rcvcb==3
estimates store m4, title(Model 4)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained if rcvcb==3
estimates store m5, title(Model 5)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit if rcvcb==3
estimates store m6, title(Model 6)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh if rcvcb==3
estimates store m7, title(Model 7)
logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
estimates store m8, title(Model 8)

estout m1 m2 m3 m4 m5 m6 m7 m8, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)

esttab m1 m2 m3 m4 m5 m6 m7 m8 using "~/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2 Presidential Success excluding abstains" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace
*This is an updated, abstains-excluded version of Table 3. 
*note, R2 = 0.2511


logit pressuccess_incabstain ForeignAffairs if rcvcb==3
estimates store a1, title(Test 1)
logit pressuccess_incabstain ForeignAffairs approval if rcvcb==3
estimates store a2, title(Test 2)
logit pressuccess_incabstain ForeignAffairs approval i.preshouse i.pressenate if rcvcb==3
estimates store a3, title(Test 3)
logit pressuccess_incabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes if rcvcb==3
estimates store a4, title(Test 4)
logit pressuccess_incabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained if rcvcb==3
estimates store a5, title(Test 5)
logit pressuccess_incabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit if rcvcb==3
estimates store a6, title(Test 6)
logit pressuccess_incabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh if rcvcb==3
estimates store a7, title(Test 7)
logit pressuccess_incabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if rcvcb==3
estimates store a8, title(Test 8)

estout a1 a2 a3 a4 a5 a6 a7 a8, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)

esttab a1 a2 a3 a4 a5 a6 a7 a8 using "~/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2 Presidential Success including abstains" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace
*This is an updated, abstains-INCLUDED version of Table 3. 
*note, R2 = 0.1201


estout m1 m2 m3 m4 m5 m6 m7 m8 a8, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
esttab m1 m2 m3 m4 m5 m6 m7 m8 a8 using "~/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2 Presidential Success excluding abstains + one total abstain column" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace
*This is the regression table with both excluding-abstains and one column with abstains included. 
 
esttab m8 a8 using "~/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2 Presidential Success just last two columns" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace
*this is just the last two columns



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
*This shows the change in success probability given Foreign Affairs (baseline being Domestic Affairs)
*Given a minority in house, majority control of senate does not appear to make a difference. 
*Given a majority in house, majority in senate does matter, oddly president appear to have higher
	*success rates when they have a minority in the senate. 
*Note, both confidence intervals are above zero. 

*This means that the difference in Presidential success rates in Foreign Policy (compared to Domestic Policy) 
	*are highest when Presidents are in a minority government. 
	*Not that surprising; in majority control, Presidents would push through alot of domestic bills and vice versa. 
	*Domestic issues would be based more on party lines. 
	*Foreign Issues are not as strongly dependent on them, so the difference is more evident in minority government. 



*Margins Plots with CI's
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"
keep if rcvcb==3


logit pressuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr
margins, at(ForeignAffairs=(0 1))
marginsplot, recast(scatter) aspectratio(1) xscale(range(-0.3 1.3))
*This shows the 95% confidence interval, b/w Foreign and Domestic affairs. This does NOT assume means for the other controls. 
*Same as above, but with icpsr added in. 
*Now the results are even more clearer, and BEST OF ALL, CI's do not overlap. 

*This could be strong evidence that Presidents do in fact have an advantage in Foreign Policy, in terms of roll-call votes for Bills. 




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

*if you do replace 'pressuccess_excabstain' with '_incabstain', then; 
	*if you add in dup, ForeignAffairs don't change, dup is insig.
	*for dup > 1, ForeignAffairs loses sig. 
	*for dup = 1, ForeignAffairs becomes significant again. 



	
	
	
	
	
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







*The following contains code and notes on extra study/analysis that I did not end up adding into the thesis. 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset2_with controls and labelled.dta"
keep if rcvcb==3
*now we are working only with data that matched b/w RCvotes and CBills. 

logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh 
margins, at(ForeignAffairs=1 preshouse=(0 1) pressenate=(0 1) wars1yes=(0 1)) atmeans post
*This shows probabiltiy of Presidential Success, given Foreign Affairs and various combinations of Majority control and war, holding 
	*all others at their means. 
*note that 8, when President has majority in congress + war, has VERY high probabilty of success. 
*When president has majority in house, probability of success is 87%+, compared to only 55%+ if they have senate control. 
*There is a war in 2,4,6,8
*President has majority in house in 5,6,7,8
*President has majority in senate in 3,4,7,8


logit pressuccess_excabstain ForeignAffairs approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh 
margins, at(ForeignAffairs=0 preshouse=(0 1) pressenate=(0 1) wars1yes=(0 1)) atmeans post
*Same thing as before, but for Domestic Affairs. 
*The results are consistently lower than for Foreign Policy, and all are significant. 





















