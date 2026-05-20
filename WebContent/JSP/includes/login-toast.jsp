<%
    boolean showLoginSuccessToast = "true".equals(request.getParameter("loginSuccess"));
%>
<% if (showLoginSuccessToast) { %>
<div class="floating-toast success" id="loginSuccessToast" role="status" aria-live="polite">
    <span class="toast-icon">OK</span>
    <div class="toast-content">
        <div class="toast-title">Login Successful</div>
        <div class="toast-desc">Welcome back to your dashboard.</div>
    </div>
    <button class="toast-close" type="button" onclick="document.getElementById('loginSuccessToast').remove()" aria-label="Close login notification">&times;</button>
</div>
<script>
    (function () {
        var loginToast = document.getElementById('loginSuccessToast');
        if (!loginToast) {
            return;
        }

        window.setTimeout(function () {
            loginToast.style.opacity = '0';
            window.setTimeout(function () {
                if (loginToast.parentNode) {
                    loginToast.parentNode.removeChild(loginToast);
                }
            }, 500);
        }, 4000);

        if (window.history && window.history.replaceState) {
            var url = new URL(window.location.href);
            url.searchParams.delete('loginSuccess');
            window.history.replaceState({}, document.title, url.pathname + url.search + url.hash);
        }
    })();
</script>
<% } %>
