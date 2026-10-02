<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.campusconnect.model.Student" %>
<%@ page import="com.campusconnect.model.LostFound" %>
<%@ page import="com.campusconnect.dao.LostFoundDAO" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?portal=student&error=Please+log+in.");
        return;
    }

    LostFoundDAO lfDAO = new LostFoundDAO();
    List<LostFound> lostItems = lfDAO.getItemsByType("LOST");
    List<LostFound> foundItems = lfDAO.getItemsByType("FOUND");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lost &amp; Found — Campus Connect</title>
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
                <div class="text-end d-none d-sm-block">
                    <div class="fw-bold small"><%= student.getFullName() %></div>
                    <div class="text-muted" style="font-size: 0.75rem;"><%= student.getRollNumber() %></div>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger btn-sm">Logout</a>
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
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp">📋 My Complaints</a></li>
                <li><a href="<%= request.getContextPath() %>/student/lost-found.jsp" class="active">🔍 Lost &amp; Found</a></li>
                <li><a href="<%= request.getContextPath() %>/student/my-complaints.jsp?status=RESOLVED">⭐ Give Feedback</a></li>
                <li><a href="<%= request.getContextPath() %>/student/profile.jsp">👤 My Profile</a></li>
                <li class="mt-4"><a href="<%= request.getContextPath() %>/logout" class="text-danger">🚪 Logout</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
                <div>
                    <h1 class="h3 fw-bold mb-1">Campus Lost &amp; Found</h1>
                    <p class="text-muted small mb-0">Report lost personal belongings or help return items found across campus grounds.</p>
                </div>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#reportItemModal">
                    + Report Item
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

            <!-- Navigation Tabs for Lost vs Found -->
            <ul class="nav nav-tabs mb-4" id="lostFoundTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active fw-semibold" id="lost-tab" data-bs-toggle="tab" 
                            data-bs-target="#lostTabPane" type="button" role="tab">
                        🔴 Lost Items (<%= lostItems.size() %>)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link fw-semibold" id="found-tab" data-bs-toggle="tab" 
                            data-bs-target="#foundTabPane" type="button" role="tab">
                        🟢 Found Items (<%= foundItems.size() %>)
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="lostFoundTabsContent">
                
                <!-- 1. LOST ITEMS TAB -->
                <div class="tab-pane fade show active" id="lostTabPane" role="tabpanel">
                    <div class="portal-card p-0 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table cc-table mb-0">
                                <thead>
                                    <tr>
                                        <th>Item Name</th>
                                        <th>Category</th>
                                        <th>Description</th>
                                        <th>Last Seen Location</th>
                                        <th>Date Lost</th>
                                        <th>Status</th>
                                        <th>Contact Details</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (lostItems.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                No lost items currently listed.
                                            </td>
                                        </tr>
                                    <% } else { 
                                        for (LostFound item : lostItems) {
                                    %>
                                        <tr>
                                            <td class="fw-bold"><%= item.getItemName() %></td>
                                            <td><span class="badge bg-light text-dark border"><%= item.getCategory() %></span></td>
                                            <td style="max-width: 250px;"><%= item.getDescription() %></td>
                                            <td>📍 <%= item.getLocation() %></td>
                                            <td><%= item.getFormattedDate() %></td>
                                            <td>
                                                <span class="badge bg-danger-subtle text-danger"><%= item.getStatus() %></span>
                                            </td>
                                            <td class="small"><%= item.getContact() %></td>
                                        </tr>
                                    <%  } 
                                    } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- 2. FOUND ITEMS TAB -->
                <div class="tab-pane fade" id="foundTabPane" role="tabpanel">
                    <div class="portal-card p-0 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table cc-table mb-0">
                                <thead>
                                    <tr>
                                        <th>Item Name</th>
                                        <th>Category</th>
                                        <th>Description</th>
                                        <th>Found Location</th>
                                        <th>Date Found</th>
                                        <th>Status</th>
                                        <th>Contact / Collection</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (foundItems.isEmpty()) { %>
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                No found items currently listed.
                                            </td>
                                        </tr>
                                    <% } else { 
                                        for (LostFound item : foundItems) {
                                    %>
                                        <tr>
                                            <td class="fw-bold"><%= item.getItemName() %></td>
                                            <td><span class="badge bg-light text-dark border"><%= item.getCategory() %></span></td>
                                            <td style="max-width: 250px;"><%= item.getDescription() %></td>
                                            <td>📍 <%= item.getLocation() %></td>
                                            <td><%= item.getFormattedDate() %></td>
                                            <td>
                                                <% if ("CLAIMED".equalsIgnoreCase(item.getStatus())) { %>
                                                    <span class="badge bg-secondary">CLAIMED</span>
                                                <% } else { %>
                                                    <span class="badge bg-success-subtle text-success">FOUND</span>
                                                <% } %>
                                            </td>
                                            <td class="small"><%= item.getContact() %></td>
                                        </tr>
                                    <%  } 
                                    } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

        </main>
    </div>

    <!-- REPORT ITEM MODAL -->
    <div class="modal fade" id="reportItemModal" tabindex="-1" aria-labelledby="reportItemModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="<%= request.getContextPath() %>/lost-found" method="POST">
                    <div class="modal-header">
                        <h2 class="modal-title h5 fw-bold" id="reportItemModalLabel">Report Lost or Found Item</h2>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Report Type *</label>
                            <div class="d-flex gap-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="type" id="typeLost" value="LOST" checked>
                                    <label class="form-check-label fw-semibold text-danger" for="typeLost">
                                        I Lost an Item
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="type" id="typeFound" value="FOUND">
                                    <label class="form-check-label fw-semibold text-success" for="typeFound">
                                        I Found an Item
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="itemName" class="form-label small fw-bold">Item Name *</label>
                            <input type="text" class="form-control" id="itemName" name="itemName" 
                                   placeholder="e.g. Casio Scientific Calculator, Helmet, Keys" required>
                        </div>

                        <div class="mb-3">
                            <label for="category" class="form-label small fw-bold">Category</label>
                            <select class="form-select" id="category" name="category">
                                <option value="Electronics">Electronics / Gadgets</option>
                                <option value="ID Card">ID Card / Documents</option>
                                <option value="Keys">Keys</option>
                                <option value="Vehicle Gear">Helmet / Vehicle Gear</option>
                                <option value="Bags">Bag / Wallet</option>
                                <option value="Books">Books / Notes</option>
                                <option value="Clothing">Clothing / Bottle</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="location" class="form-label small fw-bold">Campus Location *</label>
                            <input type="text" class="form-control" id="location" name="location" 
                                   placeholder="e.g. Lopez Lab, Reading Room, Seminar Hall, Parking" required>
                        </div>

                        <div class="mb-3">
                            <label for="reportDate" class="form-label small fw-bold">Date *</label>
                            <input type="date" class="form-control" id="reportDate" name="reportDate" required>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label small fw-bold">Item Description *</label>
                            <textarea class="form-control" id="description" name="description" rows="3" 
                                      placeholder="Color, brand, identifying marks, stickers, etc." required></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="contact" class="form-label small fw-bold">Your Contact Information *</label>
                            <input type="text" class="form-control" id="contact" name="contact" 
                                   value="<%= student.getEmail() %> | <%= student.getPhone() %>" required>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary btn-sm">Submit Report</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set today's date by default
        document.getElementById('reportDate').valueAsDate = new Date();
    </script>
</body>
</html>
