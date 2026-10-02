<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Student" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header -->
    <header class="cc-navbar">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/student/dashboard.jsp" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </header>

    <div class="dashboard-wrapper">

        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-heading">Student Portal</div>
            <ul class="sidebar-nav">
                <li><a href="<%= request.getContextPath() %>/student/dashboard.jsp">📊 Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/student/submit-complaint.jsp">✍️ Submit Complaint</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp">📋 My Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/student/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp?status=RESOLVED">⭐ Give Feedback</a></li>
                <li><a href="<%= request.getContextPath() %>/student/profile.jsp" class="active">👤 My Profile</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="mb-4">
                <h1 class="h3 fw-bold mb-1">Student Profile</h1>
                <p class="text-muted small mb-0">Your registered university credentials and contact information.</p>
            </div>

            <div class="row">
                <div class="col-lg-7">
                    <div class="portal-card">
                        <div class="d-flex align-items-center gap-3 border-bottom pb-4 mb-4">
                            <div class="stat-icon stat-icon-blue" style="width: 64px; height: 64px; font-size: 1.8rem;">
                                🎓
                            </div>
                            <div>
                                <h2 class="h5 fw-bold mb-1"><%= student.getFullName() %></h2>
                                <span class="badge bg-primary font-monospace"><%= student.getRollNumber() %></span>
                                <span class="badge bg-light text-dark border ms-1"><%= student.getYear() %> <%= student.getCourse() %> - Div <%= student.getDivision() %></span>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-sm-6">
                                <label class="small text-muted d-block">Full Name</label>
                                <strong><%= student.getFullName() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <label class="small text-muted d-block">Roll Number (Unique ID)</label>
                                <strong class="font-monospace"><%= student.getRollNumber() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <label class="small text-muted d-block">Email Address</label>
                                <div><%= student.getEmail() %></div>
                            </div>
                            <div class="col-sm-6">
                                <label class="small text-muted d-block">Phone Number</label>
                                <div><%= student.getPhone() %></div>
                            </div>
                            <div class="col-sm-4">
                                <label class="small text-muted d-block">Course Program</label>
                                <div><%= student.getCourse() %></div>
                            </div>
                            <div class="col-sm-4">
                                <label class="small text-muted d-block">Year</label>
                                <div><%= student.getYear() %></div>
                            </div>
                            <div class="col-sm-4">
                                <label class="small text-muted d-block">Division</label>
                                <div>Division <%= student.getDivision() %></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="portal-card bg-light border">
                        <h2 class="h6 fw-bold mb-3">🛡️ Account Security</h2>
                        <p class="small text-muted mb-3">
                            Your password is protected via SHA-256 cryptographic hashing. Passwords are never stored or transmitted in plain text.
                        </p>
                        <div class="p-3 bg-white rounded border small">
                            <strong>Need to change credentials?</strong><br>
                            Please consult the college examination or IT cell with your student ID card.
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
