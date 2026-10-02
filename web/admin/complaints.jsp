<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.Complaint" %>
<%@ page import="com.campusconnect.model.CampusLocation" %>
<%@ page import="com.campusconnect.dao.ComplaintDAO" %>
<%@ page import="com.campusconnect.dao.LocationDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    String statusFilter = request.getParameter("status");
    String categoryFilter = request.getParameter("category");
    String locationFilterStr = request.getParameter("locationId");
    Integer locationFilter = null;
    if (locationFilterStr != null && !locationFilterStr.isEmpty()) {
        try { locationFilter = Integer.parseInt(locationFilterStr); } catch (NumberFormatException ignored) {}
    }

    ComplaintDAO complaintDAO = new ComplaintDAO();
    LocationDAO locationDAO = new LocationDAO();
    List<Complaint> complaints = complaintDAO.getAllComplaints(statusFilter, categoryFilter, locationFilter);
    List<CampusLocation> locations = locationDAO.getAllActiveLocations();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Complaints — Admin Console</title>
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
            <div class="d-flex align-items-center gap-3 text-white">
                <span class="small fw-semibold d-none d-sm-inline"><%= admin.getFullName() %></span>
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
                <li><a href="<%= request.getContextPath() %>/admin/complaints.jsp" class="active">📋 All Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/students.jsp">🎓 Registered Students</a></li>
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
                    <h1 class="h3 fw-bold mb-1">Campus Complaint Management</h1>
                    <p class="text-muted small mb-0">Review reported tickets, dispatch maintenance technicians, and update resolution status.</p>
                </div>
                <div class="badge bg-primary fs-6 px-3 py-2">
                    Total: <%= complaints.size() %> Tickets
                </div>
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

            <!-- Filter Bar -->
            <div class="portal-card p-3 mb-4">
                <form action="<%= request.getContextPath() %>/admin/complaints.jsp" method="GET" class="row g-2 align-items-center">
                    
                    <div class="col-md-3">
                        <label for="adminStatusFilter" class="form-label small fw-semibold mb-1">Filter by Status</label>
                        <select name="status" id="adminStatusFilter" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="ALL" <%= (statusFilter == null || "ALL".equalsIgnoreCase(statusFilter)) ? "selected" : "" %>>All Statuses</option>
                            <option value="PENDING" <%= "PENDING".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Pending</option>
                            <option value="ASSIGNED" <%= "ASSIGNED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Assigned</option>
                            <option value="IN PROGRESS" <%= "IN PROGRESS".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>In Progress</option>
                            <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Resolved</option>
                            <option value="CLOSED" <%= "CLOSED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Closed</option>
                            <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(statusFilter) ? "selected" : "" %>>Rejected</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="adminCategoryFilter" class="form-label small fw-semibold mb-1">Filter by Category</label>
                        <select name="category" id="adminCategoryFilter" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="ALL" <%= (categoryFilter == null || "ALL".equalsIgnoreCase(categoryFilter)) ? "selected" : "" %>>All Categories</option>
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
                        <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search student name, roll number, ID, or room...">
                    </div>

                    <div class="col-md-2 mt-auto text-end">
                        <a href="<%= request.getContextPath() %>/admin/complaints.jsp" class="btn btn-outline-secondary btn-sm w-100">Reset Filters</a>
                    </div>
                </form>
            </div>

            <!-- Complaints Table -->
            <div class="portal-card p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table cc-table mb-0" id="filterableTable">
                        <thead>
                            <tr>
                                <th>Complaint ID</th>
                                <th>Student</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Priority</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Assigned Staff</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (complaints.isEmpty()) { %>
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        No complaints match the selected filter.
                                    </td>
                                </tr>
                            <% } else { 
                                for (Complaint c : complaints) {
                            %>
                                <tr>
                                    <td class="fw-bold font-monospace"><%= c.getComplaintId() %></td>
                                    <td>
                                        <div class="fw-semibold"><%= c.getStudentName() %></div>
                                        <div class="text-muted small"><%= c.getRollNumber() %></div>
                                    </td>
                                    <td><%= c.getCategory() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= c.getBlock() %></span> <%= c.getLocationName() %></td>
                                    <td><span class="badge <%= c.getPriorityBadgeClass() %>"><%= c.getPriority() %></span></td>
                                    <td><%= c.getFormattedCreatedDate() %></td>
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
                                        <%= c.getAssignedStaffName() != null ? c.getAssignedStaffName() : "<span class='text-muted small fst-italic'>Unassigned</span>" %>
                                    </td>
                                    <td class="text-end">
                                        <a href="<%= request.getContextPath() %>/admin/complaint-action?action=view&id=<%= c.getComplaintId() %>" 
                                           class="btn btn-sm btn-primary">
                                            Review &amp; Assign
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
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
