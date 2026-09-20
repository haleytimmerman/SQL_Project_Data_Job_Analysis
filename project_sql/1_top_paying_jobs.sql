/*
Question: What are the highest-paying remote data analyst jobs?
- Include only remote jobs offering a yearly salary
- Include company names and schedule type
- Narrow down to top 10 jobs
Why? Discover top pay opportunities and companies offering top-paying jobs for data analysts wanting to work remotely.
*/

SELECT
    job_id,
    job_title,
    name AS company_name,
    salary_year_avg,
    job_schedule_type,
    job_location
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    salary_year_avg IS NOT NULL AND
    job_title_short LIKE '%Data%Analyst%' AND
    job_work_from_home = TRUE
ORDER BY
    salary_year_avg DESC
LIMIT 10;