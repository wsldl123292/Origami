<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2014/7/31
  Time: 21:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="uploadify/jquery.min.js"></script>
<html>
<head>
    <title></title>
</head>
<script language="javascript">
    function show(id) {
        document.getElementById("id").setAttribute("value", id);
        contentForm.submit();
    }

    function audit(id,title,username,type,reason){
        if(type == 'N'){
            if($('#reason' + id).val()==""){
                alert("请输入拒绝原因")
                return;
            }else{
                reason = $('#reason' + id).val();
            }
        }
        $.ajax({
            url: "/Origami/auditing",
            type: "post",
            data: {id: id,reason:reason,title:title, username: username},
            dataType: "json",
            complete: function (result) {
                if (result.responseText == 'fail') {
                    $('#msg').html('<font color="red">操作失败请重试</font>');
                } else {
                    location.reload();
                }
            }
        })

    }
</script>
<body>
<form name="contentForm" method="post" action="adminViewTheContents">
    <input type="hidden" name="id" id="id" value="" />
</form>
<span id="msg"></span>
<table border="1">
    <tr>
        <th>图标</th>
        <th>标题</th>
        <th>作者</th>
        <th>时间</th>
        <th>审核</th>
        <th>原因</th>
    </tr>
    <c:forEach var="tutorial" items="${unauditedTutorials}">
        <tr id="tr${tutorial.id}">
            <td><img src="${tutorial.titleImgPath}" width="48" length="48"></td>
            <td><a href="javascript:show(${tutorial.id})">${tutorial.title}</a></td>
            <td>${tutorial.userName}</td>
            <td><fmt:formatDate value="${tutorial.createTime}" type="both" pattern="YYYY-MM-dd HH:mm:ss"/></td>
            <td><input type="button" value="通过" onclick="audit('${tutorial.id}','${tutorial.title}',
                    '${tutorial.userName}','Y','')"/><input
                    type="button" value="拒绝"
                                                                                           onclick="audit('${tutorial.id}','${tutorial.title}',
                                                                                                   '${tutorial.userName}','N','')"/></td>
            <td><textarea id="reason${tutorial.id}" placeholder="请填写拒绝原因"></textarea></td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
