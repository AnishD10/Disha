<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>

<div class="dashboard-layout">
    
    <!-- Sidebar Include -->
    <jsp:include page="../includes/sidebar.jsp" />
    
    <div class="main-content">
        <!-- Header Include -->
        <jsp:include page="../includes/dashboard-header.jsp" />
        
        <div class="dashboard-body">
            
            <div class="page-header" style="margin-bottom: 2rem;">
                <h1 style="color: var(--color-primary); font-size: 2rem;">Welcome back, <%= currentUser.getFullName() %>!</h1>
                <p style="color: var(--color-text-muted);">Let's continue shaping your future today.</p>
            </div>
            
            <!-- Quick Statistics Cards -->
            <div class="grid-cards">
                <div class="card stat-card">
                    <span class="stat-card-title">Completed Assessments</span>
                    <span class="stat-card-value">2 / 5</span>
                    <div style="margin-top: 1rem; background: var(--color-border); height: 6px; border-radius: 3px; overflow: hidden;">
                        <div style="width: 40%; background: var(--color-primary); height: 100%;"></div>
                    </div>
                    <a href="<%= request.getContextPath() %>/assessment/start" class="btn btn-secondary" style="margin-top:1rem;">Start Aptitude Test</a>
                </div>
                
                <div class="card stat-card">
                    <span class="stat-card-title">Top Aptitude</span>
                    <span class="stat-card-value" style="font-size: 1.5rem; color: var(--color-text); margin-top: 0.5rem;">Analytical Thinking</span>
                    <span class="badge badge-success" style="width: fit-content; margin-top: 0.5rem;">92% Match</span>
                </div>
                
                <div class="card stat-card">
                    <span class="stat-card-title">Saved Careers</span>
                    <span class="stat-card-value">4</span>
                    <span style="font-size: 0.85rem; margin-top: 0.5rem; display: inline-block; color: var(--color-text-muted);">Career discovery preview</span>
                </div>
            </div>
            
            <!-- Dashboard Main Split -->
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem;">
                
                <!-- Center Column -->
                <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                    
                    <!-- Career Recommendations -->
                    <div class="card">
                        <h3 style="margin-bottom: 1rem; border-bottom: 1px solid var(--color-border-soft); padding-bottom: 0.5rem;">Top Career Matches</h3>
                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 1rem; border: 1px solid var(--color-border-soft); border-radius: var(--radius-md);">
                                <div style="display: flex; gap: 1rem; align-items: center;">
                                    <div style="font-size: 0.9rem; font-weight: 700; color: var(--color-primary);">IT</div>
                                    <div>
                                        <h4 style="margin:0;">Software Engineer</h4>
                                        <span style="font-size:0.85rem; color:var(--color-text-muted);">High Demand in Nepal</span>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <span class="badge badge-success">95% Match</span>
                                    <div style="font-size:0.85rem; margin-top:5px; font-weight:600;">NPR 80K - 150K / month</div>
                                </div>
                            </div>
                            
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 1rem; border: 1px solid var(--color-border-soft); border-radius: var(--radius-md);">
                                <div style="display: flex; gap: 1rem; align-items: center;">
                                    <div style="font-size: 0.9rem; font-weight: 700; color: var(--color-primary);">DA</div>
                                    <div>
                                        <h4 style="margin:0;">Data Analyst</h4>
                                        <span style="font-size:0.85rem; color:var(--color-text-muted);">Growing Field</span>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <span class="badge badge-success">88% Match</span>
                                    <div style="font-size:0.85rem; margin-top:5px; font-weight:600;">NPR 60K - 120K / month</div>
                                </div>
                            </div>
                            
                        </div>
                        <a href="<%= request.getContextPath() %>/decision/plan" class="btn btn-secondary" style="width: 100%; margin-top: 1rem;">Plan Next Step</a>
                    </div>
                </div>
                
                <!-- Right Column Panel -->
                <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                    
                    <!-- Upcoming Actions -->
                    <div class="card" style="background-color: var(--color-primary); color: var(--color-secondary);">
                        <h3 style="margin-bottom: 1rem; color: var(--color-secondary);">Next Steps</h3>
                        <ul style="list-style: none; display: flex; flex-direction: column; gap: 1rem;">
                            <li style="display: flex; gap: 1rem; align-items: flex-start;">
                                <div style="font-weight: 700;">1</div>
                                <div>
                                    <div style="font-weight: 600;">Complete Personality Test</div>
                                    <div style="font-size: 0.85rem; opacity: 0.9;">Required for better accuracy</div>
                                    <a href="<%= request.getContextPath() %>/assessment/start" style="color: white; text-decoration: underline; font-size: 0.85rem; display: block; margin-top: 5px;">Start test -></a>
                                </div>
                            </li>
                            <li style="display: flex; gap: 1rem; align-items: flex-start;">
                                <div style="font-weight: 700;">2</div>
                                <div>
                                    <div style="font-weight: 600;">Try Decision Planning</div>
                                    <div style="font-size: 0.85rem; opacity: 0.9;">Explore degrees and budget filters</div>
                                    <a href="<%= request.getContextPath() %>/decision/plan" style="color: white; text-decoration: underline; font-size: 0.85rem; display: block; margin-top: 5px;">Start -></a>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <!-- Skill Progress -->
                    <div class="card">
                        <h3 style="margin-bottom: 1rem; border-bottom: 1px solid var(--color-border-soft); padding-bottom: 0.5rem;">Skill Profile</h3>
                        
                        <div class="mb-2">
                            <div style="display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 0.3rem;">
                                <span>Logical Reasoning</span>
                                <span>85%</span>
                            </div>
                            <div style="background: var(--color-border); height: 6px; border-radius: 3px;">
                                <div style="width: 85%; background: var(--color-primary); height: 100%; border-radius: 3px;"></div>
                            </div>
                        </div>
                        
                        <div class="mb-2">
                            <div style="display: flex; justify-content: space-between; font-size: 0.85rem; margin-bottom: 0.3rem;">
                                <span>Communication</span>
                                <span>60%</span>
                            </div>
                            <div style="background: var(--color-border); height: 6px; border-radius: 3px;">
                                <div style="width: 60%; background: var(--color-warning); height: 100%; border-radius: 3px;"></div>
                            </div>
                        </div>
                        
                    </div>
                    
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="../includes/login-toast.jsp" />
</body>
</html>
