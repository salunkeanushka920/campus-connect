<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.Feedback" %>
<%@ page import="com.campusconnect.dao.FeedbackDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    FeedbackDAO fbDAO = new FeedbackDAO();
    List<Feedback> feedbackList = fbDAO.getAllFeedback();
    double avgRating = fbDAO.getAverageRating();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Feedback — Admin Console</title>
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
                <li><a href="<%= request.getContextPath() %>/admin/students.jsp">🎓 Registered Students</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/locations.jsp">🏫 Campus Locations</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/staff.jsp">🛠️ Staff Directory</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/feedback.jsp" class="active">⭐ Student Feedback</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">Student Satisfaction &amp; Feedback</h1>
                    <p class="text-muted small mb-0">Ratings and reviews submitted by students after their campus complaints were resolved.</p>
                </div>
            </div>

            <!-- Metric Card -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-md-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-warning">
                                <%= String.format("%.1f", avgRating) %> <span class="fs-4">/ 5.0</span>
                            </div>
                            <div class="stat-label">Average Satisfaction Rating</div>
                        </div>
                        <div class="stat-icon stat-icon-amber">⭐</div>
                    </div>
                </div>
                <div class="col-sm-6 col-md-4">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value"><%= feedbackList.size() %></div>
                            <div class="stat-label">Total Reviews Received</div>
                        </div>
                        <div class="stat-icon stat-icon-blue">💬</div>
                    </div>
                </div>
            </div>

            <!-- Feedback Table -->
            <div class="portal-card p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table cc-table mb-0">
                        <thead>
                            <tr>
                                <th>Complaint ID</th>
                                <th>Student</th>
                                <th>Issue Subject</th>
                                <th>Rating</th>
                                <th>Student Feedback Message</th>
                                <th>Submitted Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (feedbackList.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        No student feedback reviews submitted yet.
                                    </td>
                                </tr>
                            <% } else { 
                                for (Feedback fb : feedbackList) {
                            %>
                                <tr>
                                    <td class="fw-bold font-monospace">
                                        <a href="<%= request.getContextPath() %>/admin/complaint-action?action=view&id=<%= fb.getComplaintId() %>">
                                            <%= fb.getComplaintId() %>
                                        </a>
                                    </td>
                                    <td>
                                        <div class="fw-semibold"><%= fb.getStudentName() %></div>
                                        <div class="text-muted small"><%= fb.getRollNumber() %></div>
                                    </td>
                                    <td><%= fb.getComplaintSubject() %></td>
                                    <td>
                                        <span class="text-warning fs-5 fw-bold"><%= fb.getStarsDisplay() %></span>
                                        <span class="small text-muted ms-1">(<%= fb.getRating() %>/5)</span>
                                    </td>
                                    <td style="max-width: 320px;"><%= fb.getMessage() %></td>
                                    <td><%= fb.getFormattedDate() %></td>
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
