-- EDA EXPLORATORY DATA ANALYSIS


SELECT * 
FROM layoff_new2;


-- General Review Of Data

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoff_new2;

SELECT * 
FROM layoff_new2
WHERE percentage_laid_off =1
ORDER BY funds_raised_millions DESC;


-- Which Company Has Most Layoffs


SELECT company,SUM(total_laid_off) 
FROM layoff_new2
GROUP BY company
ORDER BY SUM(total_laid_off)  DESC;

SELECT MIN(`Date(YY-MM-DD)`),MAX(`Date(YY-MM-DD)`)
FROM layoff_new2;


-- Which Industry Suffered The Most From Layoffs


SELECT industry,SUM(total_laid_off) 
FROM layoff_new2
GROUP BY industry
ORDER BY SUM(total_laid_off)  DESC;


-- Which Country Affected The Most From Layoffs


SELECT country,SUM(total_laid_off) 
FROM layoff_new2
GROUP BY country
ORDER BY SUM(total_laid_off)  DESC;


-- Which Year Most Of The Laid Off Happened


SELECT YEAR(`Date(YY-MM-DD)`),SUM(total_laid_off) 
FROM layoff_new2
GROUP BY  YEAR(`Date(YY-MM-DD)`)
ORDER BY YEAR(`Date(YY-MM-DD)`)  DESC;


-- Rolling Total Laid Off By Year


SELECT DISTINCT year(`Date(YY-MM-DD)`) AS By_Year,
SUM(total_laid_off)
OVER( ORDER BY YEAR(`Date(YY-MM-DD)`)) AS Rolling_laidoff_Total,
SUM(total_laid_off) 
OVER( PARTITION BY YEAR(`Date(YY-MM-DD)`)) AS Total_Off
FROM layoff_new2
WHERE YEAR(`Date(YY-MM-DD)`) IS NOT NULL ;


-- Which Company Laid off Most Employee By Year


WITH company_laidoff_year(company,tota_laid_off,years) 
AS
(
SELECT company,SUM(total_laid_off) ,YEAR(`Date(YY-MM-DD)`)
FROM layoff_new2
GROUP BY company,YEAR(`Date(YY-MM-DD)`)
),
company_rank_year 
AS 
(
SELECT *,
DENSE_RANK()
OVER(PARTITION BY years ORDER BY tota_laid_off DESC) AS Ranking_of_LaidOff
FROM company_laidoff_year
WHERE years IS NOT NULL
)

-- Top 2 Company Which Has Most Laid Off  Every Year

SELECT *
FROM company_rank_year
WHERE Ranking_of_LaidOff IN (1,2);



