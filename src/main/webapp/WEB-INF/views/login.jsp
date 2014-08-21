<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/7/15
  Time: 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录</title>
</head>
<script type="text/javascript" src="uploadify/jquery.min.js"></script>
<script>
    var flag1 = false;
    var flag2 = false;
    String.prototype.trim = function () {
        return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    }
    function checkUserName(){
        flag1 = false
        var name = $('#username').val();
        if (name == null || name.trim() == "") {
            $('#usernamemsg').html('<font color="red">用户名不能为空</font>');
        }else{
            $('#usernamemsg').html('');
            flag1 = true;
        }
    }
    function checkPasswd(){
        flag2 = false;
        var passwd = $('#passwd').val();
        if (passwd == null || passwd.trim() == "") {
            $('#passwdmsg').html('<font color="red">密码不能为空</font>');
        }else{
            $('#passwdmsg').html('');
            flag2 = true;
        }
    }
    function goSubmit() {
        if (flag1 && flag2) {
            $.ajax({
                url: "/Origami/checkLogin",
                type: "post",
                data: {userName: $("#username").val(), passwd: $("#passwd").val()},
                dataType: "json",
                complete: function (data) {
                    if (data.responseText == 'fail') {
                        $('#msg').html('<font color="red">用户名或密码错误</font>');
                    } else if(data.responseText == 'error') {
                        $('#msg').html('<font color="red">系统错误请重新登录</font>');
                    }else{

                        window.location.href="index"
                    }
                }
            })
        }
    }
</script>
<body>
<span id="msg"></span>
<form name="loginForm" method="post" action="login">
<label>用户名:</label><input type="text" name="usernmae" id="username" onblur="checkUserName()"/><span id="usernamemsg"></span><br>
<label>密码:</label><input type="password" name="passwd" id="passwd" onblur="checkPasswd()" /><span id="passwdmsg"></span><br>
<input type="button" value="登录" onclick="goSubmit()"/><a href="registerIndex">注册</a>
</form>
</body>
</html>
