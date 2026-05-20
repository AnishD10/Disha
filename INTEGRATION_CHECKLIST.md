# Career Module Integration Checklist

This module now works locally with Tomcat 9 and MySQL. Before merging into the shared development branch, use this checklist.

## 1. Login/session

`WebContent/jsp/auth/dev-student-login.jsp` is local-test-only. It bypasses real authentication by setting:

```text
role=STUDENT
studentId=15
userId=15
```

Do not use it as the integrated login path.

When the real login module is available, confirm it sets at least:

```text
role=STUDENT
studentId=<logged-in student user id>
```

`CareerServlet` also accepts `userId`, `student_id`, `loggedInUser.getUserId()`, and `loggedInUser.getId()` as fallback sources.

## 2. Database migration

For local reset testing, `database/career_discovery_module.sql` is fine.

For shared integration, do not run `database/career_discovery_module.sql` without review because it drops and recreates career tables.

Use this safer migration candidate instead:

```text
database/integration_career_migration.sql
```

Before running it on the shared database, confirm whether these tables already exist and whether other modules own them:

```text
careers
aptitude_profiles
career_match_rules
career_skills
career_roadmaps
career_courses
saved_careers
```

If `careers` or `aptitude_profiles` already exist with different columns, pause and decide whether to extend those shared tables or refactor `CareerDAO`.

## 3. Required Tomcat version

Use Tomcat 9 because this code uses:

```java
javax.servlet.*
```

Tomcat 10 uses `jakarta.servlet.*` and is not compatible without source changes.

## 4. Smoke test after integration

Test as a real student user:

```text
/career
/career?action=details&careerId=1
POST /career action=bookmark
/career?action=saved
/career?action=compare&careerId=1&careerId=2
/career?action=retake
POST /career action=saveScores
```

Expected result: recommendations, details, save, saved list, compare, and score retake all work without using the dev login page.
