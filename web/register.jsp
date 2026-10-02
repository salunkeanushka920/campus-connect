<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration — Campus Connect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Navigation Header -->
    <header class="cc-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <a href="<%= request.getContextPath() %>/login.jsp?portal=student" class="btn btn-outline-primary btn-sm">Student Login</a>
        </div>
    </header>

    <main class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-7">

                <%-- Error Notification --%>
                <%
                    String error = (String) request.getAttribute("error");
                    if (error == null) {
                        error = request.getParameter("error");
                    }
                %>
                <% if (error != null && !error.isEmpty()) { %>
                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                        <strong>Registration Error:</strong> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="portal-card p-4 p-md-5">
                    <div class="mb-4 text-center">
                        <span class="badge bg-primary-subtle text-primary mb-2 px-3 py-1">Student Portal</span>
                        <h1 class="h3 fw-bold">Student Registration</h1>
                        <p class="text-muted small">Create your student account using your college roll number</p>
                    </div>

                    <form id="registerForm" action="<%= request.getContextPath() %>/register" method="POST">
                        <div class="row g-3">
                            <div class="col-md-12">
                                <label for="fullName" class="form-label small fw-bold">Full Name *</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       placeholder="e.g. Anushka Ranjan" required
                                       value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>">
                            </div>

                            <div class="col-md-6">
                                <label for="rollNumber" class="form-label small fw-bold">Roll Number * <span class="text-muted fw-normal">(Unique ID)</span></label>
                                <input type="text" class="form-control" id="rollNumber" name="rollNumber" 
                                       placeholder="e.g. 243-02-A-0007" required
                                       value="<%= request.getAttribute("rollNumber") != null ? request.getAttribute("rollNumber") : "" %>">
                                <div class="form-text small">Your unique college roll number will be used for login.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label small fw-bold">Email Address *</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="e.g. anushka.ranjan@college.edu" required
                                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label small fw-bold">Phone Number *</label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       placeholder="e.g. 9876543210" required
                                       value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                            </div>

                            <div class="col-md-6">
                                <label for="course" class="form-label small fw-bold">Course *</label>
                                <select class="form-select" id="course" name="course" required>
                                    <option value="B.Sc.IT" selected>B.Sc.IT (Information Technology)</option>
                                    <option value="B.Sc.CS">B.Sc.CS (Computer Science)</option>
                                    <option value="BCA">BCA (Computer Applications)</option>
                                    <option value="B.Sc">B.Sc (General Science)</option>
                                    <option value="B.Com">B.Com / BMS</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="year" class="form-label small fw-bold">Academic Year *</label>
                                <select class="form-select" id="year" name="year" required>
                                    <option value="FY">First Year (FY)</option>
                                    <option value="SY" selected>Second Year (SY)</option>
                                    <option value="TY">Third Year (TY)</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="division" class="form-label small fw-bold">Division *</label>
                                <select class="form-select" id="division" name="division" required>
                                    <option value="A" selected>Division A</option>
                                    <option value="B">Division B</option>
                                    <option value="C">Division C</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="regPassword" class="form-label small fw-bold">Password *</label>
                                <input type="password" class="form-control" id="regPassword" name="password" 
                                       placeholder="Minimum 6 characters" required minlength="6">
                            </div>

                            <div class="col-md-6">
                                <label for="regConfirmPassword" class="form-label small fw-bold">Confirm Password *</label>
                                <input type="password" class="form-control" id="regConfirmPassword" name="confirmPassword" 
                                       placeholder="Re-enter password" required minlength="6">
                            </div>

                            <div class="col-12 mt-4">
                                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                                    Register Account
                                </button>
                            </div>
                        </div>
                    </form>

                    <div class="mt-4 text-center small text-muted">
                        Already have an account? <a href="<%= request.getContextPath() %>/login.jsp?portal=student" class="text-primary fw-semibold">Log in here</a>
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
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
</body>
</html>
