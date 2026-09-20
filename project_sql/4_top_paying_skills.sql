/*
Question: What are the top skills based on salary for remote data analysts?
- Identify skills associated with the highest salaries on average
- Narrow down to top 20 skills
Why? Providing a look into skills associated with the highest-paying data analyst jobs.
*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Data%Analyst%'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 20;