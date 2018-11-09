
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<html>
<head>
    <jsp:include page="parts/header.jsp"/>
    <title>Tariff </title>
</head>
<body class="bg-light">

    <jsp:include page="parts/navbar.jsp"/>

    <jsp:include page="parts/welcom.jsp">
        <jsp:param name="name" value="${tariff.name}"/>
        <jsp:param name="massage" value="<p>Welcome to the tariff's home page</p>"/>
        <jsp:param name="secondName" value=""/>
    </jsp:include>


    <div class="container" style="max-width: 960px;">

        <c:if test="${not empty exception}">
            <div class="alert alert-danger" role="alert">
                    ${exception}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${tariff.valid == true}">
                <c:set var="activeStatus" value="Active"/>
                <c:set var="activeBtn" value="Block"/>
                <c:set var="activeStyle" value="color: green;"/>
            </c:when>
            <c:otherwise>
                <c:set var="activeStatus" value="Blocked"/>
                <c:set var="activeBtn" value="Activete"/>
                <c:set var="activeStyle" value="color: red;"/>
            </c:otherwise>
        </c:choose>

        <jsp:include page="parts/separator.jsp">
            <jsp:param name="name" value="Tariff info"/>
        </jsp:include>

        <jsp:include page="parts/info.jsp">
            <jsp:param name="imgPath" value="/resources/images/tariff.png"/>

            <jsp:param name="name1" value="Name"/>
            <jsp:param name="name2" value="Info"/>
            <jsp:param name="name3" value="Price"/>
            <jsp:param name="name4" value="Status"/>

            <jsp:param name="value1" value="${tariff.name}"/>
            <jsp:param name="value2" value="${tariff.info}"/>
            <jsp:param name="value3" value="$${tariff.price} <small class='text-muted'>/ mo</small>"/>
            <jsp:param name="value4" value="${activeStatus}"/>
            <jsp:param name="value4Style" value="${activeStyle}"/>

            <jsp:param name="showBtn1" value="${tariff.valid == false}"/>
            <jsp:param name="btn1Path" value="/replaceTariff"/>
            <jsp:param name="btn1HiddenName" value="tariffId"/>
            <jsp:param name="btn1HiddenValue" value="${tariff.id}"/>
            <jsp:param name="btn1Name" value="Replace"/>
            <jsp:param name="btn1Method" value="get"/>

            <jsp:param name="showBtn2" value="${tariff.valid == false}"/>
            <jsp:param name="btn2Path" value="/removeTariff"/>
            <jsp:param name="btn2HiddenName" value="tariffId"/>
            <jsp:param name="btn2HiddenValue" value="${tariff.id}"/>
            <jsp:param name="btn2Name" value="Remove"/>
            <jsp:param name="btn2Method" value="post"/>

            <jsp:param name="showBtn3" value="${true}"/>
            <jsp:param name="btn3Path" value="/changeTariffStatus"/>
            <jsp:param name="btn3HiddenName" value="tariffId"/>
            <jsp:param name="btn3HiddenValue" value="${tariff.id}"/>
            <jsp:param name="btn3Name" value="${activeBtn}"/>
            <jsp:param name="btn3Method" value="post"/>

            <jsp:param name="showBtn4" value="${false}"/>
        </jsp:include>

        <jsp:include page="parts/separator.jsp">
            <jsp:param name="name" value="Tariff options"/>
        </jsp:include>

        <div class="card-columns mb-3 text-center">

            <jsp:include page="parts/basicCard.jsp">
                <jsp:param name="title" value="New option"/>
                <jsp:param name="body" value="<ul class='list-unstyled mt-3 mb-4'>
                        <li>Add new options</li>
                        <li>Make the contract</li>
                        <li>more convenient for clients!</li>
                    </ul>"/>
                <jsp:param name="path" value="/newOption"/>
                <jsp:param name="method" value="get"/>
                <jsp:param name="hiddenName1" value="tariffId"/>
                <jsp:param name="hiddenValue1" value="${tariff.id}"/>
                <jsp:param name="hiddenName2" value=""/>
                <jsp:param name="hiddenValue2" value=""/>
                <jsp:param name="btnName" value="Add"/>
            </jsp:include>

            <c:forEach items="${tariff.options}" var="option">
                <jsp:include page="parts/priceCard.jsp">
                    <jsp:param name="title" value="${option.name}"/>
                    <jsp:param name="price" value="${option.price}"/>
                    <jsp:param name="info" value="<p class='card-text'>${option.info}</p>"/>
                    <jsp:param name="path" value="/removeOption"/>
                    <jsp:param name="method" value="post"/>
                    <jsp:param name="hiddenName1" value="tariffId"/>
                    <jsp:param name="hiddenValue1" value="${tariff.id}"/>
                    <jsp:param name="hiddenName2" value="optionId"/>
                    <jsp:param name="hiddenValue2" value="${option.id}"/>
                    <jsp:param name="btnName" value="Remove"/>
                    <jsp:param name="btnStyle" value="btn-link"/>
                </jsp:include>
            </c:forEach>

        </div>

    </div>
    <jsp:include page="parts/footer.jsp"/>

</body>
</html>