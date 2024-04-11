<%
' Class to validate user input
Class InputPolicy
    ' Checks the submitted username against the username regex pattern
    Public Function CheckUsername(username)
        CheckUsername = RegExTest(username, "^[a-zA-Z0-9_-]{3,20}$")
    End Function

    ' Checks the submitted password against the password regex pattern
    Public Function CheckPassword(password)
        CheckPassword = RegExTest(password, "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
    End Function

    ' Making the regex testing a function for resource management
    Private Function RegExTest(inputString, pattern)
        Dim regex
        Set regex = New RegExp
        regex.Pattern = pattern
        RegExTest = regex.Test(inputString)
        Set regex = Nothing
    End Function
End Class
%>
