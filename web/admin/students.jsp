<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.Student" %>
<%@ page import="com.campusconnect.dao.StudentDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    StudentDAO studentDAO = new StudentDAO();
    List<Student> students = studentDAO.getAllStudents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registered Students — Admin Console</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header -->
    <header class="cc-navbar bg-dark text-white border-dark">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="cc-brand text-white">
                <span class="cc-brand-badge bg-primary">ADMIN</span>
                <span>Campus Connect</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <div class="dashboard-wrapper">

        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-heading">Admin Console</div>
            <ul class="sidebar-nav">
                <li><a href="<%= request.getContextPath() %>/admin/dashboard.jsp">📊 Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/complaints.jsp">📋 All Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/students.jsp" class="active">🎓 Registered Students</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/locations.jsp">🏫 Campus Locations</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/staff.jsp">🛠️ Staff Directory</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/feedback.jsp">⭐ Student Feedback</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">Registered Students Directory</h1>
                    <p class="text-muted small mb-0">Total of <strong><%= students.size() %></strong> students enrolled in the system.</p>
                </div>
                <div style="max-width: 320px;" class="w-100">
                    <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search by name, roll number, or course...">
                </div>
            </div>

            <div class="portal-card p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table cc-table mb-0" id="filterableTable">
                        <thead>
                            <tr>
                                <th>Roll Number</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Course</th>
                                <th>Year</th>
                                <th>Division</th>
                                <th>Registration Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (students.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">No students registered yet.</td>
                                </tr>
                            <% } else { 
                                for (Student s : students) {
                            %>
                                <tr>
                                    <td class="fw-bold font-monospace text-primary"><%= s.getRollNumber() %></td>
                                    <td class="fw-semibold"><%= s.getFullName() %></td>
                                    <td><%= s.getEmail() %></td>
                                    <td><%= s.getPhone() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= s.getCourse() %></span></td>
                                    <td><%= s.getYear() %></td>
                                    <td>Div <%= s.getDivision() %></td>
                                    <td><%= s.getCreatedAt() != null ? s.getCreatedAt().toString().substring(0, 16) : "" %></td>
                                </tr>
                            <%  } 
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
