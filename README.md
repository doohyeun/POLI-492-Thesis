POLI-492-Thesis Code by Doo-Hyeun Roh. 

The 'Final Codes' should be read in the following order. 
  1. PresData, to get Presidential Positions. 
  2. CL Foreign vs Domestic, to get Foreign Affairs in Clinton-Lapinski dataset. 
  3. Controls, to get the control variables compiled into one dataset. 

Once these things are established, then progress to; 
Dataset 1
Dataset 2
Dataset 3

*Note that all the references to various datasets within the code are currently unchanged. e.g; 
clear all
use "/Users/doo-hyeunroh/Documents/UBC Year 5/POLI 492/Thesis/Controls_all.dta"
*As I frequently altered the datasets then saved them under different names to preserve the originals, and merged between the datasets, navigation of these datasets may be difficult. I will endeavor to clear up the clutter in the code, and update them when possible. 


The main sources of datasets used are as follows; 

Clinton-Lapinski 2006 dataset on Legislative Significance; 
https://my.vanderbilt.edu/joshclinton/data/
    see "Measures of Significant Legislation, 1877-1994", Clinton and Lapinski 2006 “Measuring Legislative Accomplishment” AJPS

Comparative Agendas Project(US Datasets), dataset on Congressional Bills 1947-2016
https://www.comparativeagendas.net/us
    see in section 'Parliamentary & Legislative', under 'Congressional Bills' (the one compiled by E. Scott Adler and John Wilkerson)
   
Voteview datasets
https://voteview.com/data
Specifications for; 
    Data Type: Congressional Votes and Member Votes
    Chamber: Both
    Congress: All

Other sources of datasets that are used in this paper; 
Part of the controls dataset is taken from another paper I wrote, “Presidential Leverage and Foreign Aid Policy Outcomes: A Time-Series Analysis”. The dataset for this is at; https://docs.google.com/spreadsheets/d/1UUxDfLvVmhYNyT1lT7rXtpt_D-cFWIpzFLtJFiP5Tq8/edit?usp=sharing

To distinguish the Foreign appropriations bills in Clinton-Lapinski, i used filters in congress.gov. 
https://www.congress.gov/search?q=%7B%22source%22%3A%22legislation%22%2C%22search%22%3A%22foreign+affairs%22%2C%22bill-status%22%3A%22law%22%2C%22house-committee%22%3A%22Appropriations%22%7D&page=3





















