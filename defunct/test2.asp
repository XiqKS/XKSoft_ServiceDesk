<!--#include virtual="/auth/UserManager.Class.asp" -->
<%

dim test: set test = new UserManager
dim tester: set tester = new InputPolicy
dim user: user = "xiqks"
dim pass: pass = "Pass123!"

Response.Write test.UsernameExists(user) & "<br>"
Response.Write tester.CheckUsername(user) & "<br>"
Response.Write tester.CheckPassword(pass) & "<br>"
Response.Write test.AuthenticateUser(user,pass) & "<br>"

%>