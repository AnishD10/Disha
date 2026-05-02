# DISHA Project - Folder Structure

Disha - Nepal Career Intelligence Portal/
│
├── src/
│ ├── controllers/
│ │ ├── UserServlet.java
│ │ ├── AssessmentServlet.java
│ │ ├── CareerServlet.java
│ │ ├── AdminServlet.java
│ │ ├── CounselorServlet.java
│ │ ├── DecisionServlet.java
│ │ └── ParentServlet.java
│ │
│ ├── dao/
│ │ ├── BaseDAO.java
│ │ ├── UserDAO.java
│ │ ├── StudentProfileDAO.java
│ │ ├── AssessmentDAO.java
│ │ ├── QuestionDAO.java
│ │ ├── StudentAnswerDAO.java
│ │ ├── AptitudeProfileDAO.java
│ │ ├── CareerDAO.java
│ │ ├── CollegeDAO.java
│ │ ├── DegreeDAO.java
│ │ ├── DecisionPlanDAO.java
│ │ ├── CounselorDAO.java
│ │ ├── AdminDAO.java
│ │ └── LabourMarketDataDAO.java
│ │
│ ├── models/
│ │ ├── User.java
│ │ ├── StudentProfile.java
│ │ ├── Assessment.java
│ │ ├── Question.java
│ │ ├── AptitudeProfile.java
│ │ ├── Career.java
│ │ ├── College.java
│ │ ├── Degree.java
│ │ ├── DecisionPlan.java
│ │ ├── CounselorAssignment.java
│ │ ├── ParentDashboard.java
│ │ ├── PersonalDashboard.java
│ │ └── AdminDashboard.java
│ │
│ ├── services/
│ │ ├── UserService.java
│ │ ├── AuthenticationService.java
│ │ ├── AssessmentService.java
│ │ ├── CareerMatchingService.java
│ │ ├── DecisionPlanningService.java
│ │ ├── CounselorService.java
│ │ ├── AdminService.java
│ │ └── ReportService.java
│ │
│ ├── utils/
│ │ ├── DBUtil.java
│ │ ├── Constants.java
│ │ ├── ValidationUtil.java
│ │ ├── EncryptionUtil.java
│ │ ├── DateUtil.java
│ │ └── EmailUtil.java
│ │
│ ├── middlewares/
│ │ ├── AuthenticationFilter.java
│ │ ├── AuthorizationFilter.java
│ │ ├── SessionFilter.java
│ │ ├── LoggingFilter.java
│ │ └── ExceptionHandler.java
│ │
│ └── view/
│ └── Main.java
│
├── WebContent/
│ ├── index.jsp
│ ├── login.jsp
│ ├── register.jsp
│ │
│ ├── CSS/
│ │ ├── style.css
│ │ ├── navbar.css
│ │ ├── dashboard.css
│ │ ├── assessment.css
│ │ ├── career.css
│ │ ├── admin.css
│ │ └── responsive.css
│ │
│ ├── JS/
│ │ ├── formValidation.js
│ │ ├── assessment.js
│ │ ├── career-filter.js
│ │ ├── dashboard.js
│ │ ├── admin.js
│ │ └── utils.js
│ │
│ ├── JSP/
│ │ ├── home.jsp
│ │ ├── navbar.jsp
│ │ ├── footer.jsp
│ │ │
│ │ ├── auth/
│ │ │ ├── login.jsp
│ │ │ └── register.jsp
│ │ │
│ │ ├── student/
│ │ │ ├── dashboard.jsp
│ │ │ ├── assessment.jsp
│ │ │ ├── results.jsp
│ │ │ └── career-matches.jsp
│ │ │
│ │ ├── parent/
│ │ │ ├── dashboard.jsp
│ │ │ ├── child-progress.jsp
│ │ │ └── career-advice.jsp
│ │ │
│ │ ├── counselor/
│ │ │ ├── dashboard.jsp
│ │ │ ├── student-management.jsp
│ │ │ ├── reports.jsp
│ │ │ └── bulk-assign.jsp
│ │ │
│ │ ├── admin/
│ │ │ ├── dashboard.jsp
│ │ │ ├── user-management.jsp
│ │ │ ├── career-management.jsp
│ │ │ ├── college-management.jsp
│ │ │ └── market-data.jsp
│ │ │
│ │ └── decision/
│ │ ├── planner.jsp
│ │ ├── degree-filter.jsp
│ │ └── results.jsp
│ │
│ └── images/
│ ├── logo.png
│ ├── icons/
│ └── banners/
│
├── WEB-INF/
│ ├── web.xml
│ └── lib/
│ ├── mysql-connector-java-8.x.x.jar
│ └── [other dependencies]
│
├── database/
│ ├── schema.sql
│ ├── sample-data.sql
│ └── relationships.sql
│
├── scripts/
│ ├── setup-db.sql
│ ├── extract_pdf.py
│ └── test-data-generator.py
│
├── lib/
│ └── [External libraries]
│
├── Disha - Nepal Career Intelligence Portal.iml
└── README.md

# FOLDER STRUCTURE EXPLANATION

1. SRC/ (Source Code)

   a) CONTROLLERS/
   - Servlets that handle HTTP requests
   - Each Servlet manages one feature (UserServlet, AssessmentServlet, etc.)
   - Team: Biraj, Joyal, Ashmit, Anish (feature owners)

   b) DAO/
   - Data Access Objects for database operations
   - One DAO per table or entity
   - Extend BaseDAO.java
   - Team: All developers use this layer

   c) MODELS/
   - Plain Java Objects (POJOs) representing database entities
   - Getters, setters, constructors only
   - One class per table
   - Team: All developers

   d) SERVICES/
   - Business logic layer
   - Called by Servlets, call DAOs
   - Implement complex queries and calculations
   - Team: All developers

   e) UTILS/
   - Utility classes used throughout the project
   - DBUtil.java (connection management)
   - ValidationUtil.java (input validation)
   - EncryptionUtil.java (password hashing)
   - Constants.java (global constants)
   - Team: Anish (owner)

   f) MIDDLEWARES/
   - Filters for authentication, logging, exception handling
   - AuthenticationFilter.java (session validation)
   - Team: Joyal (auth), Anish (coordination)

   g) VIEW/
   - Main.java entry point if needed
   - Team: Reference only

2. WEBCONTENT/

   a) CSS/
   - Stylesheets for all pages
   - Organized by feature (navbar, dashboard, etc.)
   - Team: Biraj (owner)

   b) JS/
   - Client-side JavaScript for validation and interactivity
   - Organized by feature
   - Team: Biraj (owner)

   c) JSP/
   - Java Server Pages for dynamic content
   - Organized by feature (auth/, student/, parent/, etc.)
   - Each role has its own folder
   - Team:
     - Biraj: home.jsp, navbar, footer, admin JSPs, career JSPs
     - Joyal: login, register, decision planning JSPs
     - Ashmit: assessment JSPs (support)
     - Prakriti: parent dashboard JSP (support)
     - Supriya: personal dashboard JSP (support)

   d) IMAGES/
   - Logo, icons, banners
   - Organized in subfolders
   - Team: Biraj

3. WEB-INF/
   - Deployment configuration
   - mysql-connector JAR
   - Team: Anish (setup)

4. DATABASE/
   - schema.sql (all CREATE TABLE statements)
   - sample-data.sql (INSERT statements)
   - relationships.sql (FK constraints)
   - Team: Anish

5. SCRIPTS/
   - Utility scripts for setup and testing
   - PDF extraction, test data generation
   - Team: Various

6. LIB/
   - External JAR libraries
   - Team: Anish (dependency management)

# NAMING CONVENTIONS

Classes:

- Servlets: [Feature]Servlet.java (UserServlet, AssessmentServlet)
- DAOs: [Entity]DAO.java (UserDAO, CareerDAO)
- Models: [Entity].java (User, Career)
- Services: [Feature]Service.java (AuthenticationService, CareerMatchingService)
- Utilities: [Purpose]Util.java (ValidationUtil, EncryptionUtil)
- Filters: [Purpose]Filter.java (AuthenticationFilter, LoggingFilter)

JSP Pages:

- [feature-name].jsp (dashboard.jsp, assessment.jsp)
- Use lowercase with hyphens for multi-word names
- Group by role in subdirectories

Database:

- Table names: lowercase with underscores (user_profiles, career_matches)
- Column names: lowercase with underscores (user_id, created_at)

Methods:

- Camel case: getUsername(), setPassword(), executeQuery()

Variables:

- Camel case, descriptive names: userName, isActive, assessmentScore

# TEAM RESPONSIBILITIES & FOLDER OWNERSHIP

Anish (DB Architect):

- src/utils/ (DBUtil, Constants)
- database/ (all schema and setup)
- src/dao/ (coordination and review)
- src/middlewares/ (session management)

Joyal (Auth Lead):

- src/controllers/UserServlet.java
- src/services/AuthenticationService.java
- WebContent/JSP/auth/
- src/controllers/DecisionServlet.java (Sprint 2+)
- WebContent/JSP/decision/

Biraj (Frontend Lead):

- src/controllers/AdminServlet.java (partial)
- src/controllers/CareerServlet.java (UI support)
- WebContent/CSS/ (all)
- WebContent/JS/ (all)
- WebContent/JSP/home.jsp, navbar, footer
- WebContent/JSP/admin/
- WebContent/JSP/career/
- WebContent/images/

Ashmit (Feature Developer):

- src/controllers/AssessmentServlet.java
- src/controllers/CounselorServlet.java
- src/dao/AssessmentDAO.java and related
- src/services/AssessmentService.java
- WebContent/JSP/assessment/ (support)

Prakriti (Parent Dashboard):

- src/controllers/ParentServlet.java (partial)
- src/dao/related to parent views
- WebContent/JSP/parent/

Supriya (Personal Dashboard):

- src/controllers/StudentServlet.java (partial)
- src/dao/related to personal views
- WebContent/JSP/student/personal-dashboard.jsp

# GIT BRANCH STRATEGY (RECOMMENDED)

Feature branches per sprint:

- feature/sprint1-auth (Joyal)
- feature/sprint1-ui (Biraj)
- feature/sprint2-assessment (Ashmit)
- feature/sprint2-career (Anish)
- feature/sprint2-decision (Joyal)

Never merge directly to main. Always create Pull Request and have Anish review.

# KEY RULES FOR TEAM COORDINATION

1. No editing files outside your assigned folder without approval
2. All database changes go through Anish
3. Shared JSP files (navbar, footer) require both Biraj and Joyal approval
4. Pull requests reviewed before merge
5. DBUtil and BaseDAO are read-only for team members
6. All new dependencies added to WEB-INF/lib must be approved by Anish
7. Commit messages should include feature name and issue/task ID
8. Daily git pull before starting work to avoid conflicts
