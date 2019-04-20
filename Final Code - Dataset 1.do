*Final Code - Dataset 1



*To sum up; 


*Clinton-Lapinski dataset on Foreign vs Domestic Affairs, with Legislative Significance for Bills. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic.dta"
*this dataset has foreign affairs(appropriations) seperated, as well as foreign affairs (non-appropriations)
*the result is the variable 'Foreignaffairs_all', which gives 1 = Foreign affairs and 0 = Domestic Affairs. 

***Importantly, for testing within lapinski data, all years 1994+ should be discarded since clinton-lapinski do not cover them. 


*Voteview dataset that has the President's vote and Congress's vote on all roll-call votes. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions for roll call votes.dta"
*now, this dataset identifies bills by their combined congress, chamber, and rollnumber. 
*it also includes the yea/nay count, cast_code, bill number, and president names (icpsr code) while excluding all non-president votes
*The cast_code and icpsr are used to identify the President and his vote. 
*The bill number is the identifier. (though we can also use the date). 
*if we wish, we can use the yea vs nay count as margin of victory. 



*Now we need to merge those two together based on Congress,Bill Number, and Date. 
*Congress = 'congress' in lapinski, 'congress' in voteview. No need to change. 
*Bill Number = 'billnum' in lapinski, 'bill_number' in voteview, NEED to change. 
*Date = 'month' 'day' 'year' in lapinski, 'month' 'day' 'year' in voteview. No need to change
*problems; 
*1) Bill number in lapinski dataset sometimes have spaces&Capitals and sometimes don't  
*2) Date in Lapinski has separate month,date, year variables while Voteview has them in string format together. 


*Issue 1; 
*spaces and capitals in Lapinski dataset  
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic.dta"
replace billnum = subinstr(billnum, " ", "", .)
*this removes all spaces(including those in the middle)
replace billnum = upper(billnum)
*this should turn all lowercase letters to uppercase (capitalizations)
*Now save
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta"
*This is the new clinton-lapinski dataset with all capitals and no spaces. 
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta"


*Issue 2
*date
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions for roll call votes.dta"
gen date1=date(date,"YMD")
format date1 %td
gen year=year(date1)
gen month=month(date1)
gen day=day(date1)
*this creates 3 variables 'year' 'month' 'day'
*thus our problem 2 is solved. 
*And while we're at it we can change the variable name of bill_number and date to match lapinski. 
rename bill_number billnum
 

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions_RC_with dates.dta"


*Now, problem 1 and 2 are solved, and all variables are synced up. 
*the two datasets are; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta"
destring month, replace
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta", replace
*38,250 observations, 24 variables

*and
clear all
use  "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions_RC_with dates.dta"
*57,440 observations, 25 variables. 

*Now, to merge these two together, we use the key variables congress, year, month, day, billnum


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta"
sort congress year month day billnum
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta", replace

clear all
use  "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions_RC_with dates.dta"
sort congress year month day billnum

*now, use joinby or merge? 
merge 1:1 congress year month day billnum using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta", generate(cl_vv) force

*says variables congress year month day billnum do not uniquely identify observations in the master data

duplicates list congress year month day billnum
*Looks like the  problem is multiple roll-call votes of the same bill taken on the same day. 
*It would be a problem to remove them all since this itself could bias results (more votes on one day = more/less importance)

*It is looking like the only way to resolve this problem is to assume the last vote is the 'final' deciding vote. 
*This is further assuming that any further amendments to the bill will have been done in another day, or in another bill entirely. 



*Option; remove all the duplicate roll-call votes. 
*NOTE; I am choosing to use the most 'recent' roll-call vote as the final vote. 
*This 'most recent' is decided by using the highest rollnumber, given the same congress, year, month, day, and billnum. 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions_RC_with dates.dta"

drop if missing(billnum)
*this removes all variables that don't have a bill number (thus we limit this to enacted bills)
gen net_count = yea_count - nay_count
*This shows whether the vote in question succeeded or not. 
*Since in lapinski we only have enacted bills, we can remove all 'failed votes' to simplify things. 
keep if net_count > -1
*This includes a tied result, where Vice-President would hold the 'deciding vote'. 
*This is where those previous 150+ missing values when merging the dataset probably came from, when we deleted the icpsr codes not belonging to a president. 


sort congress year month day billnum rollnumber
quietly by congress year month day billnum: gen dup = cond(_N==1, 0,_n)

*Now, the rollnumber variable is sorted from least to greatest (e.g. from 1-4)
*Thus, to keep the 'latest' roll call vote, we want the highest dup observation. 
*e.g. when there's dup 1,2,3,4, we want to keep 4 and drop 1,2,3. 
bysort congress year month day billnum: egen t = max(dup)

keep if dup == t
*This leaves only the 'latest' roll-call votes. 
*This results in 22,678 observations. 
tab vote_result
*amendment agreed to 472, bill passed = 609, joint resolution passed = 46, 
*Passed = 6741, Resolution agreed to = 82, resolution of ratification agreed to = 29

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/cl_test2.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/cl_test2.dta"



clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic all caps.dta"
drop if missing(billnum)
sort congress year month day billnum 
quietly by congress year month day billnum: gen dup = cond(_N==1, 0,_n)
tab dup
*only 16 observations have duplicates... so that isn't the problem. 
*Also these duplicates are distinct bills... that have virtually no 'key' difference except for their description. 
*Problem is that some of them vary widely in rank (e.g. 7120 vs 27164 for HRES169 in the 51st Congress. 
*My resort is dropping them all. I can't choose one over the other because it would be bias. 

drop if dup > 0
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset duplicate_free.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset duplicate_free.dta"



*Continue with merging now. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/cl_test2.dta"
sort congress year month day billnum
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/cl_test2.dta", replace

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset duplicate_free.dta"
sort congress year month day billnum

merge 1:1 congress year month day billnum using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/cl_test2.dta", generate(clvv)
*only 108 observations that matched. 
keep if clvv==3
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/PresData-CLdata-100obs.dta"
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/PresData-CLdata-100obs.dta"

*now, we need to merge with control variables. 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
*this is all the controls, from year 1957-2014 (congress 85-113)


*Merging final 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
sort year
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta", replace

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/PresData-CLdata-100obs.dta"
sort year
merge m:1 year using "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta", generate(finalv1)
keep if finalv1==3
*we are left with 51 observations. 

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Final Dataset 1.dta"




*The MASSIVE PROBLEM; 
*billnumber does not match up b/w lapinski and voteview
*hell, some aren't even there. 
*e.g. congress 45, year 1878, HR 6126, is clearly there in lapinski but not even mentioned in voteview. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/merged_roll_call_votes_april1_v2.dta"
*now check for hr6126. its not there. 
*How about HR 11027, year 1975-12-16, congress 94, PL 153, on banking currency and housing; its in clinton. 
	*in voteview? not there in bill number. On that date there is bill HR 8631 for 5 roll call votes, and 1 vote to recess...
	*and the topic...? Joint-Atomic Energy. 
	*Congress.gov says hr11027 was PL 94-153. 

*hmm... lapinski attatches significance scores to all bills. 
*Bills identified by their bill number and congress. 
*So lets try making things alot more general, and match just by congress and billnumber. 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset duplicate_free.dta"
sort congress billnum
duplicates list congress billnum
*62 duplicates
quietly by congress billnum: gen dup1 = cond(_N==1, 0,_n)
tab dup1
drop if dup1 > 0
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset test1.dta"

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/merged_roll_call_votes_with dates.dta"
drop if missing(billnum)
sort congress billnum

merge m:1 congress billnum using  "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset test1.dta", generate(clvv)

*hmm.... still over 30k unmatched from both clinton and voteview, meaning a few hundred are all that really matched. 













*Just as a proof of concept, we run regressions now. 
*This is what I show in the thesis. 

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










*Some hypothesizing regarding proxies to use for Legislative Significance in future research; 


clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/clinton-lapinski dataset with foreign v domestic.dta"

*meansig = clinton lapinski's legislative significance measure. 
*pagemain, pagesubs, and totalpages are the number of pages on the bill. 


pwcorr meansig pagemain pagesubs totalpages, sig star(.005)
*high positive correlation, highly significant. 
reg meansig pagemain 
reg meansig totalpages
*Both are extremely highly significant and positive; higher number of pages = higher significance. 
*so this looks like you *can* predict legislative significance with page numbers. 






















