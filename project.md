# Design Document

## Project Title
**DropWatch: Reducing Dropouts in Online Learning Platforms**

## Author Info
**Cedric Tay**
GitHub: [cedrictay](https://github.com/cedrictay)
City: Singapore
Date: 22 June 2025

## Purpose

Online learning platforms frequently experience high dropout rates, often without clear indicators of early disengagement. This project aims to identify patterns in learner behavior—such as reduced engagement, low grades, or extended inactivity—that correlate with attrition. By analyzing quiz scores, engagement metrics, and activity logs, DropWatch seeks to enable platforms to proactively support at-risk students before they disengage.

## Scope

- **Capture user profiles and learning histories**
- **Track platform logins, quiz attempts, and video progress**
- **Classify users at risk of dropping out based on inactivity and performance**
- **Generate actionable analytics for instructors and platform designers**
- **Support manual or automated flagging for intervention purposes**
- **Notify users via flag-based motivation triggers**

## Functional Requirements

- Retrieve a list of users at risk of dropping out based on defined criteria
- View average quiz scores and engagement levels per course
- Identify the most and least engaging courses by user activity metrics
- Generate trend reports on dropout patterns across time, courses, and countries
- Flag users manually or through automated rules for follow-up
- Display results in a dashboard for decision-making and monitoring

## Out of Scope

- Real-time alerts or push notifications
- Machine learning-based predictive models
- Natural language processing of qualitative data
- Secure authentication or full dashboard frontend/backend

## Data Model

### Entities

- **users**: Basic learner info (`user_id`, `gender`, `birth_year`, `education_level`, `country`)
- **courses**: Course info (`course_id`, `title`)
- **enrollments**: Course status (`start_time`, `last_event`, `registered`, `viewed`, `grade`, etc.)
- **engagement**: Activity metrics (`nevents`, `ndays_act`, `nchapters`, `nforum_posts`)
- **dropout_flags**: Risk tagging (`user_id`, `course_id`, `flagged_on`, `reason`)

### Relationships

- One user ↔ many courses via `enrollments`
- One course ↔ many users via `enrollments`
- Each `engagement` and `dropout_flag` links to a unique `user-course` pair

## Design Choices

- Normalized data to separate users, courses, engagements, and flags
- Modular schema allows scalable analytics
- Built for SQL-only analysis without frontend/backend dependencies

## Optimization Techniques

- Indexes on `user_id` in `enrollments`, `engagement`, and `dropout_flags`
- Views created for high-risk user summaries and course-level insights
- Composite keys and filtered queries for performance

## Limitations

- Kaggle dataset is static and anonymized
- No real-time tracking or adaptive interventions
- No text-based feedback or ML models

## Sample Query Use Cases

- Users with 0 forum posts and no certification
- Dropout rates by country or education level
- Average grade vs. number of chapters completed
- High-risk users with low grade and low engagement

---


## Project Impact

### Micro-Level (User-Specific)

- Spot high-risk learners early
- Prompt dashboard nudges for motivation
- Enable instructors to follow up individually

### Macro-Level (Systemic)

- Detect weak points in course design or content
- Adjust course delivery by regional trends
- Support institutional planning and reporting

---


things to do
run insights queries and create view
dashboard


