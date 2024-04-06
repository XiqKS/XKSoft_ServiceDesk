<%
Class InputPolicy
    Public Function CheckUsername(username)
        CheckUsername = RegExTest(username, "^[a-zA-Z0-9_-]{3,20}$")
    End Function

    Public Function CheckPassword(password)
        CheckPassword = RegExTest(password, "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
    End Function

    Private Function RegExTest(inputString, pattern)
        Dim regex
        Set regex = New RegExp
        regex.Pattern = pattern
        RegExTest = regex.Test(inputString)
        Set regex = Nothing
    End Function
End Class
%>
