# Campus Connect — Project Architecture & Viva Explanation Guide

This guide explains the technical architecture, design patterns, and workflows of **Campus Connect** in clear, simple language tailored for your **B.Sc.IT Mini Project viva defense**.

---

## 🏛️ 1. Core Concepts Explained Simply

### What is JSP (JavaServer Pages)?
JSP is a server-side technology used to create dynamic web pages using HTML, CSS, JavaScript, and embedded Java code.
- In our project, JSP represents the **VIEW** layer of MVC.
- Example: [`student/my-complaints.jsp`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/web/student/my-complaints.jsp) renders HTML tables populated with data fetched from the database.

### What is a Servlet?
A Servlet is a Java class that runs on a web server (GlassFish) to handle client requests (HTTP GET and POST) and generate responses.
- In our project, Servlets represent the **CONTROLLER** layer.
- Example: [`StudentLoginServlet.java`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/controller/StudentLoginServlet.java) receives the student's roll number and password from the form, calls the DAO, checks credentials, creates a session, and redirects to the dashboard.

### What is JDBC (Java Database Connectivity)?
JDBC is a standard Java API that allows Java applications to interact with relational databases.
- It provides classes like `DriverManager`, `Connection`, `PreparedStatement`, and `ResultSet`.
- In our project, all database queries are executed via JDBC using parameterized `PreparedStatement`.

### What is MySQL?
MySQL is an open-source Relational Database Management System (RDBMS). It stores our application data in structured tables linked by primary and foreign keys.

### What is GlassFish?
GlassFish is an open-source Java EE (Enterprise Edition) application server. It contains:
1. **Servlet Container / Web Container:** Executes Java Servlets and compiles JSPs into bytecode.
2. **JNDI / Connection Pool Management:** Manages threads and network listeners on port 8080.

### What is MVC (Model-View-Controller) Architecture?
MVC is a design pattern that separates application logic into three distinct layers:
1. **Model:** Represents real-world entities (JavaBeans like `Student.java`, `Complaint.java`).
2. **View:** Presentation layer shown in the browser (`.jsp` pages, CSS, HTML).
3. **Controller:** Intermediary layer (`Servlets`) that processes user input, updates data via DAOs, and selects which view to render.

---

## 🔑 2. Database Design & Relational Keys

### Why use Primary Keys?
A **Primary Key** uniquely identifies each row in a table. It prevents duplicate records and speeds up database lookups through automatic indexing.
- In table `students`, `roll_number` is the Primary Key because every college student has a unique roll number.
- In table `complaints`, `complaint_id` (e.g. `CC-2026-00001`) is the Primary Key.

### Why use Foreign Keys?
A **Foreign Key** links a column in one table to the primary key of another table, ensuring **referential integrity**.
- In table `complaints`, `roll_number` is a Foreign Key referencing `students(roll_number)`. This guarantees that a complaint can only be filed by a registered student. If a student is removed, cascading rules maintain database consistency.
- `location_id` references `locations(location_id)`, ensuring complaints always point to valid campus facilities.
- `assigned_staff_id` references `staff(staff_id)`.

---

## 🔄 3. Detailed Technical Workflows

### How Login Works:
1. User enters Roll Number and Password on `login.jsp`.
2. The form submits an HTTP POST request to [`/student-login`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/controller/StudentLoginServlet.java).
3. `StudentLoginServlet` extracts form parameters using `request.getParameter()`.
4. It calls `StudentDAO.authenticate(rollNumber, password)`.
5. `StudentDAO` runs a `PreparedStatement`:
   ```sql
   SELECT * FROM students WHERE roll_number = ?
   ```
6. `PasswordUtil.verifyPassword()` compares the input password against the stored password (using SHA-256 hash comparison).
7. If verified:
   - `request.getSession(true)` creates an `HttpSession`.
   - `session.setAttribute("student", student)` stores the student entity in memory.
   - `response.sendRedirect("student/dashboard.jsp")` redirects to the dashboard.
8. If invalid, the user is redirected back to `login.jsp?error=Invalid+credentials`.

### How Complaint Submission Works:
1. The student navigates to `student/submit-complaint.jsp`.
2. The JSP loads active locations from `LocationDAO.getAllActiveLocations()`.
3. The student fills in the category, chooses the block and specific room, selects the priority, types subject & description, and clicks Submit.
4. An HTTP POST request is sent to [`/complaint`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/controller/ComplaintServlet.java).
5. `ComplaintServlet` reads the active student from the HTTP Session.
6. It validates all inputs server-side.
7. It calls `ComplaintDAO.submitComplaint(complaint)`:
   - `CodeGenerator.generateComplaintId(conn)` queries the database for the highest sequential ID of the current year and generates the next ID: `CC-2026-00001`.
   - A parameterized SQL statement is executed:
     ```sql
     INSERT INTO complaints (complaint_id, roll_number, category, location_id, subject, description, priority, status)
     VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING')
     ```
8. The complaint is saved with initial status `PENDING`.
9. The user is redirected to `student/my-complaints.jsp` with a success message showing the Complaint ID.

### How Admin Updates Complaint Status:
1. Administrator logs in and opens [`admin/complaints.jsp`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/web/admin/complaints.jsp).
2. Admin clicks **Review & Assign** on ticket `CC-2026-00001`.
3. Admin selects a technician from the staff directory (e.g., "Sanjay Kulkarni - AC Department"), changes status to `IN PROGRESS`, types a remark ("Technician dispatched"), and clicks Save.
4. An HTTP POST request is sent to [`/admin/complaint-action`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/controller/AdminComplaintServlet.java).
5. `ComplaintDAO.assignStaff()` updates the database record.
6. When the repair is finished, Admin updates status to `RESOLVED`.
7. `ComplaintDAO.updateStatus()` sets `status = 'RESOLVED'` and automatically records `resolved_at = NOW()`.
8. When the student logs in, the visual 5-step timeline advances to **Resolved**, and the student is invited to submit a 1–5 star satisfaction rating.
