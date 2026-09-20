/*
Question: What are the most optimal skills (highest demand and highest-paying) for data analysts seeking remote work?
- Combine previous queries to identify skills in highest demand and associated with highest salaries
- Narrow down to top 20
Why? Focused look into skills providing both job security and highest financial benefits, providing insight that can be used 
    towards strategic career development.
*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills,
        COUNT(job_postings_fact.job_id) AS job_count
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short LIKE '%Data%Analyst%'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),
skills_average_salary AS (
    SELECT
        skills_dim.skill_id,
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
        skills_dim.skill_id
)

SELECT
    skills_demand.skills,
    job_count,
    average_salary
FROM
    skills_demand
INNER JOIN skills_average_salary ON skills_demand.skill_id = skills_average_salary.skill_id
WHERE
    job_count > 20
ORDER BY
    average_salary DESC,
    job_count DESC
LIMIT 20;

-- rewriting this query more concisely
SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS job_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short LIKE '%Data%Analyst%'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(job_postings_fact.job_id) > 20
ORDER BY
    average_salary DESC,
    job_count DESC
LIMIT 20;