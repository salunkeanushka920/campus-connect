# Campus Connect — College Complaint, Feedback & Issue Management Portal

**Academic Level:** B.Sc.IT Undergraduate Mini Project  
**Author:** Anushka Ranjan (Roll No: `243-02-A-0007`, SY B.Sc.IT, Div A)  
**Technology Stack:** Java (JDK 8), Jakarta / Java EE Servlets, JSP, JDBC, MySQL, Bootstrap 5, GlassFish Server 4.1, NetBeans 8.0.2

---

## 🎯 1. Project Objective & Purpose

**Campus Connect** is a centralized college intranet portal developed to provide students with a single, transparent web platform where they can report campus maintenance and academic problems (such as malfunctioning air conditioners, flickering projectors, broken benches, electrical faults, washroom cleanliness, or laboratory issues) and track their resolution status in real time.

### Key Goals:
- **Streamlined Issue Reporting:** Avoid physical paper complaint forms or lost verbal requests.
- **Dynamic Campus Locations:** Predefined blocks and room numbers dynamically retrieved from MySQL.
- **5-Stage Visual Timeline:** Students follow complaints through *Submitted → Assigned → In Progress → Resolved → Closed*.
- **Staff Accountability:** College administration can directly assign maintenance departments (Electrical, AC, IT Support, Cleaning) with remarks.
- **Student Satisfaction:** Post-resolution 1–5 star rating and feedback system.
- **Campus Lost & Found:** Central digital bulletin to report and reclaim lost items.

---

## 🛠️ 2. Technology Stack & Software Requirements

| Component | Technology | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **Language** | Java (JDK) | Java SE 8 (`jdk1.8.0_481`) | Core backend business logic |
| **Web Server** | GlassFish Server | 4.1 Open Source Edition | Java EE 7 Application Server |
| **IDE** | Apache NetBeans | 8.0.2 | Development, build, and debugging |
| **Database** | MySQL | 5.7 / 8.0+ | Relational data persistence |
| **Driver** | MySQL Connector/J | `mysql-connector-java-5.1.23-bin.jar` | JDBC Driver |
| **Web API** | Java Servlets & JSP | Servlet 3.1 / JSP 2.3 (`javax.servlet.*`) | Controller & View layers |
| **Frontend** | HTML5, CSS3, JS, Bootstrap | Bootstrap 5.3.3 | Responsive UI & layout |
| **Browser** | Google Chrome | Latest | Client interface |

---

## 🔑 3. Default Demo Credentials

For demonstration, testing, and viva defense:

### 🎓 Student Portal Demo Account
- **Portal:** Student Login
- **Roll Number:** `243-02-A-0007`
- **Password:** `student123`
- *Note:* You can also click the **"Demo: Fill Student Credentials"** button on `login.jsp`.

### 🛡️ Administrator Portal Demo Account
- **Portal:** Admin Login
- **Username:** `admin`
- **Password:** `admin123`
- *Note:* You can also click the **"Demo: Fill Admin Credentials"** button on `login.jsp`.

---

## 📁 4. Project Directory Structure

```text
CampusConnect/
├── nbproject/                     # NetBeans 8.0.2 Project Metadata (project.xml, build-impl.xml)
├── build.xml                      # Standard Ant Build Script (Clean, Compile, Package, Deploy)
├── database/
│   ├── campus_connect.sql         # Complete MySQL schema & initial sample seed data
│   └── DATABASE_SETUP.md          # Step-by-step MySQL Workbench setup guide
├── src/
│   └── java/
│       └── com/campusconnect/
│           ├── model/             # Java Entity Beans (Student, Admin, Complaint, Location, Staff, LostFound, Feedback)
│           ├── dao/               # JDBC Data Access Objects with PreparedStatements (StudentDAO, ComplaintDAO, etc.)
│           ├── controller/        # Java Servlets (Login, Register, Complaint, Admin, Status, Feedback, etc.)
│           ├── filter/            # Authentication & Session Security Filter (AuthFilter.java)
│           └── util/              # Central DBConnection.java, PasswordUtil.java, CodeGenerator.java
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                # Servlet 3.1 deployment descriptor
│   │   ├── glassfish-web.xml      # GlassFish context root (/CampusConnect)
│   │   ├── classes/               # Compiled bytecode (.class files)
│   │   └── lib/                   # MySQL JDBC Connector JAR
│   ├── css/
│   │   ├── bootstrap.min.css      # Bootstrap 5 Framework
│   │   └── style.css              # Custom Clean Modern Design System & Timeline
│   ├── js/
│   │   ├── bootstrap.bundle.min.js
│   │   └── app.js                 # Dynamic block-to-room filter & instant search
│   ├── index.jsp                  # Landing page with hero & portal selector
│   ├── login.jsp                  # Dual login (Student / Admin tabs with demo buttons)
│   ├── register.jsp               # Student registration form with validation
│   ├── student/                   # Student Portal pages (Dashboard, Submit, My Complaints, Details, Lost & Found, Profile)
│   └── admin/                     # Admin Portal pages (Dashboard, Complaints, Locations, Staff, Lost & Found, Feedback)
├── README.md                      # Complete Project Documentation
├── DATABASE_SETUP.md              # MySQL Workbench Guide
├── PROJECT_EXPLANATION.md         # Viva Architecture & Workflow Guide
└── VIVA_QUESTIONS.md              # 30+ Viva Questions & Answers
```

---

## 🚀 5. How to Run the Project

### Step 1: Initialize MySQL Database
1. Open **MySQL Workbench** or your MySQL command line.
2. Open and execute [`database/campus_connect.sql`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/database/campus_connect.sql).
3. Confirm database `campus_connect` is created with tables: `students`, `admins`, `locations`, `staff`, `complaints`, `lost_found`, `feedback`.
4. Detailed screenshots and instructions are in [`DATABASE_SETUP.md`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/database/DATABASE_SETUP.md).

### Step 2: Open & Run in NetBeans 8.0.2
1. Launch **Apache NetBeans 8.0.2**.
2. Go to **File → Open Project**.
3. Navigate to:  
   `C:\Users\Anushka\Documents\NetBeansProjects\CampusConnect`  
   (or `C:\Users\Anushka\.gemini\antigravity-ide\scratch\CampusConnect`).
4. Select the project and click **Open Project**.
5. Under `Tools → Servers`, ensure **GlassFish Server 4.1** is listed.
6. Right-click the `CampusConnect` project → Click **Clean and Build**.
7. Right-click the `CampusConnect` project → Click **Run**.
8. NetBeans will automatically deploy to GlassFish and open Google Chrome at:  
   **`http://localhost:8080/CampusConnect/`**

---

## 🔒 6. Security Features

1. **SQL Injection Prevention:** Every query in all DAO classes uses JDBC `PreparedStatement` with parameterized placeholders (`?`). No raw input concatenation.
2. **Session Security & Role Authorization:** `AuthFilter.java` intercepts all requests to `/student/*` and `/admin/*`. Direct URL access without a valid session is automatically redirected to the login page.
3. **Password Protection:** Built-in standard SHA-256 cryptographic hashing via `PasswordUtil.java` (`java.security.MessageDigest`).
4. **Cache Control Headers:** `AuthFilter` injects HTTP `Cache-Control: no-cache, no-store, must-revalidate` headers to prevent browser back-button access after logout.
