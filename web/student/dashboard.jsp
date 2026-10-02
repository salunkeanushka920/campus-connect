<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Student" %>
<%@ page import="com.campusconnect.model.Complaint" %>
<%@ page import="com.campusconnect.dao.ComplaintDAO" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in.");
        return;
    }

    ComplaintDAO complaintDAO = new ComplaintDAO();
    Map<String, Integer> stats = complaintDAO.getStudentStats(student.getRollNumber());
    List<Complaint> recentList = complaintDAO.getComplaintsByStudent(student.getRollNumber(), "ALL", "ALL");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Top Navigation Header -->
    <header class="cc-navbar">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/student/dashboard.jsp" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-sm-block">
                    <div class="fw-bold small"><%= student.getFullName() %></div>
                    <div class="text-muted" style="font-size: 0.75rem;"><%= student.getRollNumber() %> &bull; <%= student.getCourse() %></div>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <div class="dashboard-wrapper">

        <!-- Student Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-heading">Student Portal</div>
            <ul class="sidebar-nav">
                <li><a href="<%= request.getContextPath() %>/student/dashboard.jsp" class="active">📊 Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/student/submit-complaint.jsp">✍️ Submit Complaint</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp">📋 My Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/student/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp?filter=resolved">⭐ Give Feedback</a></li>
                <li><a href="<%= request.getContextPath() %>/student/profile.jsp">👤 My Profile</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            
            <!-- Welcome Banner -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">Welcome, <%= student.getFullName() %></h1>
                    <p class="text-muted small mb-0">Roll Number: <strong><%= student.getRollNumber() %></strong> | Class: <%= student.getYear() %> <%= student.getCourse() %> - Div <%= student.getDivision() %></p>
                </div>
                <a href="<%= request.getContextPath() %>/student/submit-complaint.jsp" class="btn btn-primary">
                    + Submit New Complaint
                </a>
            </div>

            <!-- 4 Small Statistics Counters -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value"><%= stats.get("total") %></div>
                            <div class="stat-label">Total Complaints</div>
                        </div>
                        <div class="stat-icon stat-icon-blue">📁</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-warning"><%= stats.get("pending") %></div>
                            <div class="stat-label">Pending Review</div>
                        </div>
                        <div class="stat-icon stat-icon-amber">⏳</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-info"><%= stats.get("inProgress") %></div>
                            <div class="stat-label">In Progress</div>
                        </div>
                        <div class="stat-icon stat-icon-purple">🔧</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-success"><%= stats.get("resolved") %></div>
                            <div class="stat-label">Resolved</div>
                        </div>
                        <div class="stat-icon stat-icon-green">✅</div>
                    </div>
                </div>
            </div>

            <!-- Quick Action Cards Grid -->
            <h2 class="h5 fw-bold mb-3">Quick Actions</h2>
            <div class="row g-3 mb-4">
                <div class="col-md-6 col-lg-3">
                    <a href="<%= request.getContextPath() %>/student/submit-complaint.jsp" class="text-decoration-none">
                        <div class="portal-card p-3 text-center h-100">
                            <div class="fs-1 mb-2">✍️</div>
                            <h3 class="h6 fw-bold text-dark mb-1">Submit Complaint</h3>
                            <p class="text-muted small mb-0">Report AC, lab, projector, fan or cleanliness issues</p>
                        </div>
                    </a>
                </div>
                <div class="col-md-6 col-lg-3">
                    <a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="text-decoration-none">
                        <div class="portal-card p-3 text-center h-100">
                            <div class="fs-1 mb-2">📋</div>
                            <h3 class="h6 fw-bold text-dark mb-1">My Complaints</h3>
                            <p class="text-muted small mb-0">View submitted issues and 5-stage progress timeline</p>
                        </div>
                    </a>
                </div>
                <div class="col-md-6 col-lg-3">
                    <a href="<%= request.getContextPath() %>/student/lost-found.jsp" class="text-decoration-none">
                        <div class="portal-card p-3 text-center h-100">
                            <div class="fs-1 mb-2">🔍</div>
                            <h3 class="h6 fw-bold text-dark mb-1">Lost &amp; Found</h3>
                            <p class="text-muted small mb-0">Find lost campus items or post items you found</p>
                        </div>
                    </a>
                </div>
                <div class="col-md-6 col-lg-3">
                    <a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="text-decoration-none">
                        <div class="portal-card p-3 text-center h-100">
                            <div class="fs-1 mb-2">⭐</div>
                            <h3 class="h6 fw-bold text-dark mb-1">Give Feedback</h3>
                            <p class="text-muted small mb-0">Rate the resolution quality of completed complaints</p>
                        </div>
                    </a>
                </div>
            </div>

            <!-- Recent Submitted Complaints -->
            <div class="portal-card">
                <div class="portal-card-header">
                    <h3 class="portal-card-title">Recent Complaints Activity</h3>
                    <a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="btn btn-outline-primary btn-sm">View All</a>
                </div>
                <div class="table-responsive">
                    <table class="table cc-table">
                        <thead>
                            <tr>
                                <th>Complaint ID</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Subject</th>
                                <th>Date</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (recentList.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-4 text-muted">
                                        No complaints submitted yet. Click <a href="<%= request.getContextPath() %>/student/submit-complaint.jsp">Submit Complaint</a> to report an issue.
                                    </td>
                                </tr>
                            <% } else { 
                                int count = 0;
                                for (Complaint c : recentList) {
                                    if (count++ >= 5) break;
                            %>
                                <tr>
                                    <td class="fw-bold"><a href="<%= request.getContextPath() %>/complaint?action=details&id=<%= c.getComplaintId() %>"><%= c.getComplaintId() %></a></td>
                                    <td><%= c.getCategory() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= c.getBlock() %></span> <%= c.getLocationName() %></td>
                                    <td><%= c.getSubject() %></td>
                                    <td><%= c.getFormattedCreatedDate() %></td>
                                    <td><span class="badge <%= c.getPriorityBadgeClass() %>"><%= c.getPriority() %></span></td>
                                    <td>
                                        <%
                                            String stClass = "badge-pending";
                                            if ("ASSIGNED".equalsIgnoreCase(c.getStatus())) stClass = "badge-assigned";
                                            else if ("IN PROGRESS".equalsIgnoreCase(c.getStatus())) stClass = "badge-in-progress";
                                            else if ("RESOLVED".equalsIgnoreCase(c.getStatus())) stClass = "badge-resolved";
                                            else if ("CLOSED".equalsIgnoreCase(c.getStatus())) stClass = "badge-closed";
                                            else if ("REJECTED".equalsIgnoreCase(c.getStatus())) stClass = "badge-rejected";
                                        %>
                                        <span class="badge-status <%= stClass %>"><%= c.getStatus() %></span>
                                    </td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/complaint?action=details&id=<%= c.getComplaintId() %>" class="btn btn-sm btn-outline-primary">
                                            View Details
                                        </a>
                                    </td>
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
</body>
</html>
