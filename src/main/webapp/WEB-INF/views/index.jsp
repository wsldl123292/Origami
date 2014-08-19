<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/7/16
  Time: 21:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>折纸教程网</title>
</head>
<script type="text/javascript" src="uploadify/jquery.min.js"></script>
<script type="text/javascript" src="http://localhost:8080/Origami/websocket/sockjs-0.3.min.js"></script>
<script language="javascript">
    function show(id){
        document.getElementById("id").setAttribute("value",id);
        contentForm.submit();
    }
</script>
<body>
<c:choose>
    <c:when test="${user==null}">
        Hello,游客,<a href="/Origami/login">请登录</a><a href="/Origami/registerIndex">请注册</a>
    </c:when>
    <c:otherwise>
        Hello,<img src="${user.headimage}" width="24" height="24" /> ${user.userName}|积分:${user.integral}|等级:${user.level}|消息<span
        id="msgcount"></span>|<a href="/Origami/addTutorialPage">发布教程</a>
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
                $("#msgcount").html("(<font color='red'>"+evnt.data+"</font>)")
            };
            websocket.onerror = function (evnt) {
            };
            websocket.onclose = function (evnt) {
            }

        </script>
    </c:otherwise>
</c:choose>
<p></p>
<form name="contentForm" method="post" action="viewTheContents">
    <input type="hidden" name="id" id="id" value="" />
</form>
<table border="1">
    <c:forEach var="tutorial" items="${tutorials}">
        <tr>
            <td rowspan="2"><img src="${tutorial.titleImgPath}" width="48" length="48"></td>
            <td style="font-weight: bold"><a href="javascript:show(${tutorial.id})">${tutorial.title}</a></td>
        </tr>
        <tr>
            <td>${tutorial.introduce}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
