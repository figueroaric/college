#Collect Scoreboard

#Downloaded files from
#https://collegescorecard.ed.gov/data/


# Have to do some cleaning and analysis of Column Names
#I only want SAT information by year and probably cost

#Most recent college data
Choort_Recent = read.csv("C:/Users/figue/Documents/Collegeboard_data/Most-Recent-Cohorts-All-Data-Elements.csv", stringsAsFactors = FALSE)

#1978 Veriables. Probably I do not want all of this




#Main is Universty and another 4 tables SAT_ACT, Income, Debt and Earnings
#Merged from 2010

# Find common colnames for MERGED2010_11_PP.csv to MERGED2017_18_PP.csv

mergednames = c("MERGED2010_11_PP.csv","MERGED2011_12_PP.csv","MERGED2012_13_PP.csv","MERGED2013_14_PP.csv","MERGED2014_15_PP.csv","MERGED2015_16_PP.csv","MERGED2016_17_PP.csv","MERGED2017_18_PP.csv")

#"C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/"

#used %in% to verify 
columnnames = colnames(Choort_Recent)
for(i in mergednames){
  temp_file = read.csv(paste("C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/",i,sep=""),stringsAsFactors = FALSE)
  columnnames2 = colnames(temp_file)
  columnnames= columnnames[columnnames %in% columnnames2]
}


#all but one of the column names are the same

Choort_Recent = Choort_Recent[,columnnames]

# I want info about school... but also SAT information.

#Info about school  "ï..UNITID" to "ADM_RATE_ALL" from 1 to 38

Colnames_University = colnames(Choort_Recent)[1:38]

#39 to 61 Scores and the did. Firs columns is UNIT id

Colnames_SAT_ACT = colnames(Choort_Recent)[c(1,39:61)]

#NPT is net price 

Colnames_Income = colnames(Choort_Recent)[c(1,grep("NPT|COST|TUITION", colnames(Choort_Recent)))]

#debt

Colnames_Debt = colnames(Choort_Recent)[c(1,grep("DEBT", colnames(Choort_Recent)))]

#earnings WNE

Colnames_Earnings = colnames(Choort_Recent)[c(1,grep("WNE", colnames(Choort_Recent)))]


# have to create different tables
#First basic tables.
#Then loop through old information to get historical data
#have to add dates or references for SAT_ACT.. or filenames

University =  Choort_Recent[,Colnames_University]
University$School_Year = "2018_19"
# check just whether there is duplicated information with MERGED2017_18_PP.csv
#MERGED2017_18_PP = read.csv("C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/MERGED2017_18_PP.csv",stringsAsFactors = FALSE)

SAT_ACT = Choort_Recent[,Colnames_SAT_ACT]
SAT_ACT$School_Year = "2018_19"

Income = Choort_Recent[,Colnames_Income]
Income$School_Year = "2018_19"

Debt = Choort_Recent[,Colnames_Debt]
Debt$School_Year = "2018_19"

Earnings = Choort_Recent[,Colnames_Earnings]
Earnings$School_Year = "2018_19"

#comparison = rbind(Choort_Recent,MERGED2017_18_PP)
#only 163 dupplicated so 17_18 is OK the most recent is 18_19

# Add historical information

 

for(i in mergednames){
  temp_file = read.csv(paste("C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/",i,sep=""),stringsAsFactors = FALSE)
  temp_file$School_Year = substr(i,7,13)
  University = rbind(University,temp_file[,c(Colnames_University,"School_Year")])
  SAT_ACT = rbind(SAT_ACT,temp_file[,c(Colnames_SAT_ACT,"School_Year")])
  Income = rbind(Income,temp_file[,c(Colnames_Income,"School_Year")])
  Debt = rbind(Debt,temp_file[,c(Colnames_Debt,"School_Year")])
  Earnings = rbind(Earnings,temp_file[,c(Colnames_Earnings,"School_Year")])
}


#then create a single consolidated table by institution


Institution =  University[,c("ï..UNITID","OPEID","OPEID6","INSTNM","CITY","STABBR","ZIP", "MAIN","LATITUDE" ,"LONGITUDE")]

Institution = Institution[!duplicated(Institution[,"ï..UNITID"]),]

#should replace column name "ï..UNITID" with "UNITID"

colnames(Institution)[colnames(Institution)=="ï..UNITID"] = "UNITID"
colnames(University)[colnames(University)=="ï..UNITID"] = "UNITID"
colnames(SAT_ACT)[colnames(SAT_ACT)=="ï..UNITID"] = "UNITID"
colnames(Debt)[colnames(Debt)=="ï..UNITID"] = "UNITID"
colnames(Earnings)[colnames(Earnings)=="ï..UNITID"] = "UNITID"
colnames(Income)[colnames(Income)=="ï..UNITID"] = "UNITID"

#write out files

write.csv(Institution,"C:/Users/figue/Documents/Collegeboard_data/Institution.csv", row.names = FALSE)

write.csv(University,"C:/Users/figue/Documents/Collegeboard_data/University_year.csv", row.names = FALSE)

write.csv(SAT_ACT,"C:/Users/figue/Documents/Collegeboard_data/SAT_ACT.csv", row.names = FALSE)

write.csv(Debt,"C:/Users/figue/Documents/Collegeboard_data/Debt.csv", row.names = FALSE)

write.csv(Earnings,"C:/Users/figue/Documents/Collegeboard_data/Earnings.csv", row.names = FALSE)

write.csv(Income,"C:/Users/figue/Documents/Collegeboard_data/Income.csv", row.names = FALSE)

#Consolidate Fields of Study files

#Only FieldOfStudyData1516_1617_PP.csv has data no need to consolidate

FieldofStudy_Earnings = read.csv("C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/FieldOfStudyData1516_1617_PP.csv",stringsAsFactors = FALSE, h=T, sep =",")


table(FieldofStudy_Earnings$CREDLEV)

table(FieldofStudy_Earnings$CREDDESC) #This is information about level of degree

table(FieldofStudy_Earnings$CIPDESC) # degree detail description

#Find highest paid degrees?
#Exclude Median NAs

FieldofStudy_Earnings$Median_Earning = as.numeric(FieldofStudy_Earnings$MD_EARN_WNE)

FieldofStudy_Earnings.clean = FieldofStudy_Earnings[!is.na(FieldofStudy_Earnings$Median_Earning),]

FieldofStudy_Earnings.clean_summary = aggregate(Median_Earning ~ CREDDESC + CIPDESC, data=FieldofStudy_Earnings.clean, mean )


FieldofStudy_Earnings.clean_summary[order(FieldofStudy_Earnings.clean_summary$Median_Earning, decreasing = TRUE),]


FieldofStudy_Earnings.clean_summary.Bachelor = FieldofStudy_Earnings.clean_summary[FieldofStudy_Earnings.clean_summary$CREDDESC=="BachelorÂ's Degree",]

FieldofStudy_Earnings.clean_summary.Bachelor[order(FieldofStudy_Earnings.clean_summary.Bachelor$Median_Earning, decreasing = TRUE),]

#Veterinary Medicine

FieldofStudy_Earnings[FieldofStudy_Earnings$CIPDESC=="Veterinary Medicine."& FieldofStudy_Earnings$CREDDESC=="BachelorÂ's Degree",]

#Louisiana State University and Agricultural & Mechanical College unit id 159391. It seems like Pre-vet

FieldofStudy_Earnings.clean_summary[grep("Econo",FieldofStudy_Earnings.clean_summary$CIPDESC),]

#It would be probably a good idea to show top results by type of degree , debt, admission rate, SAT/ACT



#Group Fields of study

Fields_of_Study = as.data.frame(names(table(FieldofStudy_Earnings$CIPDESC)))

#there are 396 Fields of Study

#Group them into  Categories

#NCES National Center for Education Statistics

#Business, Health Professions and related programs, Social Sciences and History
#Guideline for classifications
# https://www.nsf.gov/statistics/nsf13327/pdf/tabb1.pdf

Fields_of_Study$Category = NA

colnames(Fields_of_Study) = c("Field_of_Study","Category")

#Health classification

Fields_of_Study[grep("Nursing|Medicine|Health|Dentist|Dental|Nurse|Veterinary|Pharmacology|Mortuary",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Health"

#Mathematics and Computer Science

Fields_of_Study[grep("Mathematics|Statistics|Computer Science",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Mathematics or Computer Science"

Fields_of_Study[grep("Biology|Agriculture|Animal|Wildlife|Genetics",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Biological Sciences"

Fields_of_Study[grep("Ocean|Geology|Natural Resource|Geological|Forest|Fishing",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Earth, atmospheric, and ocean sciences"

Fields_of_Study[grep("Business|Marketing|Management|Operations|Accounting|Finance",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Business"

Fields_of_Study[grep("Engineering",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Engineering"

Fields_of_Study[grep("Social|Econom|Sociology|Public|Government",Fields_of_Study$Field_of_Study, ignore.case=TRUE),"Category"] = "Social Sciences"

library(DT)

#Check on use of Datatable

FieldofStudy_Earnings = read.csv("C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/FieldOfStudyData1516_1617_PP.csv",stringsAsFactors = FALSE, h=T, sep =",")


FieldofStudy_Earnings_reduced = FieldofStudy_Earnings[,c("INSTNM","MAIN","CREDDESC", "CIPDESC","DEBTMEDIAN","MD_EARN_WNE")]

#Privacy Suppressed data should be filter out. Then conver to numeric and show as currency

FieldofStudy_Earnings_reduced = FieldofStudy_Earnings_reduced[FieldofStudy_Earnings_reduced$MD_EARN_WNE!="PrivacySuppressed",]
FieldofStudy_Earnings_reduced = FieldofStudy_Earnings_reduced[FieldofStudy_Earnings_reduced$DEBTMEDIAN!="PrivacySuppressed",]

#only Bachelor's degree
FieldofStudy_Earnings_reduced = FieldofStudy_Earnings_reduced[FieldofStudy_Earnings_reduced$CREDDESC=="BachelorÂ's Degree",]
#Only Bachelors
# Chang CIPDESC to factors
FieldofStudy_Earnings_reduced$CIPDESC = as.factor(FieldofStudy_Earnings_reduced$CIPDESC)


#convert to Data table
y <- datatable(FieldofStudy_Earnings_reduced, filter = "top")
#then save to html
saveWidget(y, "C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/Earnings.html")

#COmbine wit Cohort data
Choort_Recent = read.csv("C:/Users/figue/Documents/Collegeboard_data/Most-Recent-Cohorts-All-Data-Elements.csv", stringsAsFactors = FALSE)


FieldofStudy_Earnings_for_rep = FieldofStudy_Earnings[,c("ï..UNITID","INSTNM","MAIN","CREDDESC", "CIPDESC","DEBTMEDIAN","MD_EARN_WNE")]

FieldofStudy_Earnings_for_rep  = FieldofStudy_Earnings_for_rep[FieldofStudy_Earnings_for_rep$MD_EARN_WNE!="PrivacySuppressed",]
FieldofStudy_Earnings_for_rep  = FieldofStudy_Earnings_for_rep[FieldofStudy_Earnings_for_rep$DEBTMEDIAN!="PrivacySuppressed",]

#only Bachelor's degree
FieldofStudy_Earnings_for_rep = FieldofStudy_Earnings_for_rep[FieldofStudy_Earnings_for_rep$CREDDESC=="BachelorÂ's Degree",]
#Only Bachelors
# Chang CIPDESC to factors
FieldofStudy_Earnings_for_rep$CIPDESC = as.factor(FieldofStudy_Earnings_for_rep$CIPDESC)

Choort_Recent_for_rep = Choort_Recent[c("ï..UNITID","STABBR","ADM_RATE","SAT_AVG","NPT4_PUB", "NPT4_PRIV", "NPT45_PUB", "NPT45_PRIV")]

#since all Bachelor do not need CREDESC

FieldofStudy_Earnings_for_rep= FieldofStudy_Earnings_for_rep[,c("ï..UNITID","INSTNM","MAIN", "CIPDESC","DEBTMEDIAN","MD_EARN_WNE")]

FieldofStudy_Earnings_for_rep = merge(FieldofStudy_Earnings_for_rep,Choort_Recent_for_rep,by="ï..UNITID",all.x=TRUE, all.y=FALSE)

# Calculations

FieldofStudy_Earnings_for_rep$Tuition_Average = ifelse(FieldofStudy_Earnings_for_rep$NPT4_PUB=="NULL",FieldofStudy_Earnings_for_rep$NPT4_PRIV,FieldofStudy_Earnings_for_rep$NPT4_PUB)

FieldofStudy_Earnings_for_rep$Tuition_more_110K = ifelse(FieldofStudy_Earnings_for_rep$NPT45_PUB=="NULL",FieldofStudy_Earnings_for_rep$NPT45_PRIV,FieldofStudy_Earnings_for_rep$NPT45_PUB)

#Payback calculations


# have to change few fields to numeric

FieldofStudy_Earnings_for_rep$DEBTMEDIAN = as.numeric(FieldofStudy_Earnings_for_rep$DEBTMEDIAN)
FieldofStudy_Earnings_for_rep$MD_EARN_WNE = as.numeric(FieldofStudy_Earnings_for_rep$MD_EARN_WNE)

FieldofStudy_Earnings_for_rep$ADM_RATE = as.numeric(FieldofStudy_Earnings_for_rep$ADM_RATE)
FieldofStudy_Earnings_for_rep$SAT_AVG = as.numeric(FieldofStudy_Earnings_for_rep$SAT_AVG )
FieldofStudy_Earnings_for_rep$Tuition_Average = as.numeric(FieldofStudy_Earnings_for_rep$Tuition_Average)
FieldofStudy_Earnings_for_rep$Tuition_more_110K = as.numeric(FieldofStudy_Earnings_for_rep$Tuition_more_110K)



FieldofStudy_Earnings_for_rep$Debt_payback_YR = FieldofStudy_Earnings_for_rep$DEBTMEDIAN  / FieldofStudy_Earnings_for_rep$MD_EARN_WNE 

FieldofStudy_Earnings_for_rep$Tuit_Avg_4Y_Pyback = 4*FieldofStudy_Earnings_for_rep$Tuition_Average   / FieldofStudy_Earnings_for_rep$MD_EARN_WNE 

FieldofStudy_Earnings_for_rep$Tuit_Inc_4Y_Pyback = 4*FieldofStudy_Earnings_for_rep$Tuition_more_110K   / FieldofStudy_Earnings_for_rep$MD_EARN_WNE 

FieldofStudy_Earnings_for_rep$Salary_10Y_4Y_Tui = 10*FieldofStudy_Earnings_for_rep$MD_EARN_WNE - 4*FieldofStudy_Earnings_for_rep$Tuition_Average 

#Eliminate NAs in Salary_10Y_4Y_Tui

FieldofStudy_Earnings_for_rep = FieldofStudy_Earnings_for_rep[!is.na(FieldofStudy_Earnings_for_rep$Salary_10Y_4Y_Tui),]



#remove fields do not need and truncate

FieldofStudy_Earnings_for_rep = FieldofStudy_Earnings_for_rep[,c("INSTNM", "MAIN" ,"CIPDESC", "STABBR" , "DEBTMEDIAN", "MD_EARN_WNE" , "ADM_RATE" , "SAT_AVG" , "Tuition_Average" , "Tuition_more_110K", "Debt_payback_YR", "Tuit_Avg_4Y_Pyback" , "Tuit_Inc_4Y_Pyback" , "Salary_10Y_4Y_Tui")]

write.csv(FieldofStudy_Earnings_for_rep,"C:/Users/figue/Documents/Collegeboard_data/Field_of_Studies_Earn_rep.csv")
#Change description and state to Factors

FieldofStudy_Earnings_for_rep$CIPDESC = as.factor(FieldofStudy_Earnings_for_rep$CIPDESC)
FieldofStudy_Earnings_for_rep$STABBR = as.factor(FieldofStudy_Earnings_for_rep$STABBR)

#Round calculations to 2 digits
FieldofStudy_Earnings_for_rep$Debt_payback_YR = round(FieldofStudy_Earnings_for_rep$Debt_payback_YR, digits=2)
FieldofStudy_Earnings_for_rep$Tuit_Avg_4Y_Pyback = round(FieldofStudy_Earnings_for_rep$Tuit_Avg_4Y_Pyback, digits=2)
FieldofStudy_Earnings_for_rep$Tuit_Inc_4Y_Pyback = round(FieldofStudy_Earnings_for_rep$Tuit_Inc_4Y_Pyback, digits=2)
FieldofStudy_Earnings_for_rep$Salary_10Y_4Y_Tui = round(FieldofStudy_Earnings_for_rep$Salary_10Y_4Y_Tui, digits=2)






#convert to Data table


# conver some fields to currency and percentage at the same moment of creating datatable
rep <- datatable(FieldofStudy_Earnings_for_rep, filter = "top", options = list(
  order = list( list(14, 'desc')),pageLength = 100)) %>% 
  formatCurrency(c("DEBTMEDIAN", "MD_EARN_WNE", "Tuition_Average" , "Tuition_more_110K", "Salary_10Y_4Y_Tui"), currency = '$',
                 interval = 3, mark = ',', before = TRUE, digits=0)  %>%  formatPercentage("ADM_RATE", digits=2)



#then save to html
saveWidget(rep, "C:/Users/figue/Documents/Collegeboard_data/Earnings_rep.html")




#only use the degrees with more than 50 Insitutions offering them

FieldofStudy_Earnings_for_rep_count = aggregate(INSTNM ~ CIPDESC,data= FieldofStudy_Earnings_for_rep, length)

FieldofStudy_Earnings_for_rep_count=FieldofStudy_Earnings_for_rep_count[order(FieldofStudy_Earnings_for_rep_count$INSTNM,decreasing=TRUE),]

FieldofStudy_Earnings_for_rep_count[FieldofStudy_Earnings_for_rep_count$INSTNM>49,]
#only keep common
FieldofStudy_Earnings_for_rep_common = FieldofStudy_Earnings_for_rep[FieldofStudy_Earnings_for_rep$CIPDESC %in% FieldofStudy_Earnings_for_rep_count[FieldofStudy_Earnings_for_rep_count$INSTNM>49,"CIPDESC"],]


# conver some fields to currency and percentage at the same moment of creating datatable
rep <- datatable(FieldofStudy_Earnings_for_rep_common, filter = "top", options = list(
  order = list( list(14, 'desc')),pageLength = 100)) %>% 
  formatCurrency(c("DEBTMEDIAN", "MD_EARN_WNE", "Tuition_Average" , "Tuition_more_110K", "Salary_10Y_4Y_Tui"), currency = '$',
                 interval = 3, mark = ',', before = TRUE, digits=0)  %>%  formatPercentage("ADM_RATE", digits=2)



#then save to html
saveWidget(rep, "C:/Users/figue/Documents/Collegeboard_data/Earnings_rep_common.html")
