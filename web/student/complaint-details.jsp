<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Student" %>
<%@ page import="com.campusconnect.model.Complaint" %>
<%@ page import="com.campusconnect.dao.ComplaintDAO" %>
<%@ page import="com.campusconnect.dao.FeedbackDAO" %>
<%@ page import="com.campusconnect.model.Feedback" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in.");
        return;
    }

    Complaint complaint = (Complaint) request.getAttribute("complaint");
    if (complaint == null) {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            ComplaintDAO cDAO = new ComplaintDAO();
            complaint = cDAO.getComplaintById(idParam.trim());
        }
    }

    if (complaint == null) {
        response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Complaint+not+found.");
        return;
    }

    // Security check: Student can only view their own complaints
    if (!student.getRollNumber().equalsIgnoreCase(complaint.getRollNumber())) {
        response.sendRedirect(request.getContextPath() + "/student/my-complaints.jsp?error=Unauthorized+access+to+complaint.");
        return;
    }

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    boolean hasFeedback = feedbackDAO.hasFeedback(complaint.getComplaintId());
    int stage = complaint.getTimelineStage();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint <%= complaint.getComplaintId() %> — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header -->
    <header class="cc-navbar">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/student/dashboard.jsp" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <div class="d-flex align-items-center gap-3">
                <a href="<%= request.getContextPath() %>/student/my-complaints.jsp" class="btn btn-outline-secondary btn-sm">&larr; Back to Complaints</a>
            </div>
        </div>
    </header>

    <div class="dashboard-wrapper">

        <!-- Sidebar -->
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

        <!-- Main Content -->
        <main class="main-content">
            
            <!-- Breadcrumb / Header -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <span class="badge bg-primary-subtle text-primary mb-1 font-monospace">Ticket <%= complaint.getComplaintId() %></span>
                    <h1 class="h3 fw-bold mb-0"><%= complaint.getSubject() %></h1>
                </div>
                <div>
                    <span class="badge <%= complaint.getPriorityBadgeClass() %> me-2 px-3 py-2 fs-6"><%= complaint.getPriority() %> Priority</span>
                    <span class="badge-status badge-<%= complaint.getStatus().toLowerCase().replace(" ", "-") %> fs-6 px-3 py-2"><%= complaint.getStatus() %></span>
                </div>
            </div>

            <!-- VISUAL 5-STAGE PROGRESS TIMELINE -->
            <div class="portal-card mb-4">
                <h2 class="h6 fw-bold mb-3">Resolution Progress Timeline</h2>
                
                <% if ("REJECTED".equalsIgnoreCase(complaint.getStatus())) { %>
                    <div class="alert alert-danger mb-0">
                        <strong>Ticket Status: REJECTED</strong><br>
                        This issue report was reviewed and marked as rejected by campus administration.
                        <% if (complaint.getAdminRemarks() != null && !complaint.getAdminRemarks().isEmpty()) { %>
                            <div class="mt-2 text-dark"><strong>Reason:</strong> <%= complaint.getAdminRemarks() %></div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="timeline-container">
                        <div class="timeline-steps">
                            
                            <!-- Step 1: Submitted -->
                            <div class="timeline-step <%= stage >= 1 ? (stage == 1 ? "active" : "completed") : "" %>">
                                <div class="timeline-node">1</div>
                                <div class="timeline-label">Submitted</div>
                                <div class="small text-muted" style="font-size: 0.7rem;"><%= complaint.getFormattedCreatedDate() %></div>
                            </div>

                            <!-- Step 2: Assigned -->
                            <div class="timeline-step <%= stage >= 2 ? (stage == 2 ? "active" : "completed") : "" %>">
                                <div class="timeline-node">2</div>
                                <div class="timeline-label">Assigned</div>
                                <div class="small text-muted" style="font-size: 0.7rem;">
                                    <%= complaint.getAssignedDepartment() != null ? complaint.getAssignedDepartment() : "Awaiting" %>
                                </div>
                            </div>

                            <!-- Step 3: In Progress -->
                            <div class="timeline-step <%= stage >= 3 ? (stage == 3 ? "active" : "completed") : "" %>">
                                <div class="timeline-node">3</div>
                                <div class="timeline-label">In Progress</div>
                                <div class="small text-muted" style="font-size: 0.7rem;">Active Repair</div>
                            </div>

                            <!-- Step 4: Resolved -->
                            <div class="timeline-step <%= stage >= 4 ? (stage == 4 ? "active" : "completed") : "" %>">
                                <div class="timeline-node">4</div>
                                <div class="timeline-label">Resolved</div>
                                <div class="small text-muted" style="font-size: 0.7rem;">
                                    <%= complaint.getResolvedAt() != null ? complaint.getFormattedResolvedDate() : "Pending" %>
                                </div>
                            </div>

                            <!-- Step 5: Closed -->
                            <div class="timeline-step <%= stage >= 5 ? "completed" : "" %>">
                                <div class="timeline-node">5</div>
                                <div class="timeline-label">Closed</div>
                                <div class="small text-muted" style="font-size: 0.7rem;">Verified</div>
                            </div>

                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Details Cards Grid -->
            <div class="row g-4">
                
                <!-- Left: Full Issue Information -->
                <div class="col-lg-8">
                    <div class="portal-card h-100">
                        <h2 class="h6 fw-bold border-bottom pb-2 mb-3">Issue Specifications</h2>
                        
                        <div class="mb-3">
                            <span class="text-muted small d-block">Description:</span>
                            <div class="p-3 bg-light rounded-3 mt-1 text-dark" style="white-space: pre-wrap; line-height: 1.6;">
<%= complaint.getDescription() %>
                            </div>
                        </div>

                        <div class="row g-3">
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Complaint Category:</span>
                                <strong class="fs-6"><%= complaint.getCategory() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Campus Location:</span>
                                <strong class="fs-6"><%= complaint.getBlock() %> &bull; <%= complaint.getLocationName() %></strong>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Submitted By:</span>
                                <div><%= student.getFullName() %> (<%= student.getRollNumber() %>)</div>
                            </div>
                            <div class="col-sm-6">
                                <span class="text-muted small d-block">Submission Timestamp:</span>
                                <div><%= complaint.getFormattedCreatedDate() %></div>
                            </div>
                        </div>

                        <!-- Administration Remarks Box -->
                        <div class="mt-4 pt-3 border-top">
                            <h3 class="h6 fw-bold mb-2">Administrative &amp; Technician Remarks</h3>
                            <% if (complaint.getAdminRemarks() != null && !complaint.getAdminRemarks().trim().isEmpty()) { %>
                                <div class="p-3 bg-primary-subtle border border-primary-subtle rounded-3 text-dark">
                                    <%= complaint.getAdminRemarks() %>
                                </div>
                            <% } else { %>
                                <p class="text-muted small mb-0 fst-italic">No administrative remarks entered yet.</p>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Right: Assignment & Feedback -->
                <div class="col-lg-4">
                    
                    <!-- Assigned Staff Card -->
                    <div class="portal-card mb-4">
                        <h2 class="h6 fw-bold border-bottom pb-2 mb-3">Assigned Staff / Department</h2>
                        <% if (complaint.getAssignedStaffName() != null) { %>
                            <div class="d-flex align-items-center gap-3">
                                <div class="stat-icon stat-icon-purple">🛠️</div>
                                <div>
                                    <div class="fw-bold"><%= complaint.getAssignedStaffName() %></div>
                                    <div class="text-muted small"><%= complaint.getAssignedDepartment() %></div>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="text-muted small">
                                <em>Awaiting department assignment by administrator.</em>
                            </div>
                        <% } %>
                    </div>

                    <!-- Post-Resolution Feedback Card -->
                    <div class="portal-card" id="feedbackForm">
                        <h2 class="h6 fw-bold border-bottom pb-2 mb-3">Resolution Feedback</h2>
                        
                        <% if ("RESOLVED".equalsIgnoreCase(complaint.getStatus()) || "CLOSED".equalsIgnoreCase(complaint.getStatus())) { %>
                            
                            <% if (hasFeedback) { %>
                                <div class="alert alert-success mb-0 small">
                                    <strong>Feedback Submitted!</strong><br>
                                    Thank you for rating the service. Your review helps maintain high campus standards.
                                </div>
                            <% } else { %>
                                <form action="<%= request.getContextPath() %>/feedback" method="POST">
                                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">
                                    
                                    <div class="mb-3 text-center">
                                        <label class="form-label small fw-bold d-block">Rate Resolution Quality (1 to 5 Stars)</label>
                                        <div class="star-rating">
                                            <input type="radio" id="star5" name="rating" value="5" checked><label for="star5" title="5 stars">★</label>
                                            <input type="radio" id="star4" name="rating" value="4"><label for="star4" title="4 stars">★</label>
                                            <input type="radio" id="star3" name="rating" value="3"><label for="star3" title="3 stars">★</label>
                                            <input type="radio" id="star2" name="rating" value="2"><label for="star2" title="2 stars">★</label>
                                            <input type="radio" id="star1" name="rating" value="1"><label for="star1" title="1 star">★</label>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="feedbackMsg" class="form-label small fw-bold">Feedback Message *</label>
                                        <textarea class="form-control form-control-sm" id="feedbackMsg" name="message" rows="3" 
                                                  placeholder="e.g. Complaint was resolved quickly and effectively." required></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-warning btn-sm w-100 fw-semibold text-dark">
                                        Submit Feedback
                                    </button>
                                </form>
                            <% } %>

                        <% } else { %>
                            <div class="text-muted small">
                                <em>Feedback can be submitted once this ticket reaches <strong>RESOLVED</strong> status.</em>
                            </div>
                        <% } %>
                    </div>

                </div>

            </div>

        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
