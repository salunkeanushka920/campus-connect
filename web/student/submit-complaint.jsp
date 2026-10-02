<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Student" %>
<%@ page import="com.campusconnect.model.CampusLocation" %>
<%@ page import="com.campusconnect.dao.LocationDAO" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in.");
        return;
    }

    LocationDAO locationDAO = new LocationDAO();
    List<CampusLocation> locations = locationDAO.getAllActiveLocations();
    List<String> blocks = locationDAO.getDistinctBlocks();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Complaint — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Top Header -->
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
                <li><a href="<%= request.getContextPath() %>/student/submit-complaint.jsp" class="active">✍️ Submit Complaint</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp">📋 My Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/student/lost-found.jsp">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp?filter=resolved">⭐ Give Feedback</a></li>
                <li><a href="<%= request.getContextPath() %>/student/profile.jsp">👤 My Profile</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 fw-bold mb-1">Submit Campus Complaint</h1>
                    <p class="text-muted small mb-0">Fill in the details below to notify maintenance and faculty administration.</p>
                </div>
                <a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="btn btn-outline-secondary btn-sm">
                    View My Complaints
                </a>
            </div>

            <%-- Error message --%>
            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <strong>Submission Error:</strong> <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="row">
                <div class="col-lg-8">
                    <div class="portal-card">
                        <form action="<%= request.getContextPath() %>/complaint" method="POST">
                            
                            <div class="row g-3">
                                
                                <!-- Category -->
                                <div class="col-md-6">
                                    <label for="category" class="form-label small fw-bold">Complaint Category *</label>
                                    <select class="form-select" id="category" name="category" required>
                                        <option value="" disabled selected>Select Issue Category</option>
                                        <option value="Classroom">Classroom</option>
                                        <option value="Laboratory">Laboratory</option>
                                        <option value="AC / Cooling">AC / Cooling</option>
                                        <option value="Fan / Electrical">Fan / Electrical</option>
                                        <option value="Furniture">Furniture</option>
                                        <option value="Projector / Display Panel">Projector / Display Panel</option>
                                        <option value="Computer / Technology">Computer / Technology</option>
                                        <option value="Internet / Wi-Fi">Internet / Wi-Fi</option>
                                        <option value="Cleanliness">Cleanliness</option>
                                        <option value="Washroom">Washroom</option>
                                        <option value="Water Supply">Water Supply</option>
                                        <option value="Lighting">Lighting</option>
                                        <option value="Security">Security</option>
                                        <option value="Infrastructure">Infrastructure</option>
                                        <option value="Staff / Faculty">Staff / Faculty</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>

                                <!-- Priority -->
                                <div class="col-md-6">
                                    <label for="priority" class="form-label small fw-bold">Priority Level *</label>
                                    <select class="form-select" id="priority" name="priority" required>
                                        <option value="Low">Low (Routine maintenance)</option>
                                        <option value="Medium" selected>Medium (Standard request)</option>
                                        <option value="High">High (Impacting classes)</option>
                                        <option value="Urgent">Urgent (Safety / Immediate attention)</option>
                                    </select>
                                </div>

                                <!-- Dynamic Campus Block Filter -->
                                <div class="col-md-6">
                                    <label for="blockFilter" class="form-label small fw-bold">College Block *</label>
                                    <select class="form-select" id="blockFilter">
                                        <option value="ALL">All Blocks</option>
                                        <% for (String b : blocks) { %>
                                            <option value="<%= b %>"><%= b %></option>
                                        <% } %>
                                    </select>
                                    <div class="form-text small">Filter rooms by campus block.</div>
                                </div>

                                <!-- Database-driven Specific Location / Room -->
                                <div class="col-md-6">
                                    <label for="locationSelect" class="form-label small fw-bold">Specific Room / Location *</label>
                                    <select class="form-select" id="locationSelect" name="locationId" required>
                                        <option value="" disabled selected>Select Room or Facility</option>
                                        <% for (CampusLocation loc : locations) { %>
                                            <option value="<%= loc.getLocationId() %>" data-block="<%= loc.getBlock() %>">
                                                <%= loc.getBlock() %> &bull; <%= loc.getLocationName() %> (<%= loc.getLocationType() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>

                                <!-- Subject -->
                                <div class="col-12">
                                    <label for="subject" class="form-label small fw-bold">Subject / Issue Summary *</label>
                                    <input type="text" class="form-control" id="subject" name="subject" 
                                           placeholder="e.g. Ceiling fan not rotating at normal speed in Room A-02" required maxlength="200">
                                </div>

                                <!-- Description -->
                                <div class="col-12">
                                    <label for="description" class="form-label small fw-bold">Detailed Description *</label>
                                    <textarea class="form-control" id="description" name="description" rows="5" 
                                              placeholder="Provide specific details (e.g. row number, error message, exact symptoms) to help technicians locate and solve the issue." required></textarea>
                                </div>

                                <!-- Submit Button -->
                                <div class="col-12 mt-4 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary px-4 py-2 fw-semibold">
                                        Submit Complaint
                                    </button>
                                    <a href="<%= request.getContextPath() %>/student/dashboard.jsp" class="btn btn-outline-secondary px-4 py-2">
                                        Cancel
                                    </a>
                                </div>

                            </div>
                        </form>
                    </div>
                </div>

                <!-- Info Side Card -->
                <div class="col-lg-4">
                    <div class="portal-card bg-light border">
                        <h2 class="h6 fw-bold mb-3">📌 Important Information</h2>
                        <ul class="small text-muted ps-3 mb-0">
                            <li class="mb-2">A unique <strong>Complaint ID (e.g. CC-2026-00001)</strong> will be automatically generated upon submission.</li>
                            <li class="mb-2">Campus administrators review incoming tickets and dispatch the appropriate department staff (Electrical, AC, IT Support, Cleaning).</li>
                            <li class="mb-2">You can track progress across 5 stages: <em>Submitted &rarr; Assigned &rarr; In Progress &rarr; Resolved &rarr; Closed</em>.</li>
                            <li>Once the issue is marked <strong>Resolved</strong>, you can submit a 1–5 star feedback review.</li>
                        </ul>
                    </div>
                </div>

            </div>

        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
