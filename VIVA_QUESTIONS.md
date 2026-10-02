# Campus Connect — 30 Viva Questions & Answers for B.Sc.IT

This document contains 32 frequently asked viva questions and beginner-friendly answers directly mapped to the **Campus Connect** project.

---

### Q1. What is the title and objective of your mini project?
**Answer:** The project is titled **Campus Connect**. Its objective is to provide college students with a centralized web portal to report campus maintenance, electrical, IT, and academic issues, track their resolution status in real time, report lost/found items, and provide feedback after issues are resolved.

### Q2. Which architecture does your project follow?
**Answer:** It follows the **MVC (Model-View-Controller)** architectural pattern:
- **Model:** Java entity classes (`Student.java`, `Complaint.java`, etc.).
- **View:** Dynamic JSP pages formatted with HTML5, CSS3, and Bootstrap 5.
- **Controller:** Java Servlets (`ComplaintServlet.java`, `StudentLoginServlet.java`, etc.) running on GlassFish.

### Q3. What is the difference between a Servlet and a JSP?
**Answer:**
- A **Servlet** is a Java class containing HTML embedded inside Java code, ideal for controlling application logic and request processing.
- A **JSP** is an HTML document containing embedded Java code (using tags or scriptlets), ideal for presentation and user interface design. At runtime, GlassFish compiles JSPs into Servlets.

### Q4. What is the lifecycle of a Servlet?
**Answer:** A Servlet has three main lifecycle stages:
1. `init()`: Called once when the servlet is first loaded into memory.
2. `service()`: Called on every client request; delegates to `doGet()` or `doPost()`.
3. `destroy()`: Called once when the server shuts down or the servlet is unloaded.

### Q5. What is the difference between HTTP GET and POST methods?
**Answer:**
- **GET:** Appends form data to the URL query string (visible in the address bar). It has length limitations and should not be used for sensitive information like passwords.
- **POST:** Transmits form data inside the HTTP request body. It is secure for sensitive data (passwords, complaints) and has no size restrictions.

### Q6. What is JDBC and what are its core interfaces?
**Answer:** JDBC (Java Database Connectivity) is a standard Java API used to connect Java code to relational databases. Its key interfaces include:
1. `DriverManager`: Manages database drivers.
2. `Connection`: Represents an active session with the database.
3. `Statement` / `PreparedStatement`: Executes SQL queries.
4. `ResultSet`: Stores the table rows returned by a `SELECT` query.

### Q7. Why did you use `PreparedStatement` instead of regular `Statement`?
**Answer:**
1. **Security:** `PreparedStatement` prevents **SQL Injection attacks** because user inputs are treated strictly as parameters (`?`), never executable SQL code.
2. **Performance:** It is pre-compiled by the database engine, allowing faster repeated executions.

### Q8. What is SQL Injection and how does Campus Connect prevent it?
**Answer:** SQL Injection is a vulnerability where malicious SQL commands are inserted into input fields to alter database queries. In Campus Connect, **100% of database queries use parameterized `PreparedStatement` placeholders (`?`)**, ensuring user inputs are sanitized automatically.

### Q9. How is the database connection managed in the project?
**Answer:** Through a centralized utility class: [`DBConnection.java`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/util/DBConnection.java). All DAOs call `DBConnection.getConnection()` rather than duplicating connection URLs, credentials, and drivers across servlets.

### Q10. What is a DAO (Data Access Object) pattern?
**Answer:** The DAO pattern isolates database interaction from business logic. In our project:
- `StudentDAO` handles student queries (`registerStudent`, `authenticate`).
- `ComplaintDAO` handles complaint queries (`submitComplaint`, `assignStaff`, `updateStatus`).

### Q11. What is an HttpSession and why is it used?
**Answer:** HTTP is a stateless protocol (it treats each request independently). An `HttpSession` stores user-specific state across multiple web pages. When a student logs in, their `Student` object is stored in the session, allowing subsequent pages to identify the student without requiring them to log in again on every click.

### Q12. How does the application protect student and admin pages from unauthorized access?
**Answer:** Using [`AuthFilter.java`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/filter/AuthFilter.java), which implements `javax.servlet.Filter`.
- When any request hits `/student/*`, it checks if `session.getAttribute("student")` exists. If not, it redirects to `login.jsp`.
- When any request hits `/admin/*`, it checks for `session.getAttribute("admin")`.

### Q13. How does session invalidation (Logout) work?
**Answer:** When the user clicks Logout, `LogoutServlet` calls `session.invalidate()`, clearing all session attributes and destroying the session on the server. `AuthFilter` also sets `Cache-Control: no-cache, no-store` headers so clicking the browser's "Back" button cannot display protected data.

### Q14. How are passwords stored and secured?
**Answer:** Passwords are encrypted using **SHA-256 (Secure Hash Algorithm 256-bit)** via Java's built-in `java.security.MessageDigest`. A plain-text password like `student123` is transformed into a fixed 64-character hexadecimal hash. Plain passwords are never stored in the database.

### Q15. What are the tables in your database and their relationships?
**Answer:**
1. `students`: Stores student profiles (`roll_number` Primary Key).
2. `admins`: Administrator credentials.
3. `locations`: Campus blocks and rooms (`location_id` Primary Key).
4. `staff`: Maintenance personnel (`staff_id` Primary Key).
5. `complaints`: Central tickets (`complaint_id` PK; foreign keys to `students`, `locations`, `staff`).
6. `lost_found`: Lost & found items (`roll_number` FK).
7. `feedback`: Post-resolution reviews (`complaint_id` FK, `roll_number` FK).

### Q16. Why is `roll_number` the Primary Key in the `students` table?
**Answer:** Because every student in a college has a unique, non-null identification number. Making it the primary key enforces uniqueness and ensures no two students can register under the same roll number.

### Q17. What is a Foreign Key and give an example from your project?
**Answer:** A Foreign Key is a field in one table that links to the Primary Key of another table. In our `complaints` table, `roll_number` is a foreign key referencing `students(roll_number)`. This guarantees that every complaint belongs to a valid, registered student.

### Q18. How is the unique Complaint ID generated?
**Answer:** In [`CodeGenerator.java`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/util/CodeGenerator.java), the system queries the highest existing complaint ID for the current year (e.g., `CC-2026-00001`), increments the sequence by 1, and formats it as `CC-YYYY-XXXXX`.

### Q19. What are the 5 stages of the complaint progress timeline?
**Answer:**
1. **Submitted:** Complaint logged by student (Default status: `PENDING`).
2. **Assigned:** Administrator assigns a responsible staff member/department (`ASSIGNED`).
3. **In Progress:** Maintenance technician is actively repairing the issue (`IN PROGRESS`).
4. **Resolved:** Issue fixed and marked completed (`RESOLVED`).
5. **Closed:** Final verification completed (`CLOSED`).

### Q20. Can students view other students' complaints?
**Answer:** No. In `ComplaintDAO.getComplaintsByStudent()`, the SQL query strictly filters:
```sql
WHERE roll_number = ?
```
passing the session's verified `studentRollNumber`. Furthermore, in `complaint-details.jsp`, a security validation ensures that the logged-in student's roll number matches the complaint's student roll number.

### Q21. How does the dynamic location selector work?
**Answer:** The database stores campus blocks (`A Block`, `X Block`, `Y Block`, `Central Block`) and rooms (`A-01`, `Lopez Lab`, `Reading Room`) in the `locations` table. When a student chooses a block, client-side JavaScript (`app.js`) filters the room dropdown dynamically. This makes adding new college classrooms simple without modifying Java code.

### Q22. How does the post-resolution feedback feature work?
**Answer:** Feedback is restricted until the complaint status becomes `RESOLVED` or `CLOSED`. Once resolved, the student can submit a 1 to 5 star rating and comment via `FeedbackServlet`. The rating is stored in the `feedback` table and displayed on the Admin Dashboard to calculate average campus satisfaction.

### Q23. What role does GlassFish play in your project?
**Answer:** GlassFish serves as our Java EE application server. It hosts the compiled `.class` files, parses `web.xml` and `glassfish-web.xml`, listens on port 8080 for incoming HTTP requests, routes requests to the appropriate servlets, manages sessions, and returns HTML responses to Chrome.

### Q24. What is the role of `web.xml`?
**Answer:** `web.xml` is the **Deployment Descriptor**. It defines web application settings such as welcome pages (`index.jsp`), session timeouts (30 minutes), and servlet mappings.

### Q25. What is the role of `glassfish-web.xml`?
**Answer:** It is a GlassFish-specific configuration file that defines the **Context Root** of the application (e.g. `/CampusConnect`), ensuring the web application is accessible at `http://localhost:8080/CampusConnect/`.

### Q26. What happens if MySQL is temporarily offline?
**Answer:** `DBConnection.getConnection()` catches the `SQLException` and logs the technical details to the server console while throwing an informative error, preventing application crashes and showing a clean, user-friendly error message on the web page.

### Q27. What are the key features of the Admin Portal?
**Answer:**
1. View overall statistics (Total, Pending, Assigned, In Progress, Resolved, Closed).
2. Breakdown of complaints by category and campus block.
3. Review complaints, assign staff members, update status, and add remarks.
4. Manage campus locations (blocks and rooms).
5. Manage maintenance staff directory.
6. Moderate lost & found listings.
7. Monitor student satisfaction ratings.

### Q28. How does Lost & Found function in Campus Connect?
**Answer:** Students can report either a `LOST` item or a `FOUND` item with a description, last seen location, date, and contact details. Listings are separated into "Lost Items" and "Found Items" tabs. Administrators can update the item status to `CLAIMED` or `CLOSED` once the owner retrieves it.

### Q29. Which CSS framework was used and how is it integrated?
**Answer:** **Bootstrap 5.3.3** was used for responsive grid layouts, forms, tables, modals, and buttons. It is supplemented by a custom modern CSS design system ([`css/style.css`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/web/css/style.css)) featuring custom cards, status badges, metric cards, and a visual 5-stage progress timeline.

### Q30. How would you deploy this project to another college computer?
**Answer:**
1. Install Java JDK 8, NetBeans 8.0.2, GlassFish 4.1, and MySQL.
2. Run `campus_connect.sql` in MySQL Workbench.
3. Open the `CampusConnect` folder in NetBeans.
4. Click **Run**; NetBeans compiles the code, deploys the WAR to GlassFish, and opens the browser.

### Q31. What is the difference between client-side validation and server-side validation?
**Answer:**
- **Client-side validation:** Written in JavaScript (`app.js`); checks password match and required fields before sending the HTTP request, providing instant feedback.
- **Server-side validation:** Written in Java (`StudentRegisterServlet.java`); re-checks all constraints (email regex, duplicate roll number, string lengths) on the server. Server-side validation cannot be bypassed by disabling JavaScript, ensuring complete database safety.

### Q32. If you had more time, what future enhancements would you add?
**Answer:**
1. SMS / WhatsApp notification alerts when a complaint is assigned or resolved.
2. Direct photo upload for broken equipment.
3. Mobile app companion using Android / Flutter.
4. QR code stickers on classroom desks so students can scan and immediately report issues for that exact room.
