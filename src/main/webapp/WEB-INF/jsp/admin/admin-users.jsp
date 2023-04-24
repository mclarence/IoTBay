<%-- 
    Document   : admin-users
    Created on : 30/03/2023, 5:54:36 PM
    Author     : jasonmba
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Users</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <jsp:include page="../components/common-header-html.jsp"/>

    </head>
    <body class="animsition stext-112 cl6 p-b-26">

        <header>
            <div class="container-menu-desktop">
                <jsp:include page="../components/header-navbar.jsp"/>
                <jsp:include page="../components/admin-navbar.jsp"/>
            </div>
        </header>


        <div class="container-fluid">
            <section class="bg0 p-t-104 p-b-20">
                <div>
                    <div class=" bor10 p-lr-70 p-t-55 p-b-70 p-lr-15-lg w-full-md">
                        <div class="container">
                            <h1>Manage User Access</h1>    
                        </div>


                        <div class="container mt-4 pb-3">
                            <div class="row">
                                <div class="col-md-12">
                                    <form class="form-inline float-right">
                                        <div class="form-group">
                                            <input type="text" class="form-control mr-2" id="orderNumber" placeholder="Enter User ID">
                                        </div>
                                        <button type="submit" class="btn btn-primary">Search</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <section class="section-table bg0">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="table-responsive">
                                            <table class="table table-hover table-bordered">
                                                <thead>
                                                    <tr class="bg-dark text-white">
                                                        <th scope="col" class="text-center" style="width: 10%">User ID</th>
                                                        <th scope="col" class="text-center" style="width: 10%">Name</th>
                                                        <th scope="col" class="text-center">Email</th>
                                                        <th scope="col" class="text-center">Phone</th>
                                                        <th scope="col" class="text-center">Address</th>
                                                        <th scope="col" class="text-center">Position</th>
                                                        <th scope="col" class="text-center">Status</th>                                                                                                                                                                 
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="order" items="${orders}" varStatus="status">
                                                   <!-- <tr class="${status.index % 2 == 0 ? 'table-primary' : 'table-secondary'}">
                                                        <td class="text-center">${order.id}</td>
                                                        <td class="text-center">${order.userId}</td>
                                                        <td>${order.orderDate}</td>
                                                        <td class="text-center">
                                                            <div class="dropdown">
                                                                <button class="btn btn-secondary dropdown-toggle" type="button" id="statusDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                    ${order.orderStatus}
                                                                </button>
                                                                <div class="dropdown-menu" aria-labelledby="statusDropdown">
                                                                    <a class="dropdown-item" href="#" value="pending">Active</a>
                                                                    <a class="dropdown-item" href="#" value="processing">Inactive</a>                                                     
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-center"><button class="btn btn-primary">Save</button></td> -->
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>


            </section>
        </div>


    </body>


    <jsp:include page="../components/common-footer-html.jsp"/>
</html>
