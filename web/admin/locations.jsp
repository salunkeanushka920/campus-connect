<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.CampusLocation" %>
<%@ page import="com.campusconnect.dao.LocationDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    LocationDAO locDAO = new LocationDAO();
    List<CampusLocation> locations = locDAO.getAllLocations();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Locations — Admin Console</title>
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
                <li><a href="<%= request.getContextPath() %>/admin/locations.jsp" class="active">🏫 Campus Locations</a></li>
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
                    <h1 class="h3 fw-bold mb-1">Campus Locations Management</h1>
                    <p class="text-muted small mb-0">Predefined blocks, classrooms, laboratories, and seminar halls. You can easily add more locations.</p>
                </div>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addLocationModal">
                    + Add New Location
                </button>
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
                    <table class="table cc-table mb-0">
                        <thead>
                            <tr>
                                <th>Location ID</th>
                                <th>Campus Block</th>
                                <th>Room / Facility Name</th>
                                <th>Location Type</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CampusLocation loc : locations) { %>
                                <tr>
                                    <td class="fw-bold font-monospace">#<%= loc.getLocationId() %></td>
                                    <td><span class="badge bg-light text-dark border"><%= loc.getBlock() %></span></td>
                                    <td class="fw-semibold"><%= loc.getLocationName() %></td>
                                    <td><%= loc.getLocationType() %></td>
                                    <td>
                                        <% if (loc.isActive()) { %>
                                            <span class="badge bg-success-subtle text-success">Active</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td class="text-end">
                                        <form action="<%= request.getContextPath() %>/admin/location" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="toggle">
                                            <input type="hidden" name="id" value="<%= loc.getLocationId() %>">
                                            <input type="hidden" name="active" value="<%= !loc.isActive() %>">
                                            <button type="submit" class="btn btn-sm <%= loc.isActive() ? "btn-outline-danger" : "btn-outline-success" %>">
                                                <%= loc.isActive() ? "Deactivate" : "Activate" %>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- ADD LOCATION MODAL -->
    <div class="modal fade" id="addLocationModal" tabindex="-1" aria-labelledby="addLocationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/admin/location" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-header">
                        <h2 class="modal-title h5 fw-bold" id="addLocationModalLabel">Add Campus Location</h2>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label for="blockInput" class="form-label small fw-bold">Campus Block *</label>
                            <input type="text" class="form-control" id="blockInput" name="block" 
                                   placeholder="e.g. A Block, X Block, Y Block, Central Block" required>
                        </div>

                        <div class="mb-3">
                            <label for="nameInput" class="form-label small fw-bold">Room / Hall / Facility Name *</label>
                            <input type="text" class="form-control" id="nameInput" name="locationName" 
                                   placeholder="e.g. Room A-03, Physics Lab, Board Room" required>
                        </div>

                        <div class="mb-3">
                            <label for="typeInput" class="form-label small fw-bold">Facility Type *</label>
                            <select class="form-select" id="typeInput" name="locationType" required>
                                <option value="Classroom">Classroom</option>
                                <option value="Laboratory">Laboratory</option>
                                <option value="Auditorium">Auditorium / Seminar Hall</option>
                                <option value="Library">Library / Reading Room</option>
                                <option value="Faculty">Faculty / Staff Room</option>
                                <option value="Washroom">Washroom</option>
                                <option value="Amenities">Canteen / Gym / Common Area</option>
                                <option value="Security">Security / Entrance</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-sm">Save Location</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
