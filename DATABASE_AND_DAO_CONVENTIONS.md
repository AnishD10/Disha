# DATABASE AND DAO CONVENTIONS - DISHA Project

This document defines team standards for database operations, DAO patterns, and JDBC usage.
ALL team members must follow these conventions to avoid bugs, merge conflicts, and performance issues.

1. # DATABASE NAMING CONVENTIONS

Table Names:

- All lowercase
- Use underscores for multi-word names
- Singular or plural (be consistent - we use PLURAL)
- Examples: users, student_profiles, career_matches, assessment_responses

Column Names:

- All lowercase
- Use underscores for multi-word names
- Primary key: id or [entity]\_id (e.g., user_id, career_id)
- Foreign key: [related_entity]\_id (e.g., student_user_id, career_id)
- Timestamp columns: created_at, updated_at
- Boolean columns: is_active, is_verified, is_at_risk
- Examples: user_id, first_name, academic_score, is_active, created_at

Primary Keys:

- Always: INT AUTO_INCREMENT PRIMARY KEY
- Name format: [entity]\_id (user_id, assessment_id, college_id)
- Never use composite primary keys unless absolutely necessary

Foreign Keys:

- Always use explicit CONSTRAINT FK*[source]*[target]
- Example: CONSTRAINT fk_student_user FOREIGN KEY (user_id) REFERENCES users(user_id)
- Always use ON DELETE CASCADE or ON DELETE RESTRICT as appropriate
- Use ON UPDATE CASCADE when applicable

Indexes:

- Always index foreign keys
- Always index frequently searched columns (role, email, status)
- Always index timestamp columns used in filtering
- Name format: idx\_[column_name]
- Example: INDEX idx_user_id (user_id), INDEX idx_created_at (created_at)

Enums:

- Use MySQL ENUM for fields with fixed set of values
- Examples: role ENUM('STUDENT', 'PARENT', 'COUNSELOR', 'ADMIN')
- Always uppercase enum values
- Never hardcode enum strings in code - use Constants.java

2. # CONNECTION HANDLING RULES

Golden Rule: ALWAYS close connections after use. No exceptions.

Using DBUtil.getConnection():
Connection conn = null;
try {
conn = DBUtil.getConnection();
// Your database code
} catch (SQLException e) {
// Handle error
} finally {
DBUtil.closeConnection(conn);
}

NEVER:

- Write DriverManager.getConnection() directly in DAO or Servlet
- Forget to close connections in finally block
- Close the connection outside the DAO that opened it
- Create multiple connections for a single operation
- Use connection pooling without Anish's approval

Connection Lifetime:

- Open just before use
- Close immediately after done
- Never pass Connection as parameter between methods
- Each method that needs database access gets its own connection

3. # DAO PATTERNS & USAGE RULES

Every DAO must:

1. Extend BaseDAO.java
2. Have a no-arg constructor
3. Use PreparedStatement only (never raw SQL strings)
4. Bind all parameters safely using setParameters()
5. Handle exceptions explicitly
6. Close all resources in finally blocks

DAO Naming:

- Format: [Entity]DAO.java
- Examples: UserDAO.java, CareerDAO.java, AssessmentDAO.java
- Always in src/dao/ folder
- One DAO per table (mostly)

DAO Method Naming:

- CRUD methods: add[Entity](), get[Entity]ById(), update[Entity](), delete[Entity]()
- Search methods: get[Entity]By[Column](), get[Entity]List[Qualifier]()
- Count methods: count[Entity]ByStatus()
- Examples:
  - addUser(User user)
  - getUserById(int userId)
  - getCareersByDemand(String demand)
  - updateStudentProfile(StudentProfile profile)
  - deleteAssessment(int assessmentId)

DAO Code Template:

public class UserDAO extends BaseDAO {

       public User getUserById(int userId) throws SQLException {
           String sql = "SELECT * FROM users WHERE user_id = ?";
           ResultSet rs = null;
           User user = null;
           try {
               rs = executeQuery(sql, userId);
               if (rs.next()) {
                   user = new User();
                   user.setUserId(rs.getInt("user_id"));
                   user.setUsername(rs.getString("username"));
                   user.setEmail(rs.getString("email"));
               }
           } catch (SQLException e) {
               logError("Error fetching user by ID: " + userId, e);
               throw e;
           } finally {
               closeResultSet(rs);
           }
           return user;
       }

       public void insertUser(User user) throws SQLException {
           String sql = "INSERT INTO users (username, email, password_hash, role, created_at) VALUES (?, ?, ?, ?, NOW())";
           try {
               executeUpdate(sql, user.getUsername(), user.getEmail(), user.getPasswordHash(), user.getRole());
           } catch (SQLException e) {
               logError("Error inserting user: " + user.getUsername(), e);
               throw e;
           }
       }

       public void updateUser(User user) throws SQLException {
           String sql = "UPDATE users SET username = ?, email = ?, first_name = ?, updated_at = NOW() WHERE user_id = ?";
           try {
               executeUpdate(sql, user.getUsername(), user.getEmail(), user.getFirstName(), user.getUserId());
           } catch (SQLException e) {
               logError("Error updating user ID: " + user.getUserId(), e);
               throw e;
           }
       }

       public void deleteUser(int userId) throws SQLException {
           String sql = "DELETE FROM users WHERE user_id = ?";
           try {
               executeUpdate(sql, userId);
           } catch (SQLException e) {
               logError("Error deleting user ID: " + userId, e);
               throw e;
           }
       }

}

4. # JDBC BEST PRACTICES

Always Use PreparedStatement:
GOOD: String sql = "SELECT \* FROM users WHERE email = ?";
ps = conn.prepareStatement(sql);
ps.setString(1, email);

BAD: String sql = "SELECT \* FROM users WHERE email = '" + email + "'";
// SQL injection vulnerability!

Parameter Binding Order:

- First ? is index 1 (not 0)
- Index increments left to right
- Example: "SELECT \* FROM users WHERE role = ? AND is_active = ?"
  ps.setString(1, role); // First ?
  ps.setBoolean(2, true); // Second ?

Result Set Iteration:
while (rs.next()) {
int id = rs.getInt("column_name");
String name = rs.getString("column_name");
boolean active = rs.getBoolean("column_name");
}

Data Type Mapping:
MySQL → Java
INT → int or Integer
VARCHAR → String
DECIMAL → BigDecimal (for money)
BOOLEAN → boolean
TIMESTAMP → java.sql.Timestamp
DATE → java.sql.Date
DATETIME → java.sql.Timestamp
TEXT → String
ENUM → String

Error Handling:

- Always catch SQLException
- Always log with meaningful messages
- Always re-throw or handle appropriately
- Never silently ignore exceptions

5. # COMMON DAO QUERIES

Select by ID (Single Row):
String sql = "SELECT \* FROM users WHERE user_id = ?";
ResultSet rs = executeQuery(sql, userId);

Select Multiple with WHERE:
String sql = "SELECT \* FROM careers WHERE market_demand = ? ORDER BY career_name";
ResultSet rs = executeQuery(sql, demand);
List<Career> careers = new ArrayList<>();
while (rs.next()) {
Career career = new Career();
// ... map fields
careers.add(career);
}
closeResultSet(rs);

Insert New Record:
String sql = "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)";
executeUpdate(sql, user.getUsername(), user.getEmail(), user.getPasswordHash(), user.getRole());

Update Record:
String sql = "UPDATE users SET email = ?, first_name = ?, updated_at = NOW() WHERE user_id = ?";
executeUpdate(sql, user.getEmail(), user.getFirstName(), user.getUserId());

Delete Record:
String sql = "DELETE FROM users WHERE user_id = ?";
executeUpdate(sql, userId);

Count Records:
String sql = "SELECT COUNT(\*) as count FROM student_assessments WHERE student_user_id = ?";
ResultSet rs = executeQuery(sql, studentId);
if (rs.next()) {
int count = rs.getInt("count");
}
closeResultSet(rs);

6. # SERVLET TO DAO FLOW

Servlets should:

1. Get request parameters
2. Validate inputs using ValidationUtil
3. Create DAO instance
4. Call DAO methods
5. Handle exceptions
6. Forward/redirect with result

Example Servlet Code:
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

           String username = request.getParameter("username");
           String email = request.getParameter("email");
           String password = request.getParameter("password");

           // Validate
           if (!ValidationUtil.isValidEmail(email)) {
               request.setAttribute("error", "Invalid email");
               request.getRequestDispatcher("/register.jsp").forward(request, response);
               return;
           }

           try {
               // Create DAO and call method
               UserDAO userDAO = new UserDAO();
               String passwordHash = EncryptionUtil.hashPassword(password);

               User newUser = new User();
               newUser.setUsername(username);
               newUser.setEmail(email);
               newUser.setPasswordHash(passwordHash);
               newUser.setRole("STUDENT");

               userDAO.insertUser(newUser);

               response.sendRedirect("/login.jsp?success=registered");
           } catch (SQLException e) {
               request.setAttribute("error", "Registration failed");
               request.getRequestDispatcher("/register.jsp").forward(request, response);
           }
       }

}

7. # SERVICE LAYER (OPTIONAL BUT RECOMMENDED)

Services encapsulate business logic between Servlets and DAOs.

Example Service Code:
public class AuthenticationService {
private UserDAO userDAO = new UserDAO();

       public User authenticate(String username, String password) throws SQLException, AuthenticationException {
           User user = userDAO.getUserByUsername(username);

           if (user == null) {
               throw new AuthenticationException("User not found");
           }

           if (!EncryptionUtil.verifyPassword(password, user.getPasswordHash())) {
               throw new AuthenticationException("Invalid password");
           }

           return user;
       }

}

When to use Services:

- Business logic that affects multiple DAOs
- Complex calculations or validations
- Re-used logic across multiple Servlets
- Example: CareerMatchingService for aptitude-to-career matching

8. # TRANSACTIONS (Advanced - Anish Only for Now)

If a single operation requires multiple DAO calls that must all succeed or all fail:

Connection conn = null;
try {
conn = DBUtil.getConnection();
conn.setAutoCommit(false);

       // Multiple operations
       userDAO.insertUserWithConnection(user, conn);
       profileDAO.insertProfileWithConnection(profile, conn);

       conn.commit();

} catch (SQLException e) {
conn.rollback();
throw e;
} finally {
conn.setAutoCommit(true);
DBUtil.closeConnection(conn);
}

RULE: Do NOT use transactions without Anish's approval.

9. # CONSTANTS & ENUM VALUES

Never hardcode strings for roles, statuses, etc.
Use Constants.java instead.

Example Constants.java:
public class Constants {
// User Roles
public static final String ROLE_STUDENT = "STUDENT";
public static final String ROLE_PARENT = "PARENT";
public static final String ROLE_COUNSELOR = "COUNSELOR";
public static final String ROLE_ADMIN = "ADMIN";

       // Assessment Status
       public static final String STATUS_PENDING = "PENDING";
       public static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
       public static final String STATUS_COMPLETED = "COMPLETED";

       // Career Demand
       public static final String DEMAND_LOW = "LOW";
       public static final String DEMAND_MEDIUM = "MEDIUM";
       public static final String DEMAND_HIGH = "HIGH";

}

Usage in Code:
user.setRole(Constants.ROLE_STUDENT);
assessment.setStatus(Constants.STATUS_PENDING);

10. # TESTING & DEBUGGING

Before committing DAO code:

1. Test all CRUD operations locally
2. Verify SQL queries in MySQL Workbench first
3. Check for null pointer exceptions
4. Verify resource cleanup (connections/result sets)
5. Test with sample data from database

Debug Checklist:

- Is connection closing properly?
- Is SQL syntax correct?
- Are all parameters bound?
- Is parameter order correct?
- Are column names spelled correctly?
- Are data types correct?
- Is exception handling in place?

11. # REVIEW CHECKLIST (Before Pull Request)

Before submitting a PR with DAO changes:

□ All methods extend BaseDAO and use its helper methods
□ No raw DriverManager.getConnection() calls
□ All connections closed in finally blocks
□ All ResultSets closed in finally blocks
□ All PreparedStatements use parameter binding (no string concatenation)
□ Exception handling is explicit (not silent)
□ Methods are named correctly (add, get, update, delete, etc.)
□ Logging is meaningful
□ No hardcoded role/status strings (use Constants.java)
□ SQL queries tested in MySQL Workbench
□ Team naming conventions followed throughout
□ Code is clean and readable (no debugging output left)

12. # TEAM CONTACT FOR DATABASE ISSUES

Contact Anish for:

- Schema changes
- New table creation
- Database connection issues
- DBUtil configuration
- Complex queries / joins
- Performance optimization
- Migration scripts
- Data backup/recovery

Contact Respective DAO Owner for:

- Single DAO bugs
- Method signature changes
- Business logic in DAO

FINAL RULE: When in doubt, ASK. Better to ask than to break the database.
