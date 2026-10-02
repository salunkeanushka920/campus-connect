<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.LostFound" %>
<%@ page import="com.campusconnect.dao.LostFoundDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    LostFoundDAO lfDAO = new LostFoundDAO();
    List<LostFound> items = lfDAO.getAllItems();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lost &amp; Found Moderation — Admin Console</title>
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
                <li><a href="<%= request.getContextPath() %>/admin/lost-found.jsp" class="active">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/feedback.jsp">⭐ Student Feedback</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">Lost &amp; Found Item Moderation</h1>
                    <p class="text-muted small mb-0">Review student reported lost and found campus belongings and update claiming status.</p>
                </div>
                <div style="max-width: 320px;" class="w-100">
                    <input type="text" id="tableSearchInput" class="form-control form-control-sm" placeholder="Search item, location, or student...">
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

            <div class="portal-card p-0 overflow-hidden">
                <div class="table-responsive">
                    <table class="table cc-table mb-0" id="filterableTable">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Item Name</th>
                                <th>Category</th>
                                <th>Description</th>
                                <th>Location</th>
                                <th>Date</th>
                                <th>Reported By</th>
                                <th>Status</th>
                                <th class="text-end">Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (items.isEmpty()) { %>
                                <tr><td colspan="9" class="text-center py-5 text-muted">No lost or found items recorded.</td></tr>
                            <% } else { 
                                for (LostFound item : items) {
                            %>
                                <tr>
                                    <td>
                                        <% if ("LOST".equalsIgnoreCase(item.getType())) { %>
                                            <span class="badge bg-danger-subtle text-danger">LOST</span>
                                        <% } else { %>
                                            <span class="badge bg-success-subtle text-success">FOUND</span>
                                        <% } %>
                                    </td>
                                    <td class="fw-bold"><%= item.getItemName() %></td>
                                    <td><%= item.getCategory() %></td>
                                    <td style="max-width: 200px;"><%= item.getDescription() %></td>
                                    <td><%= item.getLocation() %></td>
                                    <td><%= item.getFormattedDate() %></td>
                                    <td>
                                        <div><%= item.getStudentName() %></div>
                                        <div class="text-muted small"><%= item.getRollNumber() %></div>
                                    </td>
                                    <td>
                                        <% if ("CLAIMED".equalsIgnoreCase(item.getStatus())) { %>
                                            <span class="badge bg-success">CLAIMED</span>
                                        <% } else if ("CLOSED".equalsIgnoreCase(item.getStatus())) { %>
                                            <span class="badge bg-secondary">CLOSED</span>
                                        <% } else { %>
                                            <span class="badge bg-warning text-dark"><%= item.getStatus() %></span>
                                        <% } %>
                                    </td>
                                    <td class="text-end">
                                        <form action="<%= request.getContextPath() %>/lost-found" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="id" value="<%= item.getId() %>">
                                            <input type="hidden" name="redirect" value="<%= request.getContextPath() %>/admin/lost-found.jsp">
                                            <div class="btn-group btn-group-sm">
                                                <button type="submit" name="status" value="CLAIMED" class="btn btn-outline-success">Mark Claimed</button>
                                                <button type="submit" name="status" value="CLOSED" class="btn btn-outline-secondary">Close</button>
                                            </div>
                                        </form>
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
