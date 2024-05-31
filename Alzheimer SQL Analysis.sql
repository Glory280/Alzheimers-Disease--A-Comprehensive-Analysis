--Data Cleaning--
SELECT *
FROM [dbo].[alzheimer]

--Identify NULL values--
Select *
FROM [dbo].[alzheimer]
WHERE [Low_Confidence_Limit] IS NULL

--Count NULL values--
SELECT SUM(CASE WHEN [Low_Confidence_Limit] IS NULL THEN 1 ELSE 0 END)
AS missing_count
FROM [dbo].[alzheimer];

--Replace NULL values with mean--
UPDATE [dbo].[alzheimer]
SET High_Confidence_Limit = (
    SELECT ROUND(AVG(High_Confidence_Limit),1)
    FROM [dbo].[alzheimer]
    WHERE High_Confidence_Limit IS NOT NULL)
WHERE High_Confidence_Limit IS NULL;


UPDATE [dbo].[alzheimer]
SET[Low_Confidence_Limit] =(
SELECT ROUND(AVG([Low_Confidence_Limit]),1)
FROM [dbo].[alzheimer]
WHERE [Low_Confidence_Limit] IS NOT NULL)
WHERE [Low_Confidence_Limit] IS NULL


UPDATE [dbo].[alzheimer]
SET [Data_Value]=(
SELECT ROUND( AVG([Data_Value]),1)
FROM [dbo].[alzheimer]
WHERE [Data_Value]IS NOT NULL)
WHERE [Data_Value] IS NULL

-- Replace NULL values with ‘unknown’
UPDATE [dbo].[alzheimer]
SET [Stratification2] =  'unknown'
WHERE [Stratification2]IS NULL


--Geographic Analysis
--How does the prevalence of Alzheimer's disease vary between different locations ?
SELECT [LocationDesc], COUNT([RowId]) AS location_count
FROM [dbo].[alzheimer]
GROUP BY [LocationDesc]
ORDER BY location_count DESC

--What are the distinct locations  and their corresponding abbreviations ?
SELECT DISTINCT [LocationDesc],[LocationAbbr]
FROM [dbo].[alzheimer]

--How does the data value distribution vary by geolocation ?
SELECT  [Geolocation],
ROUND(AVG([Data_Value]),1) AS avg_data_value,
ROUND(MIN([Data_Value]),1)AS min_data_value,
ROUND(MAX([Data_Value]),1) AS max_data_value,
ROUND(STDEV([Data_Value]),1) AS standard_data_value
FROM [dbo].[alzheimer]
GROUP BY [Geolocation]

--How does the confidence interval vary by location ?
SELECT [LocationDesc], 
ROUND(SUM(CAST([Low_Confidence_Limit] AS FLOAT)),1) AS low_limit,
ROUND(SUM(CAST([High_Confidence_Limit] AS FLOAT)),1) AS high_limit
FROM [dbo].[alzheimer]
GROUP BY [LocationDesc]

--How does the data value (Data_Value) compare between different geolocations (Geolocation)?
SELECT [Geolocation], 
ROUND(SUM([Data_Value]),1) AS data_count
FROM [dbo].[alzheimer]
GROUP BY [Geolocation]

--What is the distribution of high confidence limits (High_Confidence_Limit) across different locations (LocationDesc)?
SELECT [LocationDesc],
ROUND(SUM([High_Confidence_Limit]), 1) AS high_limit
FROM [dbo].[alzheimer]
GROUP BY [LocationDesc]
ORDER BY high_limit DESC


--Temporal Analysis
--Temporal Analysis
--How does the data value (Data_Value) change over time between YearStart and YearEnd?
SELECT [YearStart],[YearEnd],
ROUND(AVG([Data_Value]),1) AS avg_value
FROM[dbo].[alzheimer]
GROUP BY [YearStart], [YearEnd]
ORDER BY [YearStart]
--How does the data value (Data_Value) change across different years for the same location (LocationDesc)?
SELECT [LocationDesc],[YearStart],[YearEnd],
ROUND(AVG([Data_Value]),1) AS avg_value
FROM [dbo].[alzheimer]
GROUP BY [LocationDesc],[YearStart],[YearEnd]
ORDER BY [YearStart]

--How does the data value (Data_Value) compare across different years for the same topic (TopicID)?
SELECT [Topic],[YearStart],[YearEnd],
ROUND(AVG([Data_Value]),1) AS avg_value
FROM [dbo].[alzheimer]
GROUP BY [Topic],[YearStart],[YearEnd]


--Data Source and Value Analysis
--What is the average data value  for each data source?
SELECT [Datasource],
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Datasource]
ORDER BY avg_data_value

--Data Type and Value Analysis
--What are the most common data value types recorded in the dataset?
SELECT [Data_Value_Type],
COUNT([Data_Value_Type]) AS num_of_data_value_type
FROM [dbo].[alzheimer]
GROUP BY [Data_Value_Type]

--How does the data value vary between different data value types ?
SELECT [Data_Value_Type],
ROUND(SUM([Data_Value]),1) AS total_data_value
FROM[dbo].[alzheimer] 
GROUP BY [Data_Value_Type]
ORDER BY total_data_value

--How many records have a data value unit of percentage(%)?
SELECT COUNT([Data_Value_Type]) AS value_type
FROM [dbo].[alzheimer]
WHERE [Data_Value_Type] = 'percentage'

--Confidence Intervals Analysis
--How does the low confidence limit compare to the high confidence limit for each topic?
SELECT [Topic], 
ROUND(AVG([Low_Confidence_Limit]),1) AS low_limit,
ROUND(AVG([High_Confidence_Limit]),1) AS high_limit
FROM [dbo].[alzheimer]
GROUP BY [Topic]
ORDER BY low_limit

--What is the average low confidence limit for each topic?
SELECT [Topic], 
ROUND(AVG([Low_Confidence_Limit]),1) AS low_limit
FROM [dbo].[alzheimer]
GROUP BY [Topic]
ORDER BY low_limit

--What is the correlation between data values and their corresponding confidence intervals ?
SELECT [Data_Value] , 
ROUND(AVG([Low_Confidence_Limit]),1) AS low_limit,
ROUND(AVG([High_Confidence_Limit]),1) AS high_limit
FROM [dbo].[alzheimer]
GROUP BY [Data_Value]
ORDER BY low_limit DESC
--(The higher the data value, the higher the low and high confidence limit)

--Stratification Analysis
--How does the data value vary between different Age groups?
SELECT [Stratification1],
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Stratification1]

--What is the frequency of different stratification categories (StratificationCategory1, StratificationCategory2)?
SELECT [Stratification1],[Stratification2],
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Stratification1], [Stratification2]

--How does the data value vary between different races?
SELECT [Stratification2],
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Stratification2]
ORDER BY avg_data_value DESC


--Topic and Class Analysis
--What are the distinct classes and topics covered in the dataset?
--Class
SELECT DISTINCT [Class]
FROM [dbo].[alzheimer]
--Topics
SELECT DISTINCT [Topic]
FROM [dbo].[alzheimer]

--What is the average data value for each class?
SELECT [Class],
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Class]
ORDER BY avg_data_value

--What is the range of data values (Data_Value) for each topic (Topic)?
SELECT [Topic], 
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Topic]
ORDER BY avg_data_value

--How does the data value (Data_Value) vary between different questions (QuestionID)?
SELECT [Question] , 
ROUND(AVG([Data_Value]),1) AS avg_data_value
FROM [dbo].[alzheimer]
GROUP BY [Question]
ORDER BY avg_data_value


--General Data Overview
--How many unique questions (QuestionID) are included in the dataset?
SELECT COUNT(DISTINCT[QuestionID]) AS total_questions
FROM [dbo].[alzheimer]

--How many records have non-null data value footnotes (Data_Value_Footnote)?
SELECT COUNT(*) AS footnote_count
FROM [dbo].[alzheimer]
WHERE [Data_Value_Footnote] IS NOT NULL
