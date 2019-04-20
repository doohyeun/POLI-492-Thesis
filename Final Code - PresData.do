*Final Code - PresData










*VARIABLES. 


*1) Presidential Positions. 
*combine Member Vote (president's vote) with Congressional Vote (aggregate vote)
*Objective; isolate the President's icpsr number from the HSall_members dataset,
	*then use it to get the President's positions on roll-call votes in HSall_votes dataset. 

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
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HSall_votes stata shortened dataset.dta"

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







*summary
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HSall_votes stata shortened dataset.dta"
*here, this dataset shows the 'cast_code' of the president, for every roll-call vote in congress, 
*identified by their congress, chamber, rollnumber, and icpsr code

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HS_rollcalls_shortened dataset.dta"
*here, this dataset shows all roll-call votes result (total yea vs nay counts), 
*identified by their congress, chamber, rollnumber, and bill number. 

clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/merged_roll_call_votes_april1.dta"
*now, this dataset merges the two above by their congress, chamber, and rollnumber. 
*it also includes the yea/nay count, cast_code, bill number, and icpsr code. 
*The cast_code and icpsr are used to identify the President and his vote. 
*The bill number is the identifier. (though we can also use the date). 
*if we wish, we can use the yea vs nay count as margin of victory. 









*ADDITION; we don't want the president's name to be mere numbers, so...


*PART 1; isolate the President's icpsr number from the HSall_members dataset
clear all
cd "~/Documents/UBC Year 5/POLI 492"
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/HSall_members.dta"

tab chamber
*you can see 'president', 'house', 'senate'. Now, we only want Presidents. 

gen Presidents = 0
label variable Presidents "Presidents"
label values Presidents Presidents
recode Presidents 0 = 1 if chamber == "President"
recode Presidents 0 = . if chamber == "House" | chamber == "Senate"
label define Presidents 1 "Presidents"
*now to check
tab Presidents
*As expected, only 123 Presidents. 
*Odd... there is 115 Congresses, but why 123 Presidents? 

gen Presidents_icpsr = icpsr
label variable Presidents_icpsr "Presidents_icpsr"
label values Presidents_icpsr Presidents_icpsr
recode Presidents_icpsr 1/100000= . if Presidents == . 
*here, i use the range of integers 1~100k, since all icpsr codes range from 1 to 99,999. 
*Now, to check
tab Presidents_icpsr 
*several presidents's ID's show u 4 times; these are presidents that were re-elected. 
*Now, we see that if we count the distinct icpsr codes, we arrive at 44 Presidents, which is correct. 
	*(technically it is 43, but Grover Cleveland was 22nd and 24th, counted twice since nonconsecutive). 

*Now, we have our icpsr codes. 

*Now to clear unneeded observations; 
keep if Presidents == 1
keep congress Presidents_icpsr bioname 


tab Presidents_icpsr 
tab bioname

*Now we save this as a new dataset. 

*From now on, to access this, we use; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/Congress and President icpsr.dta"
*note, for the next merger, we need to change the name of the Presidents_icpsr to just icpsr. 
rename Presidents_icpsr icpsr
label variable icpsr "icpsr"
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/Congress and President icpsr.dta", replace



*To recap; 
*President icpsr and bioname list
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/voteview data/Congress and President icpsr.dta"
*shortened Voteview HSALL votes; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/HSall_votes stata shortened dataset.dta"

tab icpsr
*weird... what are icpsr codes 99342, 99369, 99542, 99767? These aren't president codes. President codes are 99869+

*99342, 99542, 99767 is a house member number... 99369 is a senate member. 
*otherwise, all the presidents match up properly. 
*thus, we need to drop them. 

*We move back to the merged dataset used previously; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/merged_roll_call_votes_april1.dta"
drop if icpsr == 99342 
drop if icpsr == 99542
drop if icpsr == 99767
drop if icpsr == 99369

*now it has been properly saved again. 
tab icpsr

*now to label them
label define icpsr 99886 "GRANT, Hiram Ulysses" 99887 "HAYES, Rutherford Birchard" 99888 "GARFIELD, James Abram" 99889 "ARTHUR, Chester Alan" 99890 "CLEVELAND, Stephen Grover" 99891 "HARRISON, Benjamin" 99892 "McKINLEY, William, Jr." 99893 "ROOSEVELT, Theodore" 99894 "TAFT, William Howard" 99895 "WILSON, Thomas Woodrow" 99896 "HARDING, Warren Gamaliel" 99897 "COOLIDGE, Calvin" 99898 "HOOVER, Herbert Clark" 99899 "ROOSEVELT, Franklin Delano" 99900 "TRUMAN, Harry S." 99901 "EISENHOWER, Dwight David" 99902 "KENNEDY, John Fitzgerald" 99903 "JOHNSON, Lyndon Baines" 99904 "NIXON, Richard Milhous" 99905 "FORD, Gerald Rudolph, Jr." 99906 "CARTER, James Earl, Jr." 99907 "REAGAN, Ronald Wilson" 99908 "BUSH, George Herbert Walker" 99909 "CLINTON, William Jefferson (Bill)" 99910 "BUSH, George Walker" 99911 "OBAMA, Barack" 99912 "TRUMP, Donald John"
label values icpsr icpsr

tab icpsr

save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/merged_roll_call_votes_april1_v2.dta"
save "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Presidential Positions for roll call votes.dta"

*now, this dataset identifies bills by their combined congress, chamber, and rollnumber. 
*it also includes the yea/nay count, cast_code, bill number, and president names (icpsr code) while excluding all non-president votes
*The cast_code and icpsr are used to identify the President and his vote. 
*The bill number is the identifier. (though we can also use the date). 
*if we wish, we can use the yea vs nay count as margin of victory. 

*What is lacking here is the TOPIC; we don't know if a roll-call vote was Foreign Affairs or not. 

















