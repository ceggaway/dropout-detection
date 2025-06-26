-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database


engagement
+---------+-----------+-----------+----------+-----------+----------+----------+
| user_id | course_id | num_event | num_days | num_video | num_chap | num_post |
+---------+-----------+-----------+----------+-----------+----------+----------+
|       1 |         5 |         0 |        0 |         0 |        0 |        0 |
+---------+-----------+-----------+----------+-----------+----------+----------+

 enrollment
+---------+-----------+------------+------------+------------+--------+----------+-----------+---------+-------+
| user_id | course_id | start_day  | last_login | registered | viewed | explored | certified | dropout | grade |
+---------+-----------+------------+------------+------------+--------+----------+-----------+---------+-------+
|       1 |         5 | 0000-00-00 | 0000-00-00 |          1 |      0 |        0 |         0 |       0 |     0 |
+---------+-----------+------------+------------+------------+--------+----------+-----------+---------+-------+

 courses
+-----------+----------------------------+
| course_id | title                      |
+-----------+----------------------------+
|         1 | HarvardX/CB22x/2013_Spring |
+-----------+----------------------------+

 user
+---------+---------+----------------+
| user_id | country | username       |
+---------+---------+----------------+
|       1 | Canada  | MHxPC130000002 |
+---------+---------+----------------+



Retrieve a list of users at risk of dropping out
View average quiz scores and engagement per course
Identify the most and least engaging courses
Generate dropout trend reports by time, course, or country
Flag users manually or automatically for follow-up
Display results in a dashboard



/*
## Implementation Plan: Defining and Identifying Poor Performance

To classify at-risk users, we define poor performance using two key factors: engagement score and grade performance.

We also used Pearson correlation and found a strong positive relationship between engagement and grade (r = 0.71, p < 0.0001).
This validates the use of both metrics in detecting dropout risk.

### 1. Engagement score

Definition: A learner is considered to have low engagement if their combined interaction score is less than 4.
classification tool: composite score + rule based calculation
statistical tool : median, histogram
Engagement Score Formula: engagement_score = num_event + num_video + num_chap + num_post


Justification:
Combines multiple behavioral signals into one interpretable metric
The median engagement score was 4, and the histogram shows that most users score below 10
A threshold of < 4 captures the bottom 50% of learners in terms of platform interaction
*/


-- view to calculate composite engagement scores
CREATE view view_engagement_score AS
SELECT
    user_id,
    course_id,
    COALESCE(num_event, 0) + COALESCE(num_video, 0) + COALESCE(num_chap, 0) + COALESCE(num_post, 0) AS engagement_score
FROM engagement;

-- Approximate the 50th percentile (median)
SELECT engagement_score
FROM view_engagement_score
ORDER BY engagement_score
LIMIT 1 OFFSET 344213; --(688427 / 2)

--conclusion :Learners with engagement_score < 4 are considered to have low engagement, based on median and histogram analysis.



/*
### 2. Performance Logic
Definition: A learner is considered to have low performance if their grade is below 0.5.
statistical tool : median, hypothesis testing ( T-test), boxplot

Justification:
Grade is a continuous value from 0.0 to 1.0
Median grade = 0.0, indicating that at least half of learners did not achieve any measurable success
T-test result: T = -91.51, p < 0.0001 — strongly supports that the grade < 0.5 group differs significantly
The boxplot visually confirms the skew and failure clustering
*/


CREATE view low_performance_users AS
SELECT
    user_id,
    course_id,
    grade
FROM enrollment
where grade is not null;

SELECT grade
FROM low_performance_users
ORDER BY grade
LIMIT 1 OFFSET 319368; -- 638736/2

--result : 0

--Conclusion: Learners with grade < 0.5 are considered to have low performance, supported by median, boxplot, and t-test.


-- Insert users who are both low engagement and low performance
INSERT INTO dropout_flags (user_id, course_id, flagged_on, reason)
SELECT
    e.user_id,
    e.course_id,
    CURDATE() AS flagged_on,
    'Low engagement and low performance' AS reason
FROM view_engagement_score e
JOIN low_performance_users p
  ON e.user_id = p.user_id AND e.course_id = p.course_id
WHERE e.engagement_score < 4
  AND p.grade < 0.5;






