{{
    config
    (
        materialized = 'table'
    )
}}

SELECT
	VIDEO_ID,
	YEAR(DATE_REV) AS YEAR,
	MONTH(DATE_REV) AS MONTH,
	SUM(REVENUE) REVENUE,
	COUNT(*) COUNTS
FROM
	{{ source_t('MY_SCHEMA','VIDEOS_INFO') }}
WHERE
	CATEGORY = 'advertisement'
	AND REVENUE > 0
GROUP BY 
	VIDEO_ID,
	YEAR(DATE_REV),
	MONTH(DATE_REV)
