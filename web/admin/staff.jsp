<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.Staff" %>
<%@ page import="com.campusconnect.dao.StaffDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    StaffDAO staffDAO = new StaffDAO();
    List<Staff> staffList = staffDAO.getAllActiveStaff();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Directory — Admin Console</title>
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
                <li><a href="<%= request.getContextPath() %>/admin/staff.jsp" class="active">🛠️ Staff Directory</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/feedback.jsp">⭐ Student Feedback</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">Campus Staff &amp; Maintenance Directory</h1>
                    <p class="text-muted small mb-0">List of technicians, electricians, IT support, and housekeeping personnel available for complaint assignment.</p>
                </div>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    + Add New Staff Member
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
                                <th>Staff ID</th>
                                <th>Staff Name</th>
                                <th>Assigned Department</th>
                                <th>Phone / Extension</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Staff st : staffList) { %>
                                <tr>
                                    <td class="fw-bold font-monospace">#<%= st.getStaffId() %></td>
                                    <td class="fw-semibold"><%= st.getStaffName() %></td>
                                    <td><span class="badge bg-primary-subtle text-primary border"><%= st.getDepartmentName() %></span></td>
                                    <td><%= st.getContact() %></td>
                                    <td>
                                        <span class="badge bg-success-subtle text-success">Active &bull; Available</span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- ADD STAFF MODAL -->
    <div class="modal fade" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/admin/staff-action" method="POST">
                    <div class="modal-header">
                        <h2 class="modal-title h5 fw-bold" id="addStaffModalLabel">Add Maintenance Staff</h2>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label for="staffName" class="form-label small fw-bold">Full Name *</label>
                            <input type="text" class="form-control" id="staffName" name="staffName" 
                                   placeholder="e.g. Ramesh Patil" required>
                        </div>

                        <div class="mb-3">
                            <label for="deptSelect" class="form-label small fw-bold">Department *</label>
                            <select class="form-select" id="deptSelect" name="department" required>
                                <option value="Electrical Department">Electrical Department</option>
                                <option value="Air Conditioning & Cooling">Air Conditioning &amp; Cooling</option>
                                <option value="IT Support & Systems">IT Support &amp; Systems</option>
                                <option value="Housekeeping & Cleanliness">Housekeeping &amp; Cleanliness</option>
                                <option value="Carpentry & Furniture">Carpentry &amp; Furniture</option>
                                <option value="Campus Security">Campus Security</option>
                                <option value="Academic Support">Academic Support</option>
                                <option value="General Maintenance">General Maintenance</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="staffContact" class="form-label small fw-bold">Contact / Intercom Number *</label>
                            <input type="text" class="form-control" id="staffContact" name="contact" 
                                   placeholder="e.g. +91 98200 12345 / Ext 204" required>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-sm">Add Staff</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
