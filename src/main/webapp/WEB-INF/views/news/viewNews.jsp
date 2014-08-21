<%--
  User: LDL
  Date: 2014/8/20
  Time: 15:38
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的消息</title>
</head>
<body>
<table border="1">
    <c:forEach var="news" items="${newses}">
        <tr>
            <td><a href="/Origami/newsContent?newsID=${news.newsId}">${news.newsTitle}</a></td>
            <td><fmt:formatDate value="${news.newsTime}" type="both" pattern="YYYY-MM-dd HH:mm:ss" /></td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
