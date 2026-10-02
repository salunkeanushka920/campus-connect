<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Admin" %>
<%@ page import="com.campusconnect.model.Complaint" %>
<%@ page import="com.campusconnect.model.Staff" %>
<%@ page import="com.campusconnect.dao.ComplaintDAO" %>
<%@ page import="com.campusconnect.dao.StaffDAO" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Please+log+in.");
        return;
    }

    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");

    if (complaint == null) {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            ComplaintDAO cDAO = new ComplaintDAO();
            complaint = cDAO.getComplaintById(idParam.trim());
            StaffDAO sDAO = new StaffDAO();
            staffList = sDAO.getAllActiveStaff();
        }
    }

    if (complaint == null) {
        response.sendRedirect(request.getContextPath() + "/admin/complaints.jsp?error=Complaint+not+found.");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Ticket <%= complaint.getComplaintId() %> — Admin Console</title>
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
                <a href="<%= request.getContextPath() %>/admin/complaints.jsp" class="btn btn-outline-light btn-sm">&larr; Back to Complaints</a>
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
                    <span class="badge bg-secondary font-monospace mb-1">Ticket #<%= complaint.getComplaintId() %></span>
                    <h1 class="h3 fw-bold mb-0"><%= complaint.getSubject() %></h1>
                </div>
                <div>
                    <span class="badge <%= complaint.getPriorityBadgeClass() %> me-2 px-3 py-2 fs-6"><%= complaint.getPriority() %> Priority</span>
                    <span class="badge-status badge-<%= complaint.getStatus().toLowerCase().replace(" ", "-") %> fs-6 px-3 py-2"><%= complaint.getStatus() %></span>
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

            <div class="row g-4">
                
                <!-- Left: Ticket Information -->
                <div class="col-lg-7">
                    <div class="portal-card mb-4">
                        <h2 class="h6 fw-bold border-bottom pb-2 mb-3">Ticket Information &amp; Student Details</h2>
                        
                        <div class="mb-3">
                            <span class="text-muted small d-block">Description:</span>
                            <div class="p-3 bg-light rounded-3 mt-1 text-dark" style="white-space: pre-wrap; line-height: 1.6;">
<%= complaint.getDescription() %>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Category:</span>
                                <strong><%= complaint.getCategory() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Location:</span>
                                <strong><%= complaint.getBlock() %> &bull; <%= complaint.getLocationName() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Student Name:</span>
                                <div><%= complaint.getStudentName() %></div>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Roll Number:</span>
                                <div class="font-monospace fw-bold"><%= complaint.getRollNumber() %></div>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Contact Info:</span>
                                <div><%= complaint.getStudentPhone() %> &bull; <%= complaint.getStudentEmail() %></div>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Reported At:</span>
                                <div><%= complaint.getFormattedCreatedDate() %></div>
                            </div>
                        </div>

                        <!-- Current Assignment & Remarks -->
                        <div class="mt-4 pt-3 border-top">
                            <h3 class="h6 fw-bold mb-2">Current Assignment &amp; Remarks</h3>
                            <div class="row g-2">
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Assigned Person:</span>
                                    <strong><%= complaint.getAssignedStaffName() != null ? complaint.getAssignedStaffName() + " (" + complaint.getAssignedDepartment() + ")" : "None" %></strong>
                                </div>
                                <div class="col-sm-6">
                                    <span class="text-muted small d-block">Resolution Date:</span>
                                    <div><%= complaint.getFormattedResolvedDate() %></div>
                                </div>
                                <div class="col-12 mt-2">
                                    <span class="text-muted small d-block">Current Remarks:</span>
                                    <div class="p-2 bg-light rounded small mt-1">
                                        <%= complaint.getAdminRemarks() != null ? complaint.getAdminRemarks() : "No remarks recorded yet." %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right: Action Forms (Assign Staff & Change Status) -->
                <div class="col-lg-5">
                    
                    <!-- 1. ASSIGN STAFF FORM -->
                    <div class="portal-card mb-4">
                        <h2 class="h6 fw-bold border-bottom pb-2 mb-3">🛠️ Assign Staff / Department</h2>
                        <form action="<%= request.getContextPath() %>/admin/complaint-action" method="POST">
                            <input type="hidden" name="action" value="assign">
                            <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

                            <div class="mb-3">
                                <label for="staffSelect" class="form-label small fw-bold">Select Responsible Person *</label>
                                <select class="form-select form-select-sm" id="staffSelect" name="staffId" required>
                                    <option value="" disabled selected>Choose Staff Member</option>
                                    <% if (staffList != null) {
                                        for (Staff st : staffList) {
                                            boolean isAssigned = (complaint.getAssignedStaffId() != null && complaint.getAssignedStaffId() == st.getStaffId());
                                    %>
                                        <option value="<%= st.getStaffId() %>" <%= isAssigned ? "selected" : "" %>>
                                            <%= st.getStaffName() %> &bull; <%= st.getDepartmentName() %> (<%= st.getContact() %>)
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="assignStatus" class="form-label small fw-bold">Update Status To</label>
                                <select class="form-select form-select-sm" id="assignStatus" name="status">
                                    <option value="ASSIGNED" <%= "ASSIGNED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>ASSIGNED</option>
                                    <option value="IN PROGRESS" <%= "IN PROGRESS".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>IN PROGRESS (Work Started)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="assignRemarks" class="form-label small fw-bold">Technician Instruction / Remarks</label>
                                <textarea class="form-control form-control-sm" id="assignRemarks" name="remarks" rows="2" 
                                          placeholder="e.g. Technician dispatched with replacement parts."><%= complaint.getAdminRemarks() != null ? complaint.getAdminRemarks() : "" %></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary btn-sm w-100 fw-semibold">
                                Save Assignment &amp; Notify
                            </button>
                        </form>
                    </div>

                    <!-- 2. STATUS UPDATE FORM -->
                    <div class="portal-card">
                        <h2 class="h6 fw-bold border-bottom pb-2 mb-3">🔄 Change Ticket Status</h2>
                        <form action="<%= request.getContextPath() %>/admin/complaint-action" method="POST">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

                            <div class="mb-3">
                                <label for="updateStatusSelect" class="form-label small fw-bold">New Status *</label>
                                <select class="form-select form-select-sm" id="updateStatusSelect" name="status" required>
                                    <option value="PENDING" <%= "PENDING".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>PENDING</option>
                                    <option value="ASSIGNED" <%= "ASSIGNED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>ASSIGNED</option>
                                    <option value="IN PROGRESS" <%= "IN PROGRESS".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>IN PROGRESS</option>
                                    <option value="RESOLVED" <%= "RESOLVED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>RESOLVED (Work Completed)</option>
                                    <option value="CLOSED" <%= "CLOSED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>CLOSED</option>
                                    <option value="REJECTED" <%= "REJECTED".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>REJECTED</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="statusRemarks" class="form-label small fw-bold">Administrative Remarks</label>
                                <textarea class="form-control form-control-sm" id="statusRemarks" name="remarks" rows="2" 
                                          placeholder="e.g. Verified by campus head. Issue has been completely resolved."><%= complaint.getAdminRemarks() != null ? complaint.getAdminRemarks() : "" %></textarea>
                            </div>

                            <button type="submit" class="btn btn-dark btn-sm w-100 fw-semibold">
                                Update Status
                            </button>
                        </form>
                    </div>

                </div>

            </div>

        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
