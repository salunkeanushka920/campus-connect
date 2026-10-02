<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Student" %>
<%@ page import="com.campusconnect.model.Complaint" %>
<%@ page import="com.campusconnect.dao.ComplaintDAO" %>
<%@ page import="com.campusconnect.dao.FeedbackDAO" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in.");
        return;
    }

    String statusFilter = request.getParameter("status");
    String categoryFilter = request.getParameter("category");
    if (statusFilter == null) statusFilter = "ALL";
    if (categoryFilter == null) categoryFilter = "ALL";

    ComplaintDAO complaintDAO = new ComplaintDAO();
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Complaint> complaints = complaintDAO.getComplaintsByStudent(student.getRollNumber(), statusFilter, categoryFilter);

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Complaints — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Navigation Header -->
    <header class="cc-navbar">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/student/dashboard.jsp" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-sm-block">
                    <div class="fw-bold small"><%= student.getFullName() %></div>
                    <div class="text-muted" style="font-size: 0.75rem;"><%= student.getRollNumber() %></div>
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
                <li><a href="<%= request.getContextPath() %>/student/dashboard.jsp">📊 Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/student/submit-complaint.jsp">✍️ Submit Complaint</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="active">📋 My Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/student/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp?status=RESOLVED">⭐ Give Feedback</a></li>
                <li><a href="<%= request.getContextPath() %>/student/profile.jsp">👤 My Profile</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">My Submitted Complaints</h1>
                    <p class="text-muted small mb-0">Track the real-time status and technician assignments of all your reported issues.</p>
                </div>
                <a href="<%= request.getContextPath() %>/student/submit-complaint.jsp" class="btn btn-primary">
                    + Submit New Complaint
                </a>
            </div>

            <% if (success != null && !success.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <% if (error != null && !error.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Filter Toolbar -->
            <div class="portal-card p-3 mb-4">
                <form action="<%= request.getContextPath() %>/student/my-complaints.jsp" method="GET" class="row g-2 align-items-center">
                    
                    <div class="col-md-3">
                        <label for="statusFilter" class="form-label small fw-semibold mb-1">Filter by Status</label>
                        <select name="status" id="statusFilter" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="ALL" <%= "ALL".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>All Statuses</option>
                            <option value="PENDING" <%= "PENDING".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Pending</option>
                            <option value="ASSIGNED" <%= "ASSIGNED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Assigned</option>
                            <option value="IN PROGRESS" <%= "IN PROGRESS".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>In Progress</option>
                            <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Resolved</option>
                            <option value="CLOSED" <%= "CLOSED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Closed</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="catFilter" class="form-label small fw-semibold mb-1">Filter by Category</label>
                        <select name="category" id="catFilter" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="ALL" <%= "ALL".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>All Categories</option>
                            <option value="Classroom" <%= "Classroom".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Classroom</option>
                            <option value="Laboratory" <%= "Laboratory".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Laboratory</option>
                            <option value="AC / Cooling" <%= "AC / Cooling".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>AC / Cooling</option>
                            <option value="Fan / Electrical" <%= "Fan / Electrical".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Fan / Electrical</option>
                            <option value="Furniture" <%= "Furniture".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Furniture</option>
                            <option value="Cleanliness" <%= "Cleanliness".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Cleanliness</option>
                            <option value="Projector / Display Panel" <%= "Projector / Display Panel".equalsIgnoreCase(categoryFilter) ? "selected" : "" %>>Projector / Display</option>
                        </select>
                    </div>

                    <div class="col-md-4 ms-auto">
                        <label for="tableSearchInput" class="form-label small fw-semibold mb-1">Instant Search</label>
                        <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search by ID, room, or subject...">
                    </div>

                    <div class="col-md-2 mt-auto text-end">
                        <a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="btn btn-outline-secondary btn-sm w-100">Reset Filters</a>
                    </div>
                </form>
            </div>

            <!-- Table Card -->
            <div class="portal-card p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table cc-table mb-0" id="filterableTable">
                        <thead>
                            <tr>
                                <th>Complaint ID</th>
                                <th>Category</th>
                                <th>Campus Location</th>
                                <th>Subject</th>
                                <th>Submitted Date</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (complaints.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <div class="fs-4 mb-2">📂</div>
                                        <strong>No complaints match your selection.</strong>
                                        <p class="small mb-0 mt-1">Submit a new complaint or change your filter criteria.</p>
                                    </td>
                                </tr>
                            <% } else { 
                                for (Complaint c : complaints) {
                                    boolean isResolved = "RESOLVED".equalsIgnoreCase(c.getStatus()) || "CLOSED".equalsIgnoreCase(c.getStatus());
                                    boolean hasFeedback = feedbackDAO.hasFeedback(c.getComplaintId());
                            %>
                                <tr>
                                    <td class="fw-bold font-monospace">
                                        <a href="<%= request.getContextPath() %>/complaint?action=details&id=<%= c.getComplaintId() %>">
                                            <%= c.getComplaintId() %>
                                        </a>
                                    </td>
                                    <td><%= c.getCategory() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= c.getBlock() %></span> <%= c.getLocationName() %></td>
                                    <td style="max-width: 240px;" class="text-truncate" title="<%= c.getSubject() %>"><%= c.getSubject() %></td>
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
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <a href="<%= request.getContextPath() %>/complaint?action=details&id=<%= c.getComplaintId() %>" 
                                               class="btn btn-outline-primary">
                                                View Details
                                            </a>
                                            <% if (isResolved && !hasFeedback) { %>
                                                <a href="<%= request.getContextPath() %>/complaint?action=details&id=<%= c.getComplaintId() %>#feedbackForm" 
                                                   class="btn btn-warning text-dark fw-semibold">
                                                    Rate ⭐
                                                </a>
                                            <% } %>
                                        </div>
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
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
