<%
' Clear variables and redirect the user
Session.Contents.RemoveAll()
Response.Redirect("login.asp")
%>