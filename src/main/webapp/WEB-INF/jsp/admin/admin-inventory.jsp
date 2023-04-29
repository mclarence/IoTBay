<%-- 
    Document   : admin-inventory
    Created on : 30/03/2023, 1:47:41 PM
    Author     : jasonmba
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Inventory</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href="https://unpkg.com/tabulator-tables@5.4.4/dist/css/tabulator.min.css" rel="stylesheet">
        <script type="text/javascript" src="https://unpkg.com/tabulator-tables@5.4.4/dist/js/tabulator.min.js"></script>
        <jsp:include page="../components/common-header-html.jsp"/>

    </head>
    <body class="animsition cl6 p-b-26">

        <!-- Header -->
        <jsp:include page="../components/navbar/admin-master-navbar.jsp"/>

        <section class="txt-center p-lr-15 p-tb-20 bg-dark">
            <h2 class="ltext-105 cl0 txt-center">
                Inventory Management
            </h2>
        </section>

        <!-- Content -->
        <section class="bg0 p-t-50 p-b-116">
            <div class="container">
                <div class="input-group mb-3">
                    <span class="input-group-text" id="basic-addon1">Search</span>
                    <input type="text" class="form-control" placeholder="Enter search term"
                           aria-describedby="basic-addon1" id="search-input">
                </div>
                <div id="product-table"></div>
            </div>
        </section>

        <!-- Edit Product Modal-->
        <jsp:include page="../components/modals/admin-inventory-edit-product-modal.jsp"/>

        <!-- Add Product Modal-->
        <jsp:include page="../components/modals/admin-inventory-add-product-modal.jsp"/>


        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <a onclick="$('#add-product-modal').addClass('show-modal1');"
                       class="btn btn-primary btn-floating">
                        <i class="fa fa-plus"></i>
                    </a>
                </div>
            </div>
        </div>


    </body>

    <jsp:include page="../components/common-footer-html.jsp"/>
    <script src="${pageContext.request.contextPath}/public/vendor/daterangepicker/moment.min.js"></script>
    <script src="${pageContext.request.contextPath}/public/vendor/daterangepicker/daterangepicker.js"></script>
    <script src="${pageContext.request.contextPath}/public/vendor/slick/slick.min.js"></script>
    <script src="${pageContext.request.contextPath}/public/js/slick-custom.js"></script>
    <script src="${pageContext.request.contextPath}/public/vendor/parallax100/parallax100.js"></script>
    <script>
        $('.parallax100').parallax100();
    </script>
    <script src="${pageContext.request.contextPath}/public/vendor/MagnificPopup/jquery.magnific-popup.min.js"></script>
    <script>
        $('.gallery-lb').each(function () { // the containers for all your galleries
            $(this).magnificPopup({
                delegate: 'a', // the selector for gallery item
                type: 'image',
                gallery: {
                    enabled: true
                },
                mainClass: 'mfp-fade'
            });
        });
    </script>
    <script src="${pageContext.request.contextPath}/public/vendor/sweetalert/sweetalert.min.js"></script>
    <script src="${pageContext.request.contextPath}/public/js/jsp/admin-inventory.js.jsp"></script>
</html>
