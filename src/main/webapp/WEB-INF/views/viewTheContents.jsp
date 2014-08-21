<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/7/21
  Time: 22:09
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<h2 style="align-content:center;font-weight: bold">${tutorial.title}</h2>
<h3>提交者:${tutorial.userName}&nbsp;&nbsp;&nbsp;提交时间:<fmt:formatDate value="${tutorial.createTime}" type="both"
                                                                   pattern="YYYY-MM-dd HH:mm:ss"/></h3>
<div style="align-content: center">${tutorial.content}</div>

</body>
</html>
