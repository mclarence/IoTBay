<%-- 
    Document   : header-navbar
    Created on : 15/03/2023, 8:12:13 PM
    Author     : jasonmba
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>

    <div class="top-bar">
        <div class="content-topbar flex-sb-m h-full container">
            <div class="left-top-bar">
                Free shipping!
            </div>

            <div class="right-top-bar flex-w h-full">
                <c:if test="${sessionScope.user != null}">
                    <c:if test="${sessionScope.user.staff == true}">
                        <c:choose>
                            <c:when test="${not fn:startsWith(requestScope['jakarta.servlet.forward.request_uri'], pageContext.request.contextPath += '/admin')}">
                                <a href="${pageContext.request.contextPath}/admin" class="flex-c-m trans-04 p-lr-25">
                                    <b>Admin</b>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}" class="flex-c-m trans-04 p-lr-25">
                                    <b>Main Site</b>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/user" class="flex-c-m trans-04 p-lr-25">
                            ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                    </a>
                    <a onClick="logoutFunction()" href="#" class="flex-c-m trans-04 p-lr-25 js-logout">
                        Logout
                    </a>
                </c:if>


                <c:if test="${sessionScope.user == null}">
                    <a href="${pageContext.request.contextPath}/login" class="flex-c-m trans-04 p-lr-25">
                        Login
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="flex-c-m trans-04 p-lr-25">
                        Register
                    </a>
                </c:if>

            </div>
        </div>
    </div>

    <script>
        function logoutFunction() {
            var confirmation = confirm("Are you sure you would like to Logout?");
            if (confirmation == true) {
                window.location.href = "<%=request.getContextPath()%>/logout";
            } else {

            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>

        $('.js-logout').each(function () {
            $(this).on('click', function () {
                swal("Welcome!", "You have successfully logged in", "success");
            });
        });

    </script>
</html>
