<%
    Response.AddHeader "Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self';"
    Response.AddHeader "X-Content-Type-Options", "nosniff"
    Response.AddHeader "X-Frame-Options", "DENY"
    Response.AddHeader "X-XSS-Protection", "1; mode=block"
    Response.AddHeader "Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload"
    Response.AddHeader "Referrer-Policy", "strict-origin-when-cross-origin"
%>