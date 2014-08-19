<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/7/13
  Time: 12:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>新用户注册</title>
</head>
<script type="text/javascript" src="uploadify/jquery.min.js"></script>
<script src="uploadify/jquery.uploadify.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="uploadify/uploadify.css">
<link rel="stylesheet" href="jcrop/css/jquery.Jcrop.css">
<script src="jcrop/js/jquery.Jcrop.js"></script>
<script>
    $(function () {
        $("#file_upload_1").uploadify({
            height: 30,
            swf: 'uploadify/uploadify.swf',
            uploader: 'uploadHeadImage',
            width: 120,
            fileObjName: 'uploadfile',
            progressData: 'speed',
            multi: false,
            preventCaching: false,
            auto: false,
            fileTypeDesc: '不超过1M的图片 (*.gif;*.jpg;*.png)',
            fileTypeExts: '*.gif;*.jpg;*.jpeg;*.png',
            cancelImg: 'uploadify/uploadify-cancel.png',//取消图片路径
            fileSizeLimit: 1024,  //允许上传的文件大小(kb)  此为2M
            uploadLimit: 999,
            buttonText: '浏览',
            onUploadError: function (file, errorCode, errorMsg, errorString) {
                alert('图片 ' + file.name + ' 上传失败: ' + errorString);
            },
            onUploadSuccess: function (file, data, response) {
                document.getElementById("titleImg").setAttribute("src", data);
                document.getElementById("preview48").setAttribute("src", data);
                document.getElementById("preview96").setAttribute("src", data);
                document.getElementById("oldpath").setAttribute("value", data);
                document.getElementById("imgtable").style.display = "";
                jQuery(function ($) {
                    // Create variables (in this scope) to hold the API and image size
                    var jcrop_api, boundx, boundy;

                    $("#titleImg").Jcrop({
                        onChange: updatePreview,
                        onSelect: updatePreview,
                        aspectRatio: 1
                    }, function () {
                        // Use the API to get the real image size
                        var bounds = this.getBounds();
                        boundx = bounds[0];
                        boundy = bounds[1];
                        // Store the API in the jcrop_api variable
                        jcrop_api = this;
                        jcrop_api.animateTo([100, 100, 400, 300]);
                    });

                    function updatePreview(c) {
                        if (parseInt(c.w) > 0) {
                            var rx48 = 48 / c.w;
                            var ry48 = 48 / c.h;
                            var rx96 = 96 / c.w;
                            var ry96 = 96 / c.h;

                            $("#preview48").css({
                                width: Math.round(rx48 * boundx) + "px",
                                height: Math.round(ry48 * boundy) + "px",
                                marginLeft: "-" + Math.round(rx48 * c.x) + "px",
                                marginTop: "-" + Math.round(ry48 * c.y) + "px"
                            });
                            $("#preview96").css({
                                width: Math.round(rx96 * boundx) + "px",
                                height: Math.round(ry96 * boundy) + "px",
                                marginLeft: "-" + Math.round(rx96 * c.x) + "px",
                                marginTop: "-" + Math.round(ry96 * c.y) + "px"
                            });
                            $("#x1").val(c.x);
                            $("#y1").val(c.y);
                            $("#w").val(c.w);
                            $("#h").val(c.h);
                        }
                        ;
                    };
                });

            }
        });
    });

    String.prototype.trim = function () {
        return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    }
    var flag1 = false;
    var flag2 = false;
    var flag3 = false;
    var flag4 = false;
    function checkUserName(){
        flag1 = false;
        var name = $('#username').val();
        if(name == null || name.trim() == ""){
            $('#usernamemsg').html('<font color="red">用户名不能为空</font>');
        }else{
            $.ajax({
                url: "/Origami/checkUserName",
                type: "post",
                data: {userName: name},
                dataType: "json",
                complete: function (data) {
                    if(data.responseText == 'no'){
                        $('#usernamemsg').html('<font color="red">用户名已存在</font>');
                    }else if(data.responseText == 'error'){
                        $('#msg').html('<font color="red">系统错误</font>');
                    }else{
                        $('#usernamemsg').html('<img width="16" height="16" src="images/ok.png"/>');
                        flag1 = true;
                    }
                }
            })
        }
    }
    function checkPasswd(){
        flag2 = false;
        var passwd = $('#passwd').val();
        if(passwd == null || passwd.trim() == ""){
            $('#passwdmsg').html('<font color="red">密码不能为空</font>');
        }else if(passwd.length<6 || passwd.length>10){
            $('#passwdmsg').html('<font color="red">密码为6-10位</font>');
        }else{
            $('#passwdmsg').html('<img width="16" height="16" src="images/ok.png"/>');
            flag2 = true;
        }
    }
    function checkConPasswd(){
        flag3 = false;
        var conpasswd = $('#confpasswd').val();
        var passwd = $('#passwd').val();
        if(conpasswd == null || conpasswd.trim() == ""){
            $('#confpasswdmsg').html('<font color="red">请再次输入密码</font>');
        }else if(passwd != conpasswd){
            $('#confpasswdmsg').html('<font color="red">两次输入密码不一致</font>');
        }else{
            $('#confpasswdmsg').html('<img width="16" height="16" src="images/ok.png"/>');
            flag3 = true;
        }
    }
    function checkEmail(){
        flag4 = false;
        var email = $('#email').val();
        if(email == null || email.trim() == ""){
            $('#emailmsg').html('<font color="red">请输入邮箱</font>');
        }else{
            $.ajax({
                url: "/Origami/checkEmail",
                type: "post",
                data: {email: $("#email").val()},
                dataType: "json",
                complete: function (data) {
                    if (data.responseText == 'no') {
                        $('#emailmsg').html('<font color="red">邮箱已存在</font>');
                    } else if (data.responseText == 'error') {
                        $('#msg').html('<font color="red">系统错误</font>');
                    } else {
                        $('#emailmsg').html('<img width="16" height="16" src="images/ok.png"/>');
                        flag4 = true;
                    }
                }
            })

        }
    }

    function thumbnailimage() {
        $.ajax({
            url: "/Origami/thumbnailHeadImage",
            type: "post",
            data: {x1: $("#x1").val(), y1: $("#y1").val(), w: $("#w").val(), h: $("#h").val(), oldpath: $("#oldpath").val()},
            dataType: "json",
            complete: function (data) {
                alert("头像保存成功");
                $("#imgsrc").val(data.responseText);
            }
        })
    }
    function goSubmit(){
        if($("#imgsrc").val()==""){
            $("#imgsrc").val("/Origami/upload/head/defaulthead.png")
        }
        if(flag1 && flag2 && flag3 && flag4){
            $.ajax({
                url: "/Origami/register",
                type: "post",
                data: {userName: $("#username").val(), passwd: $("#passwd").val(), email: $("#email").val(),imagesrc: $("#imgsrc").val()},
                dataType: "json",
                complete: function (data) {
                    if (data.responseText == 'succ') {
                        $('#msg').html('<font color="green">注册成功,<a href="login">请登录</a></font>');
                        flag1 = false;
                        flag2 = false;
                        flag3 = false;
                        flag4 = false;
                    } else {
                        $('#usernamemsg').html('<font color="red">注册失败,请重新注册</font>');
                    }
                }
            })
        }
    }
</script>
<body>
<span id="msg"></span>
<form name="registerForm" method="post" action="">
<label>用户名</label><input type="text" id="username" name="username" onblur="checkUserName()"/><span id="usernamemsg"></span></br>
<label>密码</label><input type="password" id="passwd" name="passwd" placeholder="密码为6-10位" onblur="checkPasswd()"/><span id="passwdmsg"
        ></span></br>
<label>确认密码</label><input type="password" id="confpasswd" name="confpasswd" onblur="checkConPasswd()"/><span id="confpasswdmsg"></span></br>
<label>邮箱</label><input type="email" id="email" name="email" onblur="checkEmail()"/><span id="emailmsg" ></span></br>
<input type="hidden" name="imgsrc" id="imgsrc" value=""/>
</form>

<span>请上传头像或者以后再选<input type="file" id="file_upload_1" /></span>
<a href="javascript:$('#file_upload_1').uploadify('upload')">上传</a></br></br>
<table id="imgtable" style="display: none">
    <tr>
        <td>
            <div style="width:96px;height:96px;overflow:hidden;">
                <img src="" id="preview96">
            </div>
            <p>96x96</p>
        </td>
        <td>
            <div style="width:48px;height:48px;overflow:hidden;">
                <img src="" id="preview48">
            </div>
            <p>48x48</p>
        </td>
        <td>
            <img src="" id="titleImg">

            <p>

            <form action="" method="post">
                <input type="hidden" id="x1" name="x1" />
                <input type="hidden" id="y1" name="y1" />
                <input type="hidden" id="w" name="w" />
                <input type="hidden" id="h" name="h" />
                <input type="hidden" id="oldpath" name="oldpath" />
                <input type="hidden" name="username" value="${username}" />
                <input type="button" value="保存头像" onclick="thumbnailimage()" />
            </form>
            </p>
        </td>

    </tr>
</table>
<input type="button" value="确定" onclick="goSubmit()">
</body>
</html>
