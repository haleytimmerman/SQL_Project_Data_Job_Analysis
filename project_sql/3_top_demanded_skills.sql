/*
Question: What are the most in-demand skills for data analysts?
- Identify skills demanded most frequently in data analyst jobs
- Include all remote data analyst openings in count
- Narrow down to top 10 skills
Why? Providing furthur insight into skills employers look for most often for data analyst jobs.
*/

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Data%Analyst%'
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    job_count DESC
LIMIT 10;