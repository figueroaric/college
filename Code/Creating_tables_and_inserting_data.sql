USE Colleges
GO

CREATE TABLE Institution(
UNITID	[int],
OPEID	[nvarchar](max),
OPEID6	[nvarchar](max),
INSTNM	[nvarchar](max),
CITY	[nvarchar](max),
STABBR	[nvarchar](max),
ZIP	[nvarchar](max),
MAIN	[int],
LATITUDE	[float],
LONGITUDE	[float]
PRIMARY KEY ([UNITID]));

/*
Inserting rows using r
*/

INSERT INTO [dbo].[Institution]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/Institution.csv",stringsAsFactors = FALSE, h=T, sep =",");
	# LATITUDE and LONGITUDE have the NULL word, have to change to Numeric
	File$LATITUDE = as.numeric(File$LATITUDE)
	File$LONGITUDE = as.numeric(File$LONGITUDE)
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'


CREATE TABLE University_Year(
 UNITID	[int],
OPEID	[nvarchar](max),
OPEID6	[nvarchar](max),
INSTNM	[nvarchar](max),
CITY	[nvarchar](max),
STABBR	[nvarchar](max),
ZIP	[nvarchar](max),
ACCREDAGENCY	[nvarchar](max),
INSTURL	[nvarchar](max),
NPCURL	[nvarchar](max),
SCH_DEG	[int],
HCM2	[int],
MAIN	[int],
NUMBRANCH	[int],
PREDDEG	[int],
HIGHDEG	[int],
[CONTROL][int],
ST_FIPS	[int],
REGION	[int],
LOCALE	[int],
LOCALE2	[nvarchar](max),
LATITUDE	[float],
LONGITUDE	[float],
CCBASIC	[int],
CCUGPROF	[int],
CCSIZSET	[int],
HBCU	[int],
PBI	[int],
ANNHI	[int],
TRIBAL	[int],
AANAPII	[int],
HSI	[int],
NANTI	[int],
MENONLY	[int],
WOMENONLY	[int],
RELAFFIL	[int],
ADM_RATE	[float],
ADM_RATE_ALL	[float],
School_Year	[nvarchar](50),
PRIMARY KEY ([UNITID],[School_Year]) -- IT IS NOT AN ISSUE
)


INSERT INTO [dbo].[University_Year]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/University_year.csv",stringsAsFactors = FALSE, h=T, sep =",");
	# Have to convert several fields to numeric beacuse they have NULLs
	File[c("SCH_DEG","HCM2","MAIN","NUMBRANCH","PREDDEG","HIGHDEG","CONTROL","ST_FIPS","REGION","LOCALE","LATITUDE","LONGITUDE","CCBASIC","CCUGPROF","CCSIZSET","HBCU","PBI","ANNHI","TRIBAL","AANAPII","HSI","NANTI","MENONLY","WOMENONLY","RELAFFIL","ADM_RATE","ADM_RATE_ALL")] = sapply(File[c("SCH_DEG","HCM2","MAIN","NUMBRANCH","PREDDEG","HIGHDEG","CONTROL","ST_FIPS","REGION","LOCALE","LATITUDE","LONGITUDE","CCBASIC","CCUGPROF","CCSIZSET","HBCU","PBI","ANNHI","TRIBAL","AANAPII","HSI","NANTI","MENONLY","WOMENONLY","RELAFFIL","ADM_RATE","ADM_RATE_ALL")], as.numeric)
	
	#print(sapply(File,class))
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'


CREATE TABLE SAT_ACT(
UNITID [int],
SATVR25 [float],
SATVR75 [float],
SATMT25 [float],
SATMT75 [float],
SATWR25 [float],
SATWR75 [float],
SATVRMID [float],
SATMTMID [float],
SATWRMID [float],
ACTCM25 [float],
ACTCM75 [float],
ACTEN25 [float],
ACTEN75 [float],
ACTMT25 [float],
ACTMT75 [float],
ACTWR25 [float],
ACTWR75 [float],
ACTCMMID [float],
ACTENMID [float],
ACTMTMID [float],
ACTWRMID [float],
SAT_AVG [float],
SAT_AVG_ALL [float],
School_Year	[nvarchar](50),
PRIMARY KEY ([UNITID],[School_Year]) -- IT IS NOT AN ISSUE
)

INSERT INTO [dbo].[SAT_ACT]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/SAT_ACT.csv",stringsAsFactors = FALSE, h=T, sep =",");
	# Have to convert several fields to numeric beacuse they have NULLs
	File[c("UNITID","SATVR25","SATVR75","SATMT25","SATMT75","SATWR25","SATWR75","SATVRMID","SATMTMID","SATWRMID","ACTCM25","ACTCM75","ACTEN25","ACTEN75","ACTMT25","ACTMT75","ACTWR25","ACTWR75","ACTCMMID","ACTENMID","ACTMTMID","ACTWRMID","SAT_AVG","SAT_AVG_ALL")] = sapply(File[c("UNITID","SATVR25","SATVR75","SATMT25","SATMT75","SATWR25","SATWR75","SATVRMID","SATMTMID","SATWRMID","ACTCM25","ACTCM75","ACTEN25","ACTEN75","ACTMT25","ACTMT75","ACTWR25","ACTWR75","ACTCMMID","ACTENMID","ACTMTMID","ACTWRMID","SAT_AVG","SAT_AVG_ALL")], as.numeric)
	
	#print(sapply(File,class))
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'

CREATE TABLE Debt(
UNITID [int],
DEBT_MDN [float],
GRAD_DEBT_MDN [float],
WDRAW_DEBT_MDN [float],
LO_INC_DEBT_MDN [float],
MD_INC_DEBT_MDN [float],
HI_INC_DEBT_MDN [float],
DEP_DEBT_MDN [float],
IND_DEBT_MDN [float],
PELL_DEBT_MDN [float],
NOPELL_DEBT_MDN [float],
FEMALE_DEBT_MDN [float],
MALE_DEBT_MDN [float],
FIRSTGEN_DEBT_MDN [float],
NOTFIRSTGEN_DEBT_MDN [float],
DEBT_N [int],
GRAD_DEBT_N [int],
WDRAW_DEBT_N [int],
LO_INC_DEBT_N [int],
MD_INC_DEBT_N [int],
HI_INC_DEBT_N [int],
DEP_DEBT_N [int],
IND_DEBT_N [int],
PELL_DEBT_N [int],
NOPELL_DEBT_N [int],
FEMALE_DEBT_N [int],
MALE_DEBT_N [int],
FIRSTGEN_DEBT_N [int],
NOTFIRSTGEN_DEBT_N [int],
GRAD_DEBT_MDN10YR [float],
CUML_DEBT_N [int],
CUML_DEBT_P90 [int],
CUML_DEBT_P75 [int],
CUML_DEBT_P25 [int],
CUML_DEBT_P10 [int],
DEBT_MDN_SUPP [float],
GRAD_DEBT_MDN_SUPP [float],
GRAD_DEBT_MDN10YR_SUPP [float],
School_Year	[nvarchar](50),
PRIMARY KEY ([UNITID],[School_Year]) -- IT IS NOT AN ISSUE


)

INSERT INTO [dbo].[Debt]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/Debt.csv",stringsAsFactors = FALSE, h=T, sep =",");
	# Have to convert several fields to numeric beacuse they have NULLs
	File[c("UNITID","DEBT_MDN","GRAD_DEBT_MDN","WDRAW_DEBT_MDN","LO_INC_DEBT_MDN","MD_INC_DEBT_MDN","HI_INC_DEBT_MDN","DEP_DEBT_MDN","IND_DEBT_MDN","PELL_DEBT_MDN","NOPELL_DEBT_MDN","FEMALE_DEBT_MDN","MALE_DEBT_MDN","FIRSTGEN_DEBT_MDN","NOTFIRSTGEN_DEBT_MDN","DEBT_N","GRAD_DEBT_N","WDRAW_DEBT_N","LO_INC_DEBT_N","MD_INC_DEBT_N","HI_INC_DEBT_N","DEP_DEBT_N","IND_DEBT_N","PELL_DEBT_N","NOPELL_DEBT_N","FEMALE_DEBT_N","MALE_DEBT_N","FIRSTGEN_DEBT_N","NOTFIRSTGEN_DEBT_N","GRAD_DEBT_MDN10YR","CUML_DEBT_N","CUML_DEBT_P90","CUML_DEBT_P75","CUML_DEBT_P25","CUML_DEBT_P10","DEBT_MDN_SUPP","GRAD_DEBT_MDN_SUPP","GRAD_DEBT_MDN10YR_SUPP")] = sapply(File[c("UNITID","DEBT_MDN","GRAD_DEBT_MDN","WDRAW_DEBT_MDN","LO_INC_DEBT_MDN","MD_INC_DEBT_MDN","HI_INC_DEBT_MDN","DEP_DEBT_MDN","IND_DEBT_MDN","PELL_DEBT_MDN","NOPELL_DEBT_MDN","FEMALE_DEBT_MDN","MALE_DEBT_MDN","FIRSTGEN_DEBT_MDN","NOTFIRSTGEN_DEBT_MDN","DEBT_N","GRAD_DEBT_N","WDRAW_DEBT_N","LO_INC_DEBT_N","MD_INC_DEBT_N","HI_INC_DEBT_N","DEP_DEBT_N","IND_DEBT_N","PELL_DEBT_N","NOPELL_DEBT_N","FEMALE_DEBT_N","MALE_DEBT_N","FIRSTGEN_DEBT_N","NOTFIRSTGEN_DEBT_N","GRAD_DEBT_MDN10YR","CUML_DEBT_N","CUML_DEBT_P90","CUML_DEBT_P75","CUML_DEBT_P25","CUML_DEBT_P10","DEBT_MDN_SUPP","GRAD_DEBT_MDN_SUPP","GRAD_DEBT_MDN10YR_SUPP")], as.numeric)
	
	#print(sapply(File,class))
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'

CREATE TABLE Earnings(
 UNITID [int],
COUNT_NWNE_P10 [int],
COUNT_WNE_P10 [int],
MN_EARN_WNE_P10 [int],
MD_EARN_WNE_P10 [int],
PCT10_EARN_WNE_P10 [int],
PCT25_EARN_WNE_P10 [int],
PCT75_EARN_WNE_P10 [int],
PCT90_EARN_WNE_P10 [int],
SD_EARN_WNE_P10 [int],
COUNT_WNE_INC1_P10 [int],
COUNT_WNE_INC2_P10 [int],
COUNT_WNE_INC3_P10 [int],
COUNT_WNE_INDEP0_INC1_P10 [int],
COUNT_WNE_INDEP0_P10 [int],
COUNT_WNE_INDEP1_P10 [int],
COUNT_WNE_MALE0_P10 [int],
COUNT_WNE_MALE1_P10 [int],
MN_EARN_WNE_INC1_P10 [int],
MN_EARN_WNE_INC2_P10 [int],
MN_EARN_WNE_INC3_P10 [int],
MN_EARN_WNE_INDEP0_INC1_P10 [int],
MN_EARN_WNE_INDEP0_P10 [int],
MN_EARN_WNE_INDEP1_P10 [int],
MN_EARN_WNE_MALE0_P10 [int],
MN_EARN_WNE_MALE1_P10 [int],
COUNT_NWNE_P6 [int],
COUNT_WNE_P6 [int],
MN_EARN_WNE_P6 [int],
MD_EARN_WNE_P6 [int],
PCT10_EARN_WNE_P6 [int],
PCT25_EARN_WNE_P6 [int],
PCT75_EARN_WNE_P6 [int],
PCT90_EARN_WNE_P6 [int],
SD_EARN_WNE_P6 [int],
COUNT_WNE_INC1_P6 [int],
COUNT_WNE_INC2_P6 [int],
COUNT_WNE_INC3_P6 [int],
COUNT_WNE_INDEP0_INC1_P6 [int],
COUNT_WNE_INDEP0_P6 [int],
COUNT_WNE_INDEP1_P6 [int],
COUNT_WNE_MALE0_P6 [int],
COUNT_WNE_MALE1_P6 [int],
MN_EARN_WNE_INC1_P6 [float],
MN_EARN_WNE_INC2_P6 [float],
MN_EARN_WNE_INC3_P6 [float],
MN_EARN_WNE_INDEP0_INC1_P6 [float],
MN_EARN_WNE_INDEP0_P6 [float],
MN_EARN_WNE_INDEP1_P6 [float],
MN_EARN_WNE_MALE0_P6 [float],
MN_EARN_WNE_MALE1_P6 [float],
COUNT_NWNE_P7 [float],
COUNT_WNE_P7 [int],
MN_EARN_WNE_P7 [float],
SD_EARN_WNE_P7 [float],
COUNT_NWNE_P8 [int],
COUNT_WNE_P8 [int],
MN_EARN_WNE_P8 [float],
MD_EARN_WNE_P8 [float],
PCT10_EARN_WNE_P8 [int],
PCT25_EARN_WNE_P8 [int],
PCT75_EARN_WNE_P8 [int],
PCT90_EARN_WNE_P8 [int],
SD_EARN_WNE_P8 [float],
COUNT_NWNE_P9 [int],
COUNT_WNE_P9 [int],
MN_EARN_WNE_P9 [float],
SD_EARN_WNE_P9 [float],

School_Year	[nvarchar](50),
PRIMARY KEY ([UNITID],[School_Year]) -- IT IS NOT AN ISSUE

)

INSERT INTO [dbo].[Earnings]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/Earnings.csv",stringsAsFactors = FALSE, h=T, sep =",");
	# Have to convert several fields to numeric beacuse they have NULLs
	File[c("UNITID","COUNT_NWNE_P10","COUNT_WNE_P10","MN_EARN_WNE_P10","MD_EARN_WNE_P10","PCT10_EARN_WNE_P10","PCT25_EARN_WNE_P10","PCT75_EARN_WNE_P10","PCT90_EARN_WNE_P10","SD_EARN_WNE_P10","COUNT_WNE_INC1_P10","COUNT_WNE_INC2_P10","COUNT_WNE_INC3_P10","COUNT_WNE_INDEP0_INC1_P10","COUNT_WNE_INDEP0_P10","COUNT_WNE_INDEP1_P10","COUNT_WNE_MALE0_P10","COUNT_WNE_MALE1_P10","MN_EARN_WNE_INC1_P10","MN_EARN_WNE_INC2_P10","MN_EARN_WNE_INC3_P10","MN_EARN_WNE_INDEP0_INC1_P10","MN_EARN_WNE_INDEP0_P10","MN_EARN_WNE_INDEP1_P10","MN_EARN_WNE_MALE0_P10","MN_EARN_WNE_MALE1_P10","COUNT_NWNE_P6","COUNT_WNE_P6","MN_EARN_WNE_P6","MD_EARN_WNE_P6","PCT10_EARN_WNE_P6","PCT25_EARN_WNE_P6","PCT75_EARN_WNE_P6","PCT90_EARN_WNE_P6","SD_EARN_WNE_P6","COUNT_WNE_INC1_P6","COUNT_WNE_INC2_P6","COUNT_WNE_INC3_P6","COUNT_WNE_INDEP0_INC1_P6","COUNT_WNE_INDEP0_P6","COUNT_WNE_INDEP1_P6","COUNT_WNE_MALE0_P6","COUNT_WNE_MALE1_P6","MN_EARN_WNE_INC1_P6","MN_EARN_WNE_INC2_P6","MN_EARN_WNE_INC3_P6","MN_EARN_WNE_INDEP0_INC1_P6","MN_EARN_WNE_INDEP0_P6","MN_EARN_WNE_INDEP1_P6","MN_EARN_WNE_MALE0_P6","MN_EARN_WNE_MALE1_P6","COUNT_NWNE_P7","COUNT_WNE_P7","MN_EARN_WNE_P7","SD_EARN_WNE_P7","COUNT_NWNE_P8","COUNT_WNE_P8","MN_EARN_WNE_P8","MD_EARN_WNE_P8","PCT10_EARN_WNE_P8","PCT25_EARN_WNE_P8","PCT75_EARN_WNE_P8","PCT90_EARN_WNE_P8","SD_EARN_WNE_P8","COUNT_NWNE_P9","COUNT_WNE_P9","MN_EARN_WNE_P9","SD_EARN_WNE_P9"
)] = sapply(File[c("UNITID","COUNT_NWNE_P10","COUNT_WNE_P10","MN_EARN_WNE_P10","MD_EARN_WNE_P10","PCT10_EARN_WNE_P10","PCT25_EARN_WNE_P10","PCT75_EARN_WNE_P10","PCT90_EARN_WNE_P10","SD_EARN_WNE_P10","COUNT_WNE_INC1_P10","COUNT_WNE_INC2_P10","COUNT_WNE_INC3_P10","COUNT_WNE_INDEP0_INC1_P10","COUNT_WNE_INDEP0_P10","COUNT_WNE_INDEP1_P10","COUNT_WNE_MALE0_P10","COUNT_WNE_MALE1_P10","MN_EARN_WNE_INC1_P10","MN_EARN_WNE_INC2_P10","MN_EARN_WNE_INC3_P10","MN_EARN_WNE_INDEP0_INC1_P10","MN_EARN_WNE_INDEP0_P10","MN_EARN_WNE_INDEP1_P10","MN_EARN_WNE_MALE0_P10","MN_EARN_WNE_MALE1_P10","COUNT_NWNE_P6","COUNT_WNE_P6","MN_EARN_WNE_P6","MD_EARN_WNE_P6","PCT10_EARN_WNE_P6","PCT25_EARN_WNE_P6","PCT75_EARN_WNE_P6","PCT90_EARN_WNE_P6","SD_EARN_WNE_P6","COUNT_WNE_INC1_P6","COUNT_WNE_INC2_P6","COUNT_WNE_INC3_P6","COUNT_WNE_INDEP0_INC1_P6","COUNT_WNE_INDEP0_P6","COUNT_WNE_INDEP1_P6","COUNT_WNE_MALE0_P6","COUNT_WNE_MALE1_P6","MN_EARN_WNE_INC1_P6","MN_EARN_WNE_INC2_P6","MN_EARN_WNE_INC3_P6","MN_EARN_WNE_INDEP0_INC1_P6","MN_EARN_WNE_INDEP0_P6","MN_EARN_WNE_INDEP1_P6","MN_EARN_WNE_MALE0_P6","MN_EARN_WNE_MALE1_P6","COUNT_NWNE_P7","COUNT_WNE_P7","MN_EARN_WNE_P7","SD_EARN_WNE_P7","COUNT_NWNE_P8","COUNT_WNE_P8","MN_EARN_WNE_P8","MD_EARN_WNE_P8","PCT10_EARN_WNE_P8","PCT25_EARN_WNE_P8","PCT75_EARN_WNE_P8","PCT90_EARN_WNE_P8","SD_EARN_WNE_P8","COUNT_NWNE_P9","COUNT_WNE_P9","MN_EARN_WNE_P9","SD_EARN_WNE_P9"
)], as.numeric)
	
	#print(sapply(File,class))
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'


CREATE TABLE Field_Study_Earnings(
UNITID [int],
OPEID6 [nvarchar](max),
INSTNM [nvarchar](max),
[CONTROL] [nvarchar](max),
MAIN [nvarchar](max),
CIPCODE [nvarchar](max),
CIPDESC [nvarchar](max),
CREDLEV [nvarchar](max),
CREDDESC [nvarchar](max),
[COUNT] [int],
DEBTMEDIAN [float],
DEBTPAYMENT10YR [float],
DEBTMEAN [float],
TITLEIVCOUNT [int],
EARNINGSCOUNT [int],
MD_EARN_WNE [float],
IPEDSCOUNT1 [int],
IPEDSCOUNT2 [int],

); -- Cannot have primary key there are few null UNITID

INSERT INTO [dbo].[Field_Study_Earnings]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/CollegeScorecard_Raw_Data/CollegeScorecard_Raw_Data/FieldOfStudyData1516_1617_PP.csv",stringsAsFactors = FALSE, h=T, sep =",");
	#Loads first column name name incorreclty
	
	colnames(File)[1] = "UNITID"
	print(colnames(File))
	# Have to convert several fields to numeric beacuse they have NULLs
	File[c("UNITID","COUNT","DEBTMEDIAN","DEBTPAYMENT10YR","DEBTMEAN","TITLEIVCOUNT","EARNINGSCOUNT","MD_EARN_WNE","IPEDSCOUNT1","IPEDSCOUNT2")] = sapply(File[c("UNITID","COUNT","DEBTMEDIAN","DEBTPAYMENT10YR","DEBTMEAN","TITLEIVCOUNT","EARNINGSCOUNT","MD_EARN_WNE","IPEDSCOUNT1","IPEDSCOUNT2")], as.numeric)
	
	
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'

CREATE TABLE Cost(
  UNITID [int],
NPT4_PUB [int],
NPT4_PRIV [int],
NPT4_PROG [int],
NPT4_OTHER [int],
NPT41_PUB [int],
NPT42_PUB [int],
NPT43_PUB [int],
NPT44_PUB [int],
NPT45_PUB [int],
NPT41_PRIV [int],
NPT42_PRIV [int],
NPT43_PRIV [int],
NPT44_PRIV [int],
NPT45_PRIV [int],
NPT41_PROG [int],
NPT42_PROG [int],
NPT43_PROG [int],
NPT44_PROG [int],
NPT45_PROG [int],
NPT41_OTHER [int],
NPT42_OTHER [int],
NPT43_OTHER [int],
NPT44_OTHER [int],
NPT45_OTHER [int],
NPT4_048_PUB [int],
NPT4_048_PRIV [int],
NPT4_048_PROG [int],
NPT4_048_OTHER [int],
NPT4_3075_PUB [int],
NPT4_3075_PRIV [int],
NPT4_75UP_PUB [int],
NPT4_75UP_PRIV [int],
NPT4_3075_PROG [int],
NPT4_3075_OTHER [int],
NPT4_75UP_PROG [int],
NPT4_75UP_OTHER [int],
COSTT4_A [int],
COSTT4_P [int],
TUITIONFEE_IN [int],
TUITIONFEE_OUT [int],
TUITIONFEE_PROG [int],
School_Year	[nvarchar](50),
PRIMARY KEY ([UNITID],[School_Year]) -- IT IS NOT AN ISSUE


)

INSERT INTO [dbo].[Cost]
	EXEC sp_execute_external_script
	@language = N'R',
	@script=N'File <- read.csv("C:/Users/figue/Documents/Collegeboard_data/Income.csv",stringsAsFactors = FALSE, h=T, sep =",");
	#Loads first column name name incorreclty
	
	print(colnames(File))
	# Have to convert several fields to numeric beacuse they have NULLs
	File[c("UNITID","NPT4_PUB","NPT4_PRIV","NPT4_PROG","NPT4_OTHER","NPT41_PUB","NPT42_PUB","NPT43_PUB","NPT44_PUB","NPT45_PUB","NPT41_PRIV","NPT42_PRIV","NPT43_PRIV","NPT44_PRIV","NPT45_PRIV","NPT41_PROG","NPT42_PROG","NPT43_PROG","NPT44_PROG","NPT45_PROG","NPT41_OTHER","NPT42_OTHER","NPT43_OTHER","NPT44_OTHER","NPT45_OTHER","NPT4_048_PUB","NPT4_048_PRIV","NPT4_048_PROG","NPT4_048_OTHER","NPT4_3075_PUB","NPT4_3075_PRIV","NPT4_75UP_PUB","NPT4_75UP_PRIV","NPT4_3075_PROG","NPT4_3075_OTHER","NPT4_75UP_PROG","NPT4_75UP_OTHER","COSTT4_A","COSTT4_P","TUITIONFEE_IN","TUITIONFEE_OUT","TUITIONFEE_PROG")] = sapply(File[c("UNITID","NPT4_PUB","NPT4_PRIV","NPT4_PROG","NPT4_OTHER","NPT41_PUB","NPT42_PUB","NPT43_PUB","NPT44_PUB","NPT45_PUB","NPT41_PRIV","NPT42_PRIV","NPT43_PRIV","NPT44_PRIV","NPT45_PRIV","NPT41_PROG","NPT42_PROG","NPT43_PROG","NPT44_PROG","NPT45_PROG","NPT41_OTHER","NPT42_OTHER","NPT43_OTHER","NPT44_OTHER","NPT45_OTHER","NPT4_048_PUB","NPT4_048_PRIV","NPT4_048_PROG","NPT4_048_OTHER","NPT4_3075_PUB","NPT4_3075_PRIV","NPT4_75UP_PUB","NPT4_75UP_PRIV","NPT4_3075_PROG","NPT4_3075_OTHER","NPT4_75UP_PROG","NPT4_75UP_OTHER","COSTT4_A","COSTT4_P","TUITIONFEE_IN","TUITIONFEE_OUT","TUITIONFEE_PROG")], as.numeric)
	
	
	'
	, @input_data_1 = N''
	, @output_data_1_name=N'File'