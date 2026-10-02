<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.Complaint" %>
<%@ page import="com.campusconnect.dao.ComplaintDAO" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in+with+administrator+credentials.");
        return;
    }

    ComplaintDAO complaintDAO = new ComplaintDAO();
    Map<String, Integer> stats = complaintDAO.getAdminStats();
    Map<String, Integer> catStats = complaintDAO.getComplaintsByCategory();
    Map<String, Integer> blockStats = complaintDAO.getComplaintsByBlock();
    List<Complaint> recentList = complaintDAO.getRecentComplaints(6);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Dashboard — Campus Connect</title>
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
                <div class="text-end d-none d-sm-block text-white">
                    <div class="fw-bold small"><%= admin.getFullName() %></div>
                    <div class="text-light-50" style="font-size: 0.75rem; color: #94a3b8;">Administrator (@<%= admin.getUsername() %>)</div>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </header>

    <div class="dashboard-wrapper">

        <!-- Admin Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-heading">Admin Console</div>
            <ul class="sidebar-nav">
                <li><a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="active">📊 Dashboard</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/complaints.jsp">📋 All Complaints</a></li>
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
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold mb-1">Campus Operations Dashboard</h1>
                    <p class="text-muted small mb-0">Overview of student issues, maintenance tickets, and campus repair progress.</p>
                </div>
                <a href="<%= request.getContextPath() %>/admin/complaints.jsp" class="btn btn-primary btn-sm">
                    Manage Complaints
                </a>
            </div>

            <!-- Statistics Counters Grid (6 Metrics) -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value"><%= stats.get("total") %></div>
                            <div class="stat-label">Total</div>
                        </div>
                        <div class="stat-icon stat-icon-blue">📁</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-warning"><%= stats.get("pending") %></div>
                            <div class="stat-label">Pending</div>
                        </div>
                        <div class="stat-icon stat-icon-amber">⏳</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-info"><%= stats.get("assigned") %></div>
                            <div class="stat-label">Assigned</div>
                        </div>
                        <div class="stat-icon stat-icon-purple">👤</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-primary"><%= stats.get("inProgress") %></div>
                            <div class="stat-label">In Progress</div>
                        </div>
                        <div class="stat-icon stat-icon-blue">🔧</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-success"><%= stats.get("resolved") %></div>
                            <div class="stat-label">Resolved</div>
                        </div>
                        <div class="stat-icon stat-icon-green">✅</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-2">
                    <div class="stat-card">
                        <div>
                            <div class="stat-value text-secondary"><%= stats.get("closed") %></div>
                            <div class="stat-label">Closed</div>
                        </div>
                        <div class="stat-icon stat-icon-gray">🔒</div>
                    </div>
                </div>
            </div>

            <!-- Breakdown Charts / Tables -->
            <div class="row g-4 mb-4">
                
                <!-- Complaints by Category -->
                <div class="col-lg-6">
                    <div class="portal-card h-100">
                        <div class="portal-card-header">
                            <h2 class="portal-card-title">Complaints by Category</h2>
                            <span class="badge bg-light text-dark border">Breakdown</span>
                        </div>
                        <div class="table-responsive">
                            <table class="table cc-table mb-0">
                                <thead>
                                    <tr>
                                        <th>Category</th>
                                        <th class="text-end">Tickets Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (catStats.isEmpty()) { %>
                                        <tr><td colspan="2" class="text-center text-muted">No data available</td></tr>
                                    <% } else {
                                        for (Map.Entry<String, Integer> e : catStats.entrySet()) {
                                    %>
                                        <tr>
                                            <td class="fw-semibold"><%= e.getKey() %></td>
                                            <td class="text-end"><span class="badge bg-primary-subtle text-primary fw-bold"><%= e.getValue() %></span></td>
                                        </tr>
                                    <%  } 
                                    } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Complaints by Location / Block -->
                <div class="col-lg-6">
                    <div class="portal-card h-100">
                        <div class="portal-card-header">
                            <h2 class="portal-card-title">Complaints by Campus Block</h2>
                            <span class="badge bg-light text-dark border">Locations</span>
                        </div>
                        <div class="table-responsive">
                            <table class="table cc-table mb-0">
                                <thead>
                                    <tr>
                                        <th>Campus Block</th>
                                        <th class="text-end">Tickets Count</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (blockStats.isEmpty()) { %>
                                        <tr><td colspan="2" class="text-center text-muted">No data available</td></tr>
                                    <% } else {
                                        for (Map.Entry<String, Integer> e : blockStats.entrySet()) {
                                    %>
                                        <tr>
                                            <td class="fw-semibold"><%= e.getKey() %></td>
                                            <td class="text-end"><span class="badge bg-info-subtle text-info fw-bold"><%= e.getValue() %></span></td>
                                        </tr>
                                    <%  } 
                                    } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Recent Incoming Complaints Feed -->
            <div class="portal-card p-0 overflow-hidden">
                <div class="portal-card-header p-3 mb-0">
                    <h2 class="portal-card-title">Recent Tickets Feed</h2>
                    <a href="<%= request.getContextPath() %>/admin/complaints.jsp" class="btn btn-outline-primary btn-sm">View Full List</a>
                </div>
                <div class="table-responsive">
                    <table class="table cc-table mb-0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Student</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Priority</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Assigned To</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (recentList.isEmpty()) { %>
                                <tr><td colspan="9" class="text-center py-4 text-muted">No complaints in system yet.</td></tr>
                            <% } else {
                                for (Complaint c : recentList) {
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
</body>
</html>
