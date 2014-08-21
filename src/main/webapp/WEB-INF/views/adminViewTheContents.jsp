<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/7/21
  Time: 22:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<h2 style="align-content:center;font-weight: bold">${tutorial.title}</h2>

<div>${tutorial.userName}</div>
<div><fmt:formatDate value="${tutorial.createTime}" type="both" pattern="YYYY-MM-dd HH:mm:ss" /></div>
<div>${tutorial.introduce}</div>
<div>${tutorial.content}</div>

</body>
</html>
