<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Connect — College Complaint &amp; Maintenance Management Portal</title>
    <meta name="description" content="One simple college portal to report, track, and resolve campus maintenance and academic issues.">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Top Navigation -->
    <header class="cc-navbar">
        <div class="container d-flex justify-content-between align-items-center">
            <a href="<%= request.getContextPath() %>/" class="cc-brand">
                <span class="cc-brand-badge">CC</span>
                <span>Campus Connect</span>
            </a>
            <div class="d-flex gap-2">
                <a href="<%= request.getContextPath() %>/login.jsp?portal=student" class="btn btn-outline-primary btn-sm px-3">Student Portal</a>
                <a href="<%= request.getContextPath() %>/login.jsp?portal=admin" class="btn btn-primary btn-sm px-3">Admin Portal</a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <main>
        <section class="hero-section">
            <div class="container">
                <div class="badge bg-primary-subtle text-primary border border-primary-subtle mb-3 px-3 py-2 rounded-pill fw-semibold">
                    <span class="me-1">🏛️</span> Official College Campus Operations &amp; Support Portal
                </div>
                <h1 class="hero-title">Connecting Students. Improving Campus.</h1>
                <p class="hero-subtitle">
                    One simple web portal to report campus maintenance issues, track real-time resolution status, locate lost belongings, and provide feedback directly to college authorities.
                </p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="<%= request.getContextPath() %>/login.jsp?portal=student" class="btn btn-primary hero-btn shadow-sm">
                        Access Student Portal
                    </a>
                    <a href="<%= request.getContextPath() %>/login.jsp?portal=admin" class="btn btn-outline-dark hero-btn">
                        Administrator Access
                    </a>
                </div>
            </div>
        </section>

        <!-- How It Works Section -->
        <section class="py-5 bg-white border-bottom">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="fw-bold">How It Works</h2>
                    <p class="text-muted">A clear, transparent 3-step resolution cycle for all college issues.</p>
                </div>
                <div class="row g-4 text-center">
                    <div class="col-md-4">
                        <div class="p-4 rounded-3 border bg-light h-100">
                            <div class="fs-1 text-primary mb-3">1</div>
                            <h4 class="fw-bold fs-5">1. Report</h4>
                            <p class="text-muted small">Submit maintenance, electrical, AC, lab, or cleanliness problems specifying the exact campus room and block.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-4 rounded-3 border bg-light h-100">
                            <div class="fs-1 text-primary mb-3">2</div>
                            <h4 class="fw-bold fs-5">2. Track</h4>
                            <p class="text-muted small">Monitor real-time progress on a 5-step visual timeline from review to technician dispatch and active repairs.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-4 rounded-3 border bg-light h-100">
                            <div class="fs-1 text-primary mb-3">3</div>
                            <h4 class="fw-bold fs-5">3. Resolve &amp; Review</h4>
                            <p class="text-muted small">Receive administrative resolution notes and rate the quality of service with 1–5 star student feedback.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Core Features Grid -->
        <section class="py-5">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="fw-bold">Core Portal Capabilities</h2>
                    <p class="text-muted">Designed specifically to meet college infrastructure needs.</p>
                </div>
                <div class="row g-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="feature-box">
                            <div class="feature-icon">📋</div>
                            <h3 class="fs-6 fw-bold">Complaint Tracking</h3>
                            <p class="text-muted small mb-0">Categorized issue logging for 16 campus categories with priority indicators and tracking IDs.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="feature-box">
                            <div class="feature-icon">🔍</div>
                            <h3 class="fs-6 fw-bold">Lost &amp; Found</h3>
                            <p class="text-muted small mb-0">Central bulletin for reporting lost helmets, IDs, keys, calculators, or bags found on campus grounds.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="feature-box">
                            <div class="feature-icon">⭐</div>
                            <h3 class="fs-6 fw-bold">Student Feedback</h3>
                            <p class="text-muted small mb-0">Transparent post-resolution rating system to maintain accountability and repair quality.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="feature-box">
                            <div class="feature-icon">🛠️</div>
                            <h3 class="fs-6 fw-bold">Staff Assignment</h3>
                            <p class="text-muted small mb-0">Direct routing to Electrical, IT, Housekeeping, and Carpentry maintenance personnel.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="cc-footer text-center">
        <div class="container">
            <p class="mb-1 fw-semibold text-dark">Campus Connect &bull; College Facility Management &amp; Support</p>
            <p class="mb-0 text-muted small">&copy; 2026 Campus Connect. All rights reserved. &bull; Campus Administration &amp; Maintenance Cell</p>
        </div>
    </footer>

    <script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
