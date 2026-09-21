# Introduction
This project uses SQL queries to explore the data job market of 2023, focusing on remote data analyst roles and identifying skills in high demand as well as skills associated with highest salaries, providing insight to job seekers aiming to strategize their career development.

SQL queries can be found within the [project_sql folder](/project_sql/).

# Background
As an aspiring data analyst, I wanted to gain a better understanding of the job market for data-related jobs, with a focus on data analyst roles in addition to roles located remotely. As I continue on my journey of developing my skills, I wanted to learn which skills employers offering the highest-paying jobs are most frequently looking for. This will allow me to plan my personal education efficiently and ensure I use my time wisely in developing skills that will prove most valuable to employers.

I accomplish this by navigating and analyzing a real database of job openings collected from 2023, taking advantage of information related to employers, salaries, locations, required skills, and more. I also used this experience to learn SQL by following along with Luke Barousse in his YouTube course on SQL for data analysts.

Data was obtained from the [SQL Course by Luke Barousse](https://lukebarousse.com/sql).

### Questions I wanted to answer through my SQL queries:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For this project, I learned how to navigate and maximize the potential of the following tools:
- **SQL:** Used to query the database.
- **PostgreSQL:** Database handling system used.
- **Visual Studio Code:** Used for database management and running SQL queries.
- **Git & GitHub:** Allowed me to publish my findings and track all changes.

# The Analysis
Each query aimed to investigate the data analyst job market for the answer to one of the five questions mentioned above. Here is how I approached each one:

### 1. Top-Paying Data Analyst Jobs
To find the highest-paying data analyst roles, I filtered all data analyst job openings by yearly salaries, focusing on jobs located remotely. This query narrows down the top ten highest-paying opportunities:

```sql
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
```
Analysis of top-paying data analyst jobs:

- **Roles:** Senior, Principal, and Director-level analytics roles dominate the higher salaries, generally $185K–$337K.
- **Salaries:** The $205K median is more representative than the $265.6K average because the $650K Mantys role is a major outlier.
- **Companies:** Opportunities span tech, healthcare, finance, telecom, AI, and automotive, showing strong cross-industry demand for analytics expertise.

### 2. Skills for Top-Paying Jobs
To learn what skills employers of these top-paying data analyst jobs look for, I used the previous query and joined the job postings to the skills data to retrieve all skills required for these roles.

```sql
WITH top_paying_jobs AS
(
    SELECT
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_title_short LIKE '%Data%Analyst%'
        AND job_work_from_home = TRUE
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
;
```
Analysis of top-paying jobs required skills:

- **SQL + Python are essential:** Both appear in every role, making them the core technical skills for data analysts.
- **BI skills are highly valued:** Tableau, Power BI, and Excel show that data visualization and business communication remain important.
- **Advanced roles require broader technical skills:** Cloud platforms, Snowflake, Databricks, PySpark, and engineering tools become more common in senior positions.

### 3. In-Demand Skills
To find out what skills are in highest demand across all remote data analyst jobs, I sorted all skills by highest frequencies found in job postings and narrowed down to the top ten skills.

```sql
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
```
Top skills by highest demand:

|Skill     |Job Count|
|---|---|
|SQL	   |9,015|
|Python    |5,384|
|Excel	   |5,311|
|Tableau   |4,744|
|Power BI  |3,070|
|R	       |2,656|
|SAS	   |2,268|
|Looker	   |1,216|
|Azure 	   |989|
|PowerPoint|974|

Analysis of highest-demand skills:

- **SQL dominates:** With 9,015 jobs, SQL is by far the most in-demand skill, making it a foundational requirement for data analysts.
- **Python, Excel & Tableau are strong secondary skills:** Each appears in 4,700–5,400 jobs, highlighting the importance of programming, spreadsheets, and data visualization.
- **BI and cloud skills add value:** Power BI, R, SAS, Looker, and Azure show demand for broader analytics, business intelligence, and cloud capabilities.


### 4. Skills Based on Salary

Next, I sorted all skills within data analyst jobs by the highest average yearly salaries associated with them.

```sql
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
```
Top skills by highest pay:

|Skill      |Average Salary|
|---|---|
|Bitbucket	|$189,155|
|FastAPI	|$185,000|
|Angular	|$185,000|
|Keras	    |$185,000|
|PySpark	|$182,586|
|Golang	    |$161,750|
|Watson  	|$160,515|
|Couchbase	|$160,515|
|GitLab	    |$154,500|
|Jupyter	|$151,138|

Analysis of skills based on salary:

- **Technical specialization associated with higher salaries:** Bitbucket, FastAPI, Angular, Keras, and PySpark lead the list at roughly $183K–$189K on average.
- **AI/data engineering skills are valuable:** PySpark, Keras, Pandas, NumPy, PyTorch, TensorFlow, and Kafka all appear among the higher-paying skills, highlighting demand for advanced technical capabilities.
- **Tooling skills also correlate with strong pay:** Development and infrastructure tools such as GitLab, Jupyter, Linux, and Cassandra show salaries generally above $135K, suggesting broader technical depth can complement traditional analytics skills.

### 5. Most Optimal Skills to Learn
Combining both demand and pay in order to determine the overall most optimal skills to learn, this query sorts skills by both high demand and highest salaries.

```sql
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
```
Top high demand, high pay skills:

|Skill	    |Job Count|Average Salary|
|---|---|---|
|Go	        |40	      |$118,777|
|Snowflake	|63	      |$115,615|
|Hadoop	    |26	      |$115,471|
|Azure	    |41	      |$113,543|
|Java	    |21	      |$113,129|
|AWS	    |38	      |$112,958|
|Looker	    |81	      |$111,849|
|Oracle	    |47       |$108,575|
|Jira	    |30	      |$106,739|
|Python	    |308      |$106,138|
|R	        |189      |$104,267|
|Tableau	|310      |$103,785|
|SQL Server	|45	      |$102,785|
|SAS	    |82	      |$102,204|
|Redshift	|22	      |$102,072|
|SQL	    |525      |$101,923|
|JavaScript	|23	      |$101,663|
|Flow	    |42	      |$100,967|
|SPSS	    |32	      |$100,586|

Analysis of high demand, high pay skills:

- **SQL & Python balance demand and pay:** SQL appears in 525 jobs and Python in 308, with average salaries of $101.9K and $106.1K, making them strong foundational skills.
- **Cloud and data-platform skills command higher pay:** Go, Snowflake, Hadoop, Azure, Java, and AWS average roughly $113K–$119K, indicating value in technical infrastructure skills.
- **BI skills offer strong demand:** Tableau, Looker, and SAS combine substantial job volume with salaries around $102K–$112K, highlighting continued demand for analytics and visualization expertise.

# What I Learned
This project was a valuable learning experience for me to develop, practice, and internalize the following skills:

1. **SQL & Data Analysis:** Developed practical SQL skills, including table joins, aggregations, filtering, grouping, and querying datasets to extract meaningful insights.
2. **Job Market Analysis:** Learned to analyze data analyst job-market trends by examining skills, salaries, job demand, roles, and companies to identify valuable career skills.
3. **Real-World Data Insights:** Applied SQL and analytical thinking to real-world datasets, transforming raw job-market data into tables, summaries, and actionable insights.

# Conclusions

### Insights
The analysis revealed several key insights:
 1. **Core skills:** **SQL and Python** are the strongest foundation, combining the highest job demand with solid salaries.
2. **Business intelligence:** **Tableau, Power BI, Excel, and Looker** remain highly relevant for reporting, visualization, and communicating insights.
3. **High-value technical skills:** **Snowflake, AWS/Azure, PySpark, cloud platforms, and data engineering tools** are associated with higher average salaries and can help differentiate candidates for advanced roles.
4. **Best overall skill stack:** **SQL + Python + Tableau/Power BI + cloud/data-warehouse technology** provides a strong combination of demand, versatility, and earning potential based on your datasets.
5. **Career progression:** The highest-paying roles tend to combine analytics with **technical depth, specialized domains, or leadership**, rather than relying on traditional analyst skills alone.

### Closing Thoughts
This project strengthened my ability to use SQL and data analysis techniques to work with real-world datasets and turn raw information into meaningful insights. By analyzing data analyst roles, salaries, companies, and in-demand skills, I gained a better understanding of the job market and the technical skills employers value most. Overall, the project helped me develop practical skills in data querying, aggregation, table joins, data interpretation, and communicating findings through clear tables and concise analysis.