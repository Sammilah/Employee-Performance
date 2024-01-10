USE [Project_progress]

-- Data Cleaning
-- Delete rows with null values from the  [dbo].[EmployeeProjectData] table

DELETE FROM  [dbo].[EmployeeProjectData]
WHERE 
    Productivity_Score IS NULL OR
    Quality_Score IS NULL OR
    Attendance_Score IS NULL;


-- Employee with the highest productivity score
 SELECT TOP 1 *
      FROM [dbo].[EmployeeProjectData]

         ORDER BY [Productivity_Score] DESC;

-- Employee with the lowest productivity score
SELECT TOP 1 *
FROM [dbo].[EmployeeProjectData]
ORDER BY [Productivity_Score]  ASC;

-- Employee with the highest Quality score

SELECT TOP 1 *
FROM [dbo].[EmployeeProjectData]

ORDER BY [Quality_Score] DESC;

-- Employee with the lowest Quality score

SELECT TOP 1 *
FROM [dbo].[EmployeeProjectData]
ORDER BY [Quality_Score] ASC;

--employees with what project they performed by quality
SELECT
    Employee_No,
    Project_Name,
    COUNT(*) AS Attendances,
    AVG(Quality_Score) AS AverageQualityScore
FROM
  [dbo].[EmployeeProjectData]
WHERE
    UPPER(Project_Name) = UPPER('QQQQ') -- Case-insensitive comparison
GROUP BY
    Employee_No, Project_Name
ORDER BY
    Attendances DESC, AverageQualityScore DESC;


--employees with what project they performed by productivity
SELECT
    Employee_No,
    Project_Name,
    COUNT(*) AS Attendances,
    AVG([Productivity_Score]) AS AverageProductivityScore
FROM
  [dbo].[EmployeeProjectData]
WHERE
    UPPER(Project_Name) = UPPER('QQQQ') -- Case-insensitive comparison
GROUP BY
    Employee_No, Project_Name
ORDER BY
    Attendances DESC, AverageProductivityScore DESC;

	-- From above you want to know what other projects did a certain enployee do and how it perfomed  so that you are able to tell
	--..what other projects you can get him into

	SELECT [Employee_No],
	       [Project_Name],
           [Productivity_Score],
		   [Quality_Score],
		   [Attendance_Score]

FROM [dbo].[EmployeeProjectData]
WHERE [Employee_No] = '52'

-- TOP 10 EMPLOYEES IN A CERTAIN PROJECT BY PRODUCTIVITY, 

	SELECT TOP 10
    Employee_No,
    Project_Name,
    [Quality_Score],
    Productivity_Score,
	[Attendance_Score]
FROM
  [dbo].[EmployeeProjectData]
  WHERE  Project_Name = 'UPPP'
ORDER BY
    Productivity_Score DESC;

-- TOP 10 EMPLOYEES IN A CERTAIN PROJECT BY QUALITY 

	SELECT TOP 10
    Employee_No,
    Project_Name,
    [Quality_Score],
    Productivity_Score,
	[Attendance_Score]
FROM
  [dbo].[EmployeeProjectData]
   WHERE  Project_Name = 'UPPP'
ORDER BY
  [Quality_Score]  ASC;

  SELECT TOP 10
    Employee_No,
    Project_Name,
    [Quality_Score],
    Productivity_Score,
	[Attendance_Score]
FROM
  [dbo].[EmployeeProjectData]
ORDER BY
  [Attendance_Score] DESC;


  --workers for each project based on their productivity, quality, and attendance scores,
 
 WITH RankedEmployees AS (
    SELECT
        Employee_No,
        Project_Name,
        Productivity_Score,
        Quality_Score,
        Attendance_Score,
        ROW_NUMBER() OVER (PARTITION BY Project_Name ORDER BY Productivity_Score DESC) AS ProductivityRank,
        ROW_NUMBER() OVER (PARTITION BY Project_Name ORDER BY Quality_Score DESC) AS QualityRank,
        ROW_NUMBER() OVER (PARTITION BY Project_Name ORDER BY Attendance_Score DESC) AS AttendanceRank
    FROM
     [dbo].[EmployeeProjectData]  
)
SELECT
    Employee_No,
    Project_Name,
    Productivity_Score,
    Quality_Score,
    Attendance_Score
FROM
    RankedEmployees
WHERE
    ProductivityRank <= 5
    AND QualityRank <= 5
    AND AttendanceRank <= 5;

	                                         --Case study 2
	
	
	--Identifying Sub-Projects with Excess Capacity:

  SELECT [SubProjectID]
           FROM [dbo].[SubProjectData]
               WHERE [TotalAvailableHeadcount]>[ProjectReuireHeadcount] ;

--Identifying Sub-Projects with Insufficient Capacity:


			     SELECT [SubProjectID]
                      FROM [dbo].[SubProjectData]
                         WHERE [TotalAvailableHeadcount]<[ProjectReuireHeadcount] ;

--   Sub-Projects with Optimal Capacity (Equal Required and Available):

			   
			   
			   SELECT [SubProjectID]
                     FROM [dbo].[SubProjectData]
                            WHERE [TotalAvailableHeadcount]=[ProjectReuireHeadcount] ;

-- Overall Utilization Rate:

SELECT 
    SUM([ProjectReuireHeadcount]) AS Total_Required_Headcount,
    SUM([TotalAvailableHeadcount]) AS Total_Available_Headcount,
    SUM([ProjectReuireHeadcount]) / SUM([TotalAvailableHeadcount]) AS Utilization_Rate
FROM [dbo].[SubProjectData];
