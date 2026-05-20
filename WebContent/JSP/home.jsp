<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Disha – Nepal Career Intelligence Portal. Discover the right career path using aptitude assessments, real Nepali labor market data, and expert counselor guidance.">
    <title>DISHA — Nepal Career Intelligence Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/home.css">
</head>
<body class="landing-page">

<!-- ═══════════════════════════════════════════════════════
     1. NAVIGATION BAR
     ═══════════════════════════════════════════════════════ -->
<nav class="landing-nav" id="mainNav">
    <div class="nav-container">
        <a href="#" class="nav-logo">
            <div class="nav-logo-icon">D</div>
            DISHA
        </a>

        <div class="nav-links" id="navLinks">
            <a href="#home" class="active">Home</a>
            <a href="#about">About</a>
            <a href="#features">Features</a>
            <a href="#roles">Roles</a>
            <a href="#how-it-works">How It Works</a>
        </div>

        <div class="nav-actions" id="navActions">
            <a href="<%= request.getContextPath() %>/JSP/auth/login.jsp" class="btn-nav-login">Log In</a>
            <a href="<%= request.getContextPath() %>/JSP/auth/register.jsp" class="btn-nav-signup">Sign Up Free</a>
        </div>

        <div class="hamburger" id="hamburger" onclick="toggleMenu()">
            <span></span><span></span><span></span>
        </div>
    </div>
</nav>

<!-- ═══════════════════════════════════════════════════════
     2. HERO SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="hero" id="home">
    <div class="hero-container">
        <div class="hero-content">
            <div class="hero-badge">🇳🇵 Built for Nepali Students</div>
            <h1 class="hero-title">
                Find the Right <span class="highlight">Career Path</span> with Real Nepal Market Data
            </h1>
            <p class="hero-desc">
                Disha is Nepal's first AI-powered career intelligence platform that matches your aptitude, interests, and budget with real labor market opportunities — helping you make smarter career decisions.
            </p>
            <div class="hero-buttons">
                <a href="<%= request.getContextPath() %>/JSP/auth/register.jsp" class="btn-hero-primary">
                    Get Started Free →
                </a>
                <a href="<%= request.getContextPath() %>/JSP/auth/login.jsp" class="btn-hero-secondary">
                    📝 Take Career Test
                </a>
            </div>
            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="hero-stat-value">15+</span>
                    <span class="hero-stat-label">Career Paths</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">1000+</span>
                    <span class="hero-stat-label">Students Guided</span>
                </div>
                <div class="hero-stat">
                    <span class="hero-stat-value">5+</span>
                    <span class="hero-stat-label">Colleges Listed</span>
                </div>
            </div>
        </div>

        <div class="hero-visual">
            <div class="hero-illustration">
                <div class="hero-illustration-content">
                    <div class="ill-icon">🎯</div>
                    <p>Career Intelligence</p>
                </div>
            </div>
            <div class="float-card" style="top: 15%; right: -10%;">📊 Aptitude Score: 87%</div>
            <div class="float-card" style="bottom: 25%; left: -5%;">💼 Best Match: Engineer</div>
            <div class="float-card" style="bottom: 8%; right: 10%;">🏫 5 Colleges Found</div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     3. ABOUT DISHA SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section section-light" id="about">
    <div class="section-container">
        <div class="about-grid">
            <div class="about-visual">
                <div class="about-visual-inner">
                    <div class="av-icon">🇳🇵</div>
                    <p>Made in Nepal, for Nepal</p>
                </div>
            </div>
            <div class="about-text">
                <span class="section-tag">About Disha</span>
                <h3>Empowering Nepal's Youth to Choose Careers Based on Data, Not Guesswork</h3>
                <p>
                    Every year, thousands of Nepali students make life-changing career decisions based on peer pressure, family expectations, or outdated information. Many end up in careers that don't match their skills or market realities.
                </p>
                <p>
                    <strong>Disha</strong> (meaning "direction" in Nepali) was created to solve this problem. By combining scientific aptitude assessments with real Nepal labor market data, we help students discover careers that truly fit their potential.
                </p>
                <div class="about-highlights">
                    <div class="about-highlight">
                        <span class="about-highlight-icon">🎯</span>
                        <span class="about-highlight-text">Data-Driven Career Matching</span>
                    </div>
                    <div class="about-highlight">
                        <span class="about-highlight-icon">📊</span>
                        <span class="about-highlight-text">Real Nepal Salary Data</span>
                    </div>
                    <div class="about-highlight">
                        <span class="about-highlight-icon">🏫</span>
                        <span class="about-highlight-text">College Recommendations</span>
                    </div>
                    <div class="about-highlight">
                        <span class="about-highlight-icon">🧑‍💼</span>
                        <span class="about-highlight-text">Expert Counselor Access</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     4. FEATURES SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section" id="features">
    <div class="section-container">
        <div class="section-header">
            <span class="section-tag">Features</span>
            <h2 class="section-title">Everything You Need for Smarter Career Decisions</h2>
            <p class="section-subtitle">From aptitude testing to real salary insights — Disha gives you the complete career intelligence toolkit.</p>
        </div>

        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">📝</div>
                <h4>Aptitude Assessment</h4>
                <p>Take scientifically designed aptitude tests to discover your cognitive strengths and ideal career clusters.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🎯</div>
                <h4>Career Recommendations</h4>
                <p>Get personalized career matches based on your aptitude profile, interests, and Nepal's market demand.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">💰</div>
                <h4>Salary Insights</h4>
                <p>Access up-to-date salary ranges for various careers in Nepal's job market to plan your financial future.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🗺️</div>
                <h4>Skill Roadmaps</h4>
                <p>Follow step-by-step skill development paths to prepare for your chosen career with confidence.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🏫</div>
                <h4>Budget vs Degree Planning</h4>
                <p>Compare college fees, degree options, and scholarship possibilities that fit your budget.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📄</div>
                <h4>Parent Reports</h4>
                <p>Parents get detailed progress reports and career recommendations for their children's future planning.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📈</div>
                <h4>Consultant Analytics</h4>
                <p>Career counselors get powerful tools to track student progress, risk alerts, and performance dashboards.</p>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     5. USER ROLES SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section section-light" id="roles">
    <div class="section-container">
        <div class="section-header">
            <span class="section-tag">User Roles</span>
            <h2 class="section-title">Designed for Everyone in the Career Ecosystem</h2>
            <p class="section-subtitle">Each role gets a tailored experience built for their specific needs.</p>
        </div>

        <div class="roles-grid">
            <div class="role-card">
                <div class="role-icon student">🎓</div>
                <h4>Students</h4>
                <p>Discover careers that match your unique strengths and the Nepal job market.</p>
                <ul>
                    <li>Take aptitude assessments</li>
                    <li>Get career matches</li>
                    <li>Track learning progress</li>
                    <li>Browse college options</li>
                </ul>
            </div>
            <div class="role-card">
                <div class="role-icon parent">👨‍👩‍👧</div>
                <h4>Parents</h4>
                <p>Stay informed about your child's career readiness and opportunities ahead.</p>
                <ul>
                    <li>View child's assessment reports</li>
                    <li>Access career suggestions</li>
                    <li>Budget planning tools</li>
                    <li>Track progress over time</li>
                </ul>
            </div>
            <div class="role-card">
                <div class="role-icon counselor">🧑‍💼</div>
                <h4>Counselors</h4>
                <p>Advanced tools for career counselors to guide students effectively at scale.</p>
                <ul>
                    <li>Manage student portfolio</li>
                    <li>Analytics dashboard</li>
                    <li>Risk flagging system</li>
                    <li>Counseling reports</li>
                </ul>
            </div>
            <div class="role-card">
                <div class="role-icon admin">⚙️</div>
                <h4>Administrators</h4>
                <p>Full platform management with comprehensive control and analytics.</p>
                <ul>
                    <li>User management (CRUD)</li>
                    <li>Career & college data</li>
                    <li>Platform statistics</li>
                    <li>System reports</li>
                </ul>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     6. HOW IT WORKS SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section" id="how-it-works">
    <div class="section-container">
        <div class="section-header">
            <span class="section-tag">How It Works</span>
            <h2 class="section-title">Your Career Journey in 4 Simple Steps</h2>
            <p class="section-subtitle">From sign-up to your personalized career plan — it takes just minutes.</p>
        </div>

        <div class="steps-grid">
            <div class="step-card">
                <div class="step-number">1</div>
                <div class="step-icon">📋</div>
                <h4>Create Your Account</h4>
                <p>Sign up as a student, parent, or counselor. It's free and takes under a minute.</p>
            </div>
            <div class="step-card">
                <div class="step-number">2</div>
                <div class="step-icon">📝</div>
                <h4>Take the Aptitude Test</h4>
                <p>Complete our scientifically-designed assessment to map your cognitive strengths.</p>
            </div>
            <div class="step-card">
                <div class="step-number">3</div>
                <div class="step-icon">🎯</div>
                <h4>Get Career Matches</h4>
                <p>Receive personalized career recommendations powered by Nepal market data.</p>
            </div>
            <div class="step-card">
                <div class="step-number">4</div>
                <div class="step-icon">🚀</div>
                <h4>Plan Your Future</h4>
                <p>Explore colleges, compare budgets, and build your career roadmap with confidence.</p>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     7. SAMPLE CAREER PATHS SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section section-light" id="career-paths">
    <div class="section-container">
        <div class="section-header">
            <span class="section-tag">Sample Paths</span>
            <h2 class="section-title">Explore High-Demand Careers in Nepal</h2>
            <p class="section-subtitle">Real examples of how Disha maps your skills to actionable career roadmaps.</p>
        </div>

        <div class="career-samples-grid">
            <div class="career-sample-card">
                <span class="career-sample-badge c-badge-tech">Technology</span>
                <h4>Web Development</h4>
                <p>Build the digital infrastructure of tomorrow. High demand in Nepal's growing IT sector with remote work opportunities.</p>
                <div class="career-roadmap-steps">
                    <div class="career-roadmap-step active">Learn HTML, CSS & JavaScript</div>
                    <div class="career-roadmap-step">Master a Framework (React/Vue)</div>
                    <div class="career-roadmap-step">Build Full-Stack Projects</div>
                    <div class="career-roadmap-step">Land Junior Dev Role</div>
                </div>
            </div>

            <div class="career-sample-card">
                <span class="career-sample-badge c-badge-business">Business</span>
                <h4>Digital Marketing</h4>
                <p>Help businesses grow their online presence. Perfect for creative thinkers with analytical skills.</p>
                <div class="career-roadmap-steps">
                    <div class="career-roadmap-step active">Understand SEO & Content</div>
                    <div class="career-roadmap-step">Master Paid Ads (Google/Meta)</div>
                    <div class="career-roadmap-step">Learn Data Analytics</div>
                    <div class="career-roadmap-step">Become Marketing Specialist</div>
                </div>
            </div>

            <div class="career-sample-card">
                <span class="career-sample-badge c-badge-tech">Design</span>
                <h4>UI/UX Design</h4>
                <p>Design beautiful, functional user experiences. Blends psychology, creativity, and technology.</p>
                <div class="career-roadmap-steps">
                    <div class="career-roadmap-step active">Learn Design Principles</div>
                    <div class="career-roadmap-step">Master Figma/Adobe XD</div>
                    <div class="career-roadmap-step">Build a Portfolio</div>
                    <div class="career-roadmap-step">Start as Visual Designer</div>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="section section-dark">
    <div class="section-container">
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-value">15<span class="plus">+</span></div>
                <div class="stat-label">Career Paths Mapped</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">1000<span class="plus">+</span></div>
                <div class="stat-label">Students Guided</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">5<span class="plus">+</span></div>
                <div class="stat-label">Partner Colleges</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">4</div>
                <div class="stat-label">User Roles Supported</div>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     8. TESTIMONIALS SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section section-light" id="testimonials">
    <div class="section-container">
        <div class="section-header">
            <span class="section-tag">Testimonials</span>
            <h2 class="section-title">What Our Users Say</h2>
            <p class="section-subtitle">Real feedback from students, parents, and counselors across Nepal.</p>
        </div>

        <div class="testimonials-grid">
            <div class="testimonial-card">
                <div class="testimonial-stars">★★★★★</div>
                <p class="testimonial-text">
                    "I was confused between engineering and medicine. Disha's aptitude test and salary insights showed me that my analytical skills perfectly match software engineering. Now I'm preparing for BScCSIT at TU with a clear goal!"
                </p>
                <div class="testimonial-author">
                    <div class="testimonial-avatar t-student">RS</div>
                    <div>
                        <div class="testimonial-name">Ram Sharma</div>
                        <div class="testimonial-role">Student, Kathmandu</div>
                    </div>
                </div>
            </div>

            <div class="testimonial-card">
                <div class="testimonial-stars">★★★★★</div>
                <p class="testimonial-text">
                    "As a parent, I was worried about my daughter's career choice. Disha gave me detailed reports showing her strengths, career matches, and even the budget required. It gave our family the confidence to support her path."
                </p>
                <div class="testimonial-author">
                    <div class="testimonial-avatar t-parent">DK</div>
                    <div>
                        <div class="testimonial-name">Durga KC</div>
                        <div class="testimonial-role">Parent, Pokhara</div>
                    </div>
                </div>
            </div>

            <div class="testimonial-card">
                <div class="testimonial-stars">★★★★★</div>
                <p class="testimonial-text">
                    "Managing 200+ students used to be overwhelming. Disha's counselor dashboard gives me analytics, risk alerts, and individual progress tracking. It's completely transformed how I guide students in their career decisions."
                </p>
                <div class="testimonial-author">
                    <div class="testimonial-avatar t-counselor">RH</div>
                    <div>
                        <div class="testimonial-name">Rajesh Hamal</div>
                        <div class="testimonial-role">Career Counselor, Lalitpur</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     10. FAQ SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="section" id="faq">
    <div class="section-container">
        <div class="section-header">
            <span class="section-tag">FAQ</span>
            <h2 class="section-title">Frequently Asked Questions</h2>
            <p class="section-subtitle">Everything you need to know about the Disha platform.</p>
        </div>

        <div class="faq-container">
            <div class="faq-item">
                <button class="faq-question">Who can use Disha? <span class="icon">▼</span></button>
                <div class="faq-answer">
                    <div class="faq-answer-inner">
                        Disha is designed for high school (+2) students preparing for further education or entering the job market, parents wanting to guide their children, career switchers looking for data-driven insights, and career counselors/consultants needing scalable tools for their clients.
                    </div>
                </div>
            </div>
            
            <div class="faq-item">
                <button class="faq-question">Is the assessment free? <span class="icon">▼</span></button>
                <div class="faq-answer">
                    <div class="faq-answer-inner">
                        Yes! Your initial aptitude assessment and basic career matching are completely free. We believe every student should have access to basic career guidance. We do offer premium features for advanced counselor consulting.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">How are careers recommended? <span class="icon">▼</span></button>
                <div class="faq-answer">
                    <div class="faq-answer-inner">
                        Our recommendation engine uses a proprietary algorithm that cross-references your cognitive aptitude scores, personal interests, educational budget constraints, and current labor market demand data in Nepal to suggest the most optimal career paths.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">How long does the assessment take? <span class="icon">▼</span></button>
                <div class="faq-answer">
                    <div class="faq-answer-inner">
                        The core aptitude test takes approximately 20-30 minutes to complete. It evaluates various cognitive domains including numerical, verbal, abstract reasoning, and spatial awareness.
                    </div>
                </div>
            </div>

            <div class="faq-item">
                <button class="faq-question">Can parents monitor progress? <span class="icon">▼</span></button>
                <div class="faq-answer">
                    <div class="faq-answer-inner">
                        Absolutely. Parents can create "Parent" accounts and link them to their child's account to receive automated reports, view assessment results, and explore budget/college planning tools together.
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     11. CALL TO ACTION SECTION
     ═══════════════════════════════════════════════════════ -->
<section class="cta-section">
    <div class="cta-content">
        <h2>Ready to Discover Your Perfect Career?</h2>
        <p>Join thousands of Nepali students who are making smarter career decisions with data-driven guidance. Start your journey today — it's completely free.</p>
        <div class="cta-buttons">
            <a href="<%= request.getContextPath() %>/JSP/auth/register.jsp" class="btn-cta-white">
                🚀 Create Free Account
            </a>
            <a href="<%= request.getContextPath() %>/JSP/auth/login.jsp" class="btn-cta-outline">
                Already have an account? Log In
            </a>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════════════════════════════
     10. FOOTER
     ═══════════════════════════════════════════════════════ -->
<footer class="landing-footer">
    <div class="footer-grid">
        <div class="footer-brand">
            <h3>🎯 <span class="brand-text">DISHA</span></h3>
            <p>Nepal's first career intelligence platform combining aptitude science with real labor market data to guide students toward their best career path.</p>
            <div class="footer-social">
                <a href="#" title="Facebook">f</a>
                <a href="#" title="Twitter">𝕏</a>
                <a href="#" title="Instagram">📷</a>
                <a href="#" title="LinkedIn">in</a>
            </div>
        </div>

        <div class="footer-col">
            <h4>Platform</h4>
            <ul>
                <li><a href="#features">Features</a></li>
                <li><a href="#how-it-works">How It Works</a></li>
                <li><a href="#roles">User Roles</a></li>
                <li><a href="#testimonials">Testimonials</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Resources</h4>
            <ul>
                <li><a href="#">Career Guide</a></li>
                <li><a href="#">College Directory</a></li>
                <li><a href="#">Salary Database</a></li>
                <li><a href="#">FAQ</a></li>
            </ul>
        </div>

        <div class="footer-col">
            <h4>Contact</h4>
            <ul>
                <li><a href="mailto:info@disha.edu.np">info@disha.edu.np</a></li>
                <li><a href="tel:+97714000000">+977-1-4000000</a></li>
                <li><a href="#">Kathmandu, Nepal</a></li>
                <li><a href="#">Support Center</a></li>
            </ul>
        </div>
    </div>

    <div class="footer-bottom">
        <span>&copy; 2026 Disha Nepal Career Intelligence Portal. All rights reserved.</span>
        <span>Designed for Advanced Programming Coursework</span>
    </div>
</footer>

<!-- ═══════════════════════════════════════════════════════
     MINIMAL JAVASCRIPT
     ═══════════════════════════════════════════════════════ -->
<script>
    // Sticky navbar shadow on scroll
    window.addEventListener('scroll', function() {
        var nav = document.getElementById('mainNav');
        if (window.scrollY > 10) {
            nav.classList.add('scrolled');
        } else {
            nav.classList.remove('scrolled');
        }
    });

    // Mobile hamburger toggle
    function toggleMenu() {
        document.getElementById('navLinks').classList.toggle('mobile-open');
        document.getElementById('navActions').classList.toggle('mobile-open');
    }

    // Close menu when a link is clicked
    document.querySelectorAll('.nav-links a').forEach(function(link) {
        link.addEventListener('click', function() {
            document.getElementById('navLinks').classList.remove('mobile-open');
            document.getElementById('navActions').classList.remove('mobile-open');
        });
    });
    // FAQ Toggle
    document.querySelectorAll('.faq-question').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var item = this.parentElement;
            // close others
            document.querySelectorAll('.faq-item').forEach(function(other) {
                if(other !== item) other.classList.remove('active');
            });
            item.classList.toggle('active');
        });
    });
</script>

</body>
</html>
