--Example on how to use R within SSRS

-- Instructions found in https://www.r-bloggers.com/using-r-in-sql-server-reporting-services-ssrs/
USE Colleges
GO

CREATE TABLE R_data (
 v1 INT ,v2 INT,v_low INT,v_high INT,letter CHAR(1));
GO

CREATE OR ALTER PROCEDURE generate_data
AS
BEGIN
  INSERT INTO R_data(v1,v2,v_low,v_high,letter)
  SELECT TOP 10
    CAST(v1.number*RAND() AS INT) AS v1
   ,CAST(v2.number*RAND() AS INT) AS v2
   ,v1.low AS v_low
   ,v1.high AS v_high
   ,SUBSTRING(CONVERT(varchar(40), NEWID()),0,2) AS letter
  FROM master..spt_values AS v1
  CROSS JOIN master..spt_values AS v2
  WHERE  v1.[type] = 'P' AND v2.[type] = 'P'
 ORDER BY NEWID() ASC;
END
GO
EXEC generate_data;
GO 10


--The idea is, to have the values “v1” and “letter” parametrized:

SELECT * FROM R_data
WHERE 
 v1 > 400 -- replace this with parameter; e.g.: @v1
AND letter IN ('1','2','3') -- replace this with parameter; e.g.: @letters


CREATE OR ALTER PROCEDURE sp_R1(
   @v1 INT
  ,@lett VARCHAR(20)
) AS
BEGIN
 DECLARE @myQuery NVARCHAR(1000)

  CREATE TABLE #t (let CHAR(1))
  INSERT INTO #t
  SELECT value
  FROM STRING_SPLIT(@lett,',')
 
 SET @myQuery = N'
    SELECT * FROM R_data
    WHERE 
    v1 > '+CAST(@v1 AS VARCHAR(10))+'
    AND letter IN (SELECT * FROM #t)'

EXEC sp_execute_external_script
 @language = N'R'
 ,@script = N'
   df <- InputDataSet 
   OutputDataSet <- data.frame(summary(df))'
  ,@input_data_1 = @myQuery
WITH RESULT SETS
((v1 NVARCHAR(100)
 ,v2 NVARCHAR(100)
 ,freq NVARCHAR(100)))
END;
GO

EXEC sp_R1 @v1 = 670, @lett = '1,2,3'

--Need to look for parameter v1

SELECT  [v1]
FROM [Colleges].[dbo].[R_data]
ORDER BY [V1]

SELECT DISTINCT [letter]
FROM [Colleges].[dbo].[R_data]
ORDER BY [letter]

-- Now I want chart , new procedure



  CREATE OR ALTER PROCEDURE sp_R2(@lett2 VARCHAR(20)) AS
BEGIN
 DECLARE @myQuery NVARCHAR(1000)

  CREATE TABLE #t (let CHAR(1))
  INSERT INTO #t
  SELECT value
  FROM STRING_SPLIT(@lett2,',')
 
 SET @myQuery = N'
    SELECT * FROM R_data
    WHERE 
    letter IN (SELECT * FROM #t)'

EXEC sp_execute_external_script
 @language = N'R'
 ,@script = N'
  df <- InputDataSet 
  image_file <- tempfile()
  jpeg(filename = image_file, width = 400, height = 400)
  boxplot(df$v1~df$letter)
  dev.off()
  OutputDataSet <- data.frame(data=readBin(file(image_file, "rb"), what=raw(), n=1e6))'
  ,@input_data_1 = @myQuery
WITH RESULT SETS
((
   boxplot VARBINARY(MAX)
))
END;
GO


SELECT * FROM R_data
    WHERE letter  Like '%A%'

--testing box plot field
EXEC sp_R2 @lett2 = '1,2,3';
GO

-- Have to provide default value in Visual Studio to create the dataset for first time

-- I am going to do Field of Study and States Boxplot

-- This will be the Source Data
SELECT A.INSTNM, A.CITY, A.STABBR, A.MAIN, B.CREDDESC, B.CIPDESC, B.MD_EARN_WNE, B.DEBTMEDIAN, C.ADM_RATE, D.SATMTMID, D.SATVRMID, D.SATWRMID, D.SAT_AVG, D.SAT_AVG_ALL, E.NPT4_PUB, E.NPT4_PRIV, E.NPT45_PUB, E.NPT45_PRIV
FROM dbo.Institution AS A
INNER JOIN dbo.Field_Study_Earnings AS B
ON A.UNITID = B.UNITID
INNER JOIN dbo.University_Year AS C
ON A.UNITID = C.UNITID
INNER JOIN dbo.SAT_ACT AS D
ON A.UNITID = D.UNITID
INNER JOIN dbo.Cost AS E
ON A.UNITID = E.UNITID
WHERE B.MD_EARN_WNE IS NOT NULL AND C.School_Year = '2018_19' AND D.School_Year = '2018_19' AND E.School_Year = '2018_19' AND B.CREDDESC LIKE 'Bache%' AND B.CIPDESC IN (@Field_of_Study) AND  A.STABBR IN (@States)
ORDER BY B.MD_EARN_WNE DESC

--Create Procedure
CREATE OR ALTER PROCEDURE Field_State(@Field VARCHAR(5000), @State VARCHAR(5000)) AS
BEGIN
 DECLARE @myQuery NVARCHAR(4000)

  CREATE TABLE #t (F NVARCHAR(max))
  INSERT INTO #t
  SELECT value
  FROM STRING_SPLIT(@Field,',')
 
   CREATE TABLE #t2 (S NVARCHAR(max))
  INSERT INTO #t2
  SELECT value
  FROM STRING_SPLIT(@State,',')

 SET @myQuery = N'
SELECT  B.CIPDESC, B.MD_EARN_WNE
FROM dbo.Institution AS A
INNER JOIN dbo.Field_Study_Earnings AS B
ON A.UNITID = B.UNITID
INNER JOIN dbo.University_Year AS C
ON A.UNITID = C.UNITID
INNER JOIN dbo.SAT_ACT AS D
ON A.UNITID = D.UNITID
INNER JOIN dbo.Cost AS E
ON A.UNITID = E.UNITID
WHERE B.MD_EARN_WNE IS NOT NULL AND C.School_Year = ''2018_19'' AND D.School_Year = ''2018_19'' AND E.School_Year = ''2018_19'' AND B.CREDDESC LIKE ''Bache%'' AND B.CIPDESC IN (SELECT * FROM #t) AND  A.STABBR IN (SELECT * FROM #t2)
'

EXEC sp_execute_external_script
 @language = N'R'
 ,@script = N'
  df <- InputDataSet 
  image_file <- tempfile()
  jpeg(filename = image_file, width = 1600, height = 900)
  boxplot(df$MD_EARN_WNE~df$CIPDESC, cex.axis=2)
  dev.off()
  OutputDataSet <- data.frame(data=readBin(file(image_file, "rb"), what=raw(), n=1e6))'
  ,@input_data_1 = @myQuery
WITH RESULT SETS
((
   boxplot VARBINARY(MAX)
))
END;
GO

--testing box plot field
--Issue is how to maange commas... will have to replace commas with spaces in CIPDESC
EXEC Field_State @Field = 'Civil Engineering., Chemistry.' , @State = 'FL,TX,CA';
GO

