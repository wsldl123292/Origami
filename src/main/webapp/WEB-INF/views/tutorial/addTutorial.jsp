<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9"> <![endif]-->
<!--[if !IE]><!--> <html lang="en"> <!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
	<meta charset="utf-8" />
	<title>发布教程</title>
</head>
<!-- END HEAD -->
<!-- BEGIN BODY -->
<link href="bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link href="bootstrap/user_defined.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="uploadify/jquery.min.js"></script>
<script type="text/javascript" src="bootstrap/bootstrap.min.js"></script>
<script src="uploadify/jquery.uploadify.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="uploadify/uploadify.css">
<link rel="stylesheet" href="jcrop/css/jquery.Jcrop.css">
<script src="jcrop/js/jquery.Jcrop.js"></script>

<script type="text/javascript">
    $(function () {
        $("#file_upload_1").uploadify({
            height: 30,
            swf: 'uploadify/uploadify.swf',
            uploader: 'uploadTitleImage',
            width: 120,
            fileObjName:'uploadfile',
            progressData: 'speed',
            multi:false,
            preventCaching: false,
            auto:false,
            fileTypeDesc: '不超过1M的图片 (*.gif;*.jpg;*.png)',
            fileTypeExts:'*.gif;*.jpg;*.jpeg;*.png',
            cancelImg: 'uploadify/uploadify-cancel.png',//取消图片路径
            fileSizeLimit: 1024,  //允许上传的文件大小(kb)  此为2M
            uploadLimit:999,
            buttonText:'浏览',
            onUploadError: function (file, errorCode, errorMsg, errorString) {
                alert('图片 ' + file.name + ' 上传失败: ' + errorString);
            },
            onUploadSuccess: function (file, data, response) {
                document.getElementById("titleImg").setAttribute("src",data);
                document.getElementById("preview48").setAttribute("src",data);
                document.getElementById("preview96").setAttribute("src",data);
                document.getElementById("oldpath").setAttribute("value",data);
                document.getElementById("imgtable").style.display="";
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
                        };
                    };
                });

            }
        });
    });


    function thumbnailimage(){
        $.ajax({
            url:"/Origami/thumbnailimage",
            type:"post",
            data: {x1: $("#x1").val(), y1: $("#y1").val(), w: $("#w").val(), h: $("#h").val(), oldpath: $("#oldpath").val()},
            dataType: "json",
            complete: function (data){
                alert("图片保存成功");
                $("#imgsrc").val(data.responseText);
            }
        })
    }

    function check(){
        var title = $("#title").val();
        var introduction = $("#introduction").val();
        var imgsrc = $("#imgsrc").val();
        if(title == null || title.trim() == ""){
            alert("标题不能为空!");
            return false;
        }
        else if (introduction == null || introduction.trim() == "") {
            alert("简介不能为空!");
            return false;
        }
        else if (imgsrc == null || imgsrc.trim() == "") {
            alert("请上传标题图片!");
            return false;
        }
        else{
            $("#titlecontext").val(title);
            $("#introductioncontext").val(introduction);
            tutorialform.submit();
        }
    }
</script>
<body style="padding-top: 70px;">
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <a class="navbar-brand" href="#">折纸</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="/Origami/index">首页</a></li>
                <li><a href="#">排行</a></li>
                <li><a href="/Origami/addTutorialPage">发布教程</a></li>
                <li><a href="#">帮助</a></li>
                <li><a href="#">建议</a></li>
            </ul>
            <form class="navbar-form navbar-left" role="search">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="Search" size="50">
                </div>
                <button type="submit" class="btn btn-default">查询</button>
            </form>
            <c:choose>
                <c:when test="${user==null}">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="/Origami/login">登录</a></li>
                        <li><a href="/Origami/registerIndex">注册</a></li>
                    </ul>
                </c:when>
                <c:otherwise>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><img src="${user.headimage}" width="20"
                                                                                            height="20" />&nbsp;&nbsp;${user.userName}</a>
                            <ul class="dropdown-menu" role="menu">
                                <li><a href="#"><span
                                        class="glyphicon glyphicon-user"></span>&nbsp;&nbsp;&nbsp;&nbsp;个人主页</a></li>
                                <li role="presentation" class="divider"></li>
                                <li><a href="#"><span class="glyphicon glyphicon-off"></span>&nbsp;&nbsp;&nbsp;&nbsp;退出</a></li>
                            </ul>
                        </li>
                        <li><a href="/Origami/registerIndex">消息<span class="badge alert-danger" id="msgcount"></span></a></li>
                        <li><a href="/Origami/registerIndex">积分:${user.integral}</a></li>
                        <li><a href="/Origami/registerIndex">等级:${user.level}</a></li>
                    </ul>
                    <script type="javascript" src="http://localhost:8080/Origami/websocket/sockjs-0.3.min.js"></script>
                    <script>
                        var websocket;
                        if ('WebSocket' in window) {
                            websocket = new WebSocket("ws://localhost:8080/Origami/webSocketServer");
                        } else if ('MozWebSocket' in window) {
                            websocket = new MozWebSocket("ws://localhost:8080/Origami/webSocketServer");
                        } else {

                            websocket = new SockJS("http://localhost:8080/Origami/sockjs/webSocketServer");
                        }
                        websocket.onopen = function (evnt) {
                        };
                        websocket.onmessage = function (evnt) {
                            $("#msgcount").html(evnt.data);
                        };
                        websocket.onerror = function (evnt) {
                        };
                        websocket.onclose = function (evnt) {
                        }

                    </script>
                </c:otherwise>
            </c:choose>
        </div>
        <!-- /.navbar-collapse -->
    </div>
    <!-- /.container-fluid -->
</nav>

    <div>
        <label>标题:</label><input type="text" name="title" id="title" value="" size="50"/></br></br>
        <label style="vertical-align: top">简介:</label><textarea name="introduction" id="introduction" value="" cols="40" rows="4"
                                                                placeholder="请输入xxx的简介"></textarea></br></br>
        <span>上传用于文档标题的略缩图<input type="file" id="file_upload_1" /></span>
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

                    <form action="thumbnailimage" method="post">
                        <input type="hidden" id="x1" name="x1" />
                        <input type="hidden" id="y1" name="y1" />
                        <input type="hidden" id="w" name="w" />
                        <input type="hidden" id="h" name="h" />
                        <input type="hidden" id="oldpath" name="oldpath" />
                        <input type="hidden" name="username" value="${username}"/>
                        <input type="button" value="保存图片" onclick="thumbnailimage()"/>
                    </form>
                    </p>
                </td>

            </tr>
        </table>

        <span><a href="">填写说明</a></span>
        <form action="addTutorial" method="post" name="tutorialform">
            <!-- 加载编辑器的容器 -->
            <script id="container" name="content" type="text/plain"></script>
            <input type="hidden" name="imgsrc" id="imgsrc" />
            <input type="hidden" name="titlecontext" id="titlecontext" />
            <input type="hidden" name="introductioncontext" id="introductioncontext" />
            <input type="button" value="提交" onclick="check()">
        </form>
        <!-- 配置文件 -->
        <script type="text/javascript" src="ueditor/ueditor.config.js"></script>
        <!-- 编辑器源码文件 -->
        <script type="text/javascript" src="ueditor/ueditor.all.js"></script>
        <!-- 实例化编辑器 -->
        <script type="text/javascript">
            var ue = UE.getEditor('container');
        </script>
    </div>
</body>
<!-- END BODY -->
</html>
