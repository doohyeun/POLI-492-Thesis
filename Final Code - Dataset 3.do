*Final Code - Dataset 3















*FInalDatset3

*All Roll-Call Votes merged with CBills
*Variation of FinalDataset2: instead of just 'passed' roll call votes, now we use them all. 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta"
sort congress year billnum
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta", replace


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions for roll call votes.dta"
rename bill_number billnum
sort congress year billnum
merge m:1 congress year billnum using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/CongressionalBills1947-2012_enactedrollcallmergeprep.dta", generate(clvv) force
*result, 25,354 matched and 32,086 unmatched(from vv)
keep if clvv==3
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/voteview-comparativeagenda all bills merged.dta", clear

*now merge with controls
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
sort year
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta", replace

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/voteview-comparativeagenda all bills merged.dta", clear
sort year
merge m:1 year using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta", generate(finalv2)
*result, 24628 matched. 
keep if finalv2==3

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/comparative agenda/voteview-comparativeagenda all bills merged with controls.dta"

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



*including abstains; no significance. Pseudo R2 = 0.0178, so a poor fit. 
logit PresSuccess_incabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr

*excluding abstains: significance. Pseudo R2 = 0.1282, so not a bad fit. 
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr




logit PresSuccess_excabstain i.ForeignAffairs 
estimates store m1, title(Model 1)
logit PresSuccess_excabstain i.ForeignAffairs c.approval 
estimates store m2, title(Model 2)
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate 
estimates store m3, title(Model 3)
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes 
estimates store m4, title(Model 4)
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained 
estimates store m5, title(Model 5)
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit 
estimates store m6, title(Model 6)
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh 
estimates store m7, title(Model 7)
logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr
estimates store m8, title(Model 8)

logit PresSuccess_incabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr
estimates store m9, title(Model 9)


estout m1 m2 m3 m4 m5 m6 m7 m8 m9, cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant)
esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 using "~/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset3 Presidential Success excluding abstains + one total abstain column" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace
*This is the regression table with both excluding-abstains and one column with abstains included. 

esttab m8 m9 using "~/Documents/UBC Year 5/POLI 492/Thesis/Presentation Day code/FinalDataset3 Presidential Success only last two columns" , cells(b(star fmt(3)) se(par fmt(2))) legend label varlabels(_cons Constant) replace





logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr
margins, at(ForeignAffairs=(0 1))
marginsplot, recast(scatter) aspectratio(1) xscale(range(-.3 1.3)) yscale(range(.6 .73))








*Testing another hypothesis; does year influence anything? 
* b) with multiple roll call votes per bill. Result; year doesn't seem to do anything, just removes significance if you try to limit it to certain time periods. 

*Now, to test, we do 'if year == xx'
*year = 1957-2012

logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if year < 1966
*positive, but no significance. approval ratings are the only significant thing. 

logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if year < 1990
*positive, but no significance. approval ratings, preshouse, war(-), GDP(-), deficit(-), polars(-), polarh are significant

logit PresSuccess_excabstain i.ForeignAffairs c.approval i.preshouse i.pressenate i.wars1yes c.gdpchained c.deficit c.polars c.polarh i.icpsr if year > 1990
*positive, but no significance. preshouse is the only significant thing. 

























