<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>折纸教程网</title>
</head>
<link href="bootstrap/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<link href="bootstrap/user_defined.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="uploadify/jquery.min.js"></script>
<script type="text/javascript" src="bootstrap/bootstrap.min.js"></script>

<script language="javascript">
    function show(id){
        document.getElementById("id").setAttribute("value",id);
        contentForm.submit();
    }
</script>
<body style="padding-top: 70px;">
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <a class="navbar-brand" href="#" style="color: #ffffff">折纸</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="/Origami/index" style="color: #ffffff">首页</a></li>
                <li><a href="#" style="color: #ffffff">排行</a></li>
                <li><a href="/Origami/addTutorialPage" target="_blank" style="color: #ffffff">发布教程</a></li>
                <li><a href="#" style="color: #ffffff">帮助</a></li>
                <li><a href="#" style="color: #ffffff">建议</a></li>
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
                        <li><a href="/Origami/login" style="color: #ffffff">登录</a></li>
                        <li><a href="/Origami/registerIndex" style="color: #ffffff">注册</a></li>
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

<form name="contentForm" method="post" action="viewTheContents">
    <input type="hidden" name="id" id="id" value="" />
</form>
<%--<table border="1">
    <c:forEach var="tutorial" items="${tutorials}">
        <tr>
            <td rowspan="2"><img src="${tutorial.titleImgPath}" width="48" length="48"></td>
            <td style="font-weight: bold"><a href="javascript:show(${tutorial.id})">${tutorial.title}</a></td>
        </tr>
        <tr>
            <td>${tutorial.introduce}</td>
        </tr>
    </c:forEach>
</table>--%>
<div class="container">

    <div class="row">
        <div class="col-xs-6">
            <h2 class="page-header"></h2>
            <c:forEach var="tutorial" items="${tutorials}">
                <div class="media">
                    <a class="pull-left" href="#">
                        <img class="media-object" src="${tutorial.titleImgPath}" width="40" length="40">
                    </a>

                    <div class="media-body">
                        <p style="color: #999999;margin-bottom: 3px;margin-left: 5px">提交者:${tutorial.userName}</p>
                        <h4 class="media-heading"><a href="javascript:show(${tutorial.id})">${tutorial.title}</a></h4>

                        <div class="caption" style="margin-left: 5px">
                            <p>${tutorial.introduce}</p>
                            <p style="color: #999999"><span class="glyphicon glyphicon-comment"></span>&nbsp;0条评论
                            &nbsp;&nbsp;<span class="glyphicon glyphicon-star-empty"></span>&nbsp;收藏</p>
                        </div>
                    </div>
                </div>
            </c:forEach>

        </div>


        <div class="col-xs-4">
            <h2 class="page-header"></h2>

            <ul class="nav nav-list">
                <li>
                    <a href="#" style="color: #646464">
                        <span class="glyphicon glyphicon-file"></span>&nbsp;&nbsp;&nbsp;&nbsp;我的教程
                    </a>
                </li>
                <li>
                    <a href="#" style="color: #646464">
                        <span class="glyphicon glyphicon-star"></span>&nbsp;&nbsp;&nbsp;&nbsp;我的收藏
                    </a>
                </li>
                <li>
                    <a href="#" style="color: #646464">
                        <span class="glyphicon glyphicon-comment"></span>&nbsp;&nbsp;&nbsp;&nbsp;我评论的
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
