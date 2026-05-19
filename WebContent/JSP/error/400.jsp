<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Bad Request - DISHA</title>
</head>
<body>
<h2>Bad Request</h2>
<p>${empty errorMessage ? 'The request could not be processed.' : errorMessage}</p>
</body>
</html>
