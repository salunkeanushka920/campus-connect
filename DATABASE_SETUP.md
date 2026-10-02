# MySQL Database Setup Guide — Campus Connect

This beginner-friendly guide walks you through importing and verifying the `campus_connect` database in **MySQL Workbench** or MySQL CLI.

---

## 🗄️ Database Details

- **Database Name:** `campus_connect`
- **Host:** `localhost`
- **Port:** `3306`
- **Default User:** `root`
- **Default Password:** `""` (empty) or `"root"`
- **SQL Script File:** [`database/campus_connect.sql`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/database/campus_connect.sql)

---

## 📋 Step-by-Step Instructions (MySQL Workbench)

### Step 1: Open MySQL Workbench & Connect
1. Start **MySQL Workbench** from your Windows Start Menu.
2. Double-click your Local Connection (usually **Local instance MySQL** running on `localhost:3306`).
3. Enter your MySQL root password if prompted.

### Step 2: Open the SQL Script
1. In the top menu, click **File → Open SQL Script...** (or press `Ctrl + Shift + O`).
2. Navigate to:
   ```text
   C:\Users\Anushka\.gemini\antigravity-ide\scratch\CampusConnect\database\campus_connect.sql
   ```
   (or from `Documents\NetBeansProjects\CampusConnect\database\campus_connect.sql`).
3. Click **Open**.

### Step 3: Execute the Script
1. In the query toolbar, click the **Lightning Bolt ⚡** icon (or press `Ctrl + Shift + Enter`) to execute the entire script.
2. Look at the bottom **Action Output** window:
   - Green checkmarks (`✔`) should appear confirming:
     - `CREATE DATABASE IF NOT EXISTS campus_connect`
     - `CREATE TABLE students`
     - `CREATE TABLE admins`
     - `CREATE TABLE locations`
     - `CREATE TABLE staff`
     - `CREATE TABLE complaints`
     - `CREATE TABLE lost_found`
     - `CREATE TABLE feedback`
     - Sample seed records inserted.

### Step 4: Refresh Schemas & Verify Data
1. In the left **Navigator** panel, look under **SCHEMAS**.
2. Click the **Refresh 🔄** icon next to Schemas.
3. You will see `campus_connect` listed.
4. Expand `campus_connect → Tables` and verify all 7 tables exist:
   - `students`
   - `admins`
   - `locations`
   - `staff`
   - `complaints`
   - `lost_found`
   - `feedback`

### Step 5: Test a Verification Query
Open a new SQL tab and run:
```sql
USE campus_connect;

-- View sample complaints
SELECT complaint_id, roll_number, category, subject, priority, status FROM complaints;

-- View registered students
SELECT roll_number, full_name, email, course, year FROM students;
```

---

## 🔧 Database Configuration in Java Code

If your MySQL root password is not empty, you can configure it in:
[`src/java/com/campusconnect/util/DBConnection.java`](file:///C:/Users/Anushka/.gemini/antigravity-ide/scratch/CampusConnect/src/java/com/campusconnect/util/DBConnection.java)

Lines:
```java
private static final String HOST = "localhost";
private static final String PORT = "3306";
private static final String DB_NAME = "campus_connect";
private static final String USERNAME = "root";
private static final String PASSWORD = ""; // Update here if your MySQL password is set
```
*Note: `DBConnection.java` is already programmed with an automatic fallback that checks both empty password `""` and `"root"`, ensuring smooth demo execution.*
