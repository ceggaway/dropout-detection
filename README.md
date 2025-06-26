# DropWatch: Detecting and Reducing Dropouts in Online Learning Platforms

## Author
**Cedric Tay**  
GitHub: [ceggaway](https://github.com/ceggaway)  
Date: 26 June 2025  
Location: Singapore

---

##  Overview

DropWatch is an SQL-based data project designed to help online learning platforms proactively identify learners at risk of dropping out. By analyzing behavioral and performance metrics such as forum participation, chapter completion, and final grades, the system flags users likely to disengage, enabling early intervention.

---

## Objectives

- Identify statistically significant indicators of dropout behavior
- Generate composite engagement and performance scores
- Flag at-risk learners using rule-based thresholds
- Provide insight into course-level dropout trends and patterns

---

## Features

- **Composite Engagement Scoring**  
  Sum of forum posts, events, video views, and chapter completions  
  (Threshold: engagement score < 4)

- **Performance Classification**  
  Based on final grade  
  (Threshold: grade < 0.5)

- **Flagging At-Risk Learners**  
  Students who meet both criteria are inserted into a `dropout_flags` table for follow-up.

- **Statistical Justification**  
  - Pearson correlation: r = 0.71 between engagement and grade  
  - Median analysis, histograms, t-tests, and boxplots were used to define thresholds

---

## Data Model

| Table            | Description |
|------------------|-------------|
| `users`          | Demographics (user_id, gender, yob, country, education) |
| `courses`        | Course metadata |
| `enrollment`     | Grade and certification outcomes |
| `engagement`     | Activity logs (posts, views, chapters, etc.) |
| `dropout_flags`  | Flagged at-risk users with reason and date |

---

## Project Files

| File                | Description |
|---------------------|-------------|
| `schema.sql`        | SQL code to create all database tables |
| `queries.sql`       | Analysis queries (views, flag logic, summaries) |
| `project.md`        | Design rationale and EDA notes |
| `Courses.csv`       | Sample dataset |
| `ER diagram.png`    | Entity-Relationship diagram |
| `visual.png`        | Sample visualizations or dashboards |

---

## Example Use Cases

- Identify students who posted 0 times and failed to certify
- Compare average grades between active vs inactive users
- Track dropout patterns across different countries or education levels

---

## Limitations

- Static, anonymized dataset (from Kaggle)
- No real-time feedback or notifications
- No ML-based predictive models (pure SQL logic)

---

