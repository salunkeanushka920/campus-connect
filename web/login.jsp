<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="d-flex flex-column justify-content-between min-vh-100">

    <!-- Top Header -->
    <header class="cc-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <a href="<%= request.getContextPath() %>/" class="btn btn-outline-secondary btn-sm">Home</a>
        </div>
    </header>

    <main class="container py-5 my-auto">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">

                <%-- Feedback Alerts --%>
                <%
                    String error = request.getParameter("error");
                    String success = request.getParameter("success");
                    String logout = request.getParameter("logout");
                    String portalParam = request.getParameter("portal");
                    boolean isAdminPortal = "admin".equalsIgnoreCase(portalParam);
                %>

                <% if (error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Login Failed:</strong> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if (success != null && !success.isEmpty()) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if ("true".equalsIgnoreCase(logout)) { %>
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        You have been securely logged out.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Card Container with Portal Tabs -->
                <div class="portal-card p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="stat-icon stat-icon-blue mx-auto mb-3" style="width: 54px; height: 54px; font-size: 1.5rem;">
                            🏛️
                        </div>
                        <h2 class="h4 fw-bold mb-1">Campus Connect</h2>
                        <p class="text-muted small">Authorized College Portal Sign In</p>
                    </div>

                    <!-- Portal Selector Nav Tabs -->
                    <ul class="nav nav-pills nav-fill mb-4 p-1 bg-light rounded-3" id="portalTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link <%= !isAdminPortal ? "active" : "" %> fw-semibold" 
                                    id="student-tab" data-bs-toggle="pill" data-bs-target="#studentPortal" 
                                    type="button" role="tab">Student Portal</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link <%= isAdminPortal ? "active" : "" %> fw-semibold" 
                                    id="admin-tab" data-bs-toggle="pill" data-bs-target="#adminPortal" 
                                    type="button" role="tab">Staff &amp; Admin</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="portalTabsContent">

                        <!-- 1. STUDENT LOGIN FORM -->
                        <div class="tab-pane fade <%= !isAdminPortal ? "show active" : "" %>" id="studentPortal" role="tabpanel">
                            <form action="<%= request.getContextPath() %>/student-login" method="POST">
                                <div class="mb-3">
                                    <label for="studentRollNumber" class="form-label small fw-bold">Student Roll Number</label>
                                    <input type="text" class="form-control py-2" id="studentRollNumber" name="rollNumber" 
                                           placeholder="e.g. 243-02-A-0007" required autocomplete="username">
                                </div>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <label for="studentPassword" class="form-label small fw-bold mb-0">Password</label>
                                    </div>
                                    <input type="password" class="form-control py-2" id="studentPassword" name="password" 
                                           placeholder="Enter your student password" required autocomplete="current-password">
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="rememberMe">
                                        <label class="form-check-label small text-muted" for="rememberMe">
                                            Remember roll number
                                        </label>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold mb-3">
                                    Sign In as Student
                                </button>

                                <div class="text-center small text-muted">
                                    First time user? <a href="<%= request.getContextPath() %>/register.jsp" class="fw-semibold text-primary">Register Here</a>
                                </div>
                            </form>
                        </div>

                        <!-- 2. ADMIN LOGIN FORM -->
                        <div class="tab-pane fade <%= isAdminPortal ? "show active" : "" %>" id="adminPortal" role="tabpanel">
                            <form action="<%= request.getContextPath() %>/admin-login" method="POST">
                                <div class="mb-3">
                                    <label for="adminUsername" class="form-label small fw-bold">Administrator Username</label>
                                    <input type="text" class="form-control py-2" id="adminUsername" name="username" 
                                           placeholder="e.g. admin" required autocomplete="username">
                                </div>
                                <div class="mb-3">
                                    <label for="adminPassword" class="form-label small fw-bold">Password</label>
                                    <input type="password" class="form-control py-2" id="adminPassword" name="password" 
                                           placeholder="Enter administrator password" required autocomplete="current-password">
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="rememberAdmin">
                                        <label class="form-check-label small text-muted" for="rememberAdmin">
                                            Keep me signed in
                                        </label>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-dark w-100 py-2 fw-semibold mb-3">
                                    Sign In as Administrator
                                </button>

                                <div class="p-2 bg-light rounded text-center small text-muted">
                                    Administrator and department credentials are issued by the College IT Office.
                                </div>
                            </form>
                        </div>

                    </div>
                </div>

            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="cc-footer text-center">
        <div class="container">
            <span class="small text-muted">&copy; 2026 Campus Connect &bull; Official College Operations Portal</span>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
