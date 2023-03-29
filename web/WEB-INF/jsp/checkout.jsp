<%--
  Created by IntelliJ IDEA.
  User: cmesina
  Date: 21/3/2023
  Time: 6:47 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Checkout</title>
        <script src="https://js.stripe.com/v3/"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/public/images/icons/favicon.png"/>
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/bootstrap/css/bootstrap.min.css">

        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/fonts/iconic/css/material-design-iconic-font.min.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/fonts/linearicons-v1.0.0/icon-font.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/public/vendor/animate/animate.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/css-hamburgers/hamburgers.min.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/animsition/css/animsition.min.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/select2/select2.min.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/daterangepicker/daterangepicker.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/public/vendor/slick/slick.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/MagnificPopup/magnific-popup.css">
        <link rel="stylesheet" type="text/css"
              href="${pageContext.request.contextPath}/public/vendor/perfect-scrollbar/perfect-scrollbar.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/public/css/util.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/public/css/main.css">
    </head>
    <body class="stext-112 cl6 p-b-26">


        <header class="header-v4">
            <div class="container-menu-desktop">
                <jsp:include page="components/header-navbar.jsp"/>
                <jsp:include page="components/main-navbar.jsp"/>
            </div>
        </header>

        <div class="container mt-5">

            <div class="row">
                <div class="col-md-6">
                    <div class="p-b-10">
                        <h3 class="ltext-103 cl5">
                            Order Summary
                        </h3>
                    </div>
                    <div class="card">
                        <div class="card-body">
                            <table class="table">
                                <thead>
                                    <tr >
                                        <th>Item</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalCost" value="0"/>
                                    <c:forEach var="cartItem" items="${sessionScope.shoppingCart.cartItems}">
                                        <tr>
                                            <td>${cartItem.product.name}</td>
                                            <td>${cartItem.cartQuantity}</td>
                                            <td>$${cartItem.totalPrice}</td>
                                        </tr>
                                        <c:set var="totalCost" value="${totalCost + cartItem.totalPrice}"/>
                                    </c:forEach>
                                    <tr>
                                        <td><b>Total</b></td>
                                        <td></td>
                                        <td><b>$${totalCost}</b></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="p-b-10">
                        <h3 class="ltext-103 cl5">
                            Payment Information
                        </h3>
                    </div>
                    <form>
                        <div class="form-group">
                            <label for="payment-method">Payment Method:</label>

                            <select class="form-control" id="payment-method" onchange="updateCardNumber()">
                                <option value="" selected disabled>Pick a card</option>
                                <c:forEach items="${sessionScope.user.paymentMethods}" var="paymentmethod">
                                    <option value="${paymentmethod.stripePaymentMethodId}" data-last4="${paymentmethod.cardLast4}">
                                        ${paymentmethod.paymentMethodType.toUpperCase()} ${paymentmethod.cardLast4}
                                    </option>
                                </c:forEach>
                            </select>


                        </div>
                        <div id="credit-card-fields">
                            <div class="form-group">
                                <label for="card-number">Credit Card Number:</label>
                                <input type="text" class="form-control" id="card-number" placeholder="Enter your credit card number" value="" disabled>

                            </div>
                            <div class="form-row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="expiry">Expiration Date:</label>
                                        <input type="text" class="form-control" id="expiry" placeholder="MM/YY" disabled>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="cvv">CVV:</label>
                                        <input type="password" class="form-control" id="cvv" placeholder="Enter CVV" maxlength="3" disabled>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <a type="submit" class="flex-c-m stext-101 cl0 size-101 bg1 bor1 hov-btn1 p-lr-15 trans-04" style="color: white;">
                            Confirm Order
                        </a>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>


</body>
<script src="${pageContext.request.contextPath}/public/vendor/jquery/jquery-3.2.1.min.js"></script>

<script src="${pageContext.request.contextPath}/public/vendor/animsition/js/animsition.min.js"></script>

<script src="${pageContext.request.contextPath}/public/vendor/bootstrap/js/popper.js"></script>
<script src="${pageContext.request.contextPath}/public/vendor/bootstrap/js/bootstrap.min.js"></script>

<script src="${pageContext.request.contextPath}/public/vendor/select2/select2.min.js"></script>
<script>
                                $(".js-select2").each(function () {
                                    $(this).select2({
                                        minimumResultsForSearch: 20,
                                        dropdownParent: $(this).next('.dropDownSelect2')
                                    });
                                })
</script>

<script>
    function updateCardNumber() {
        var paymentMethodSelect = document.getElementById("payment-method");
        var cardNumberInput = document.getElementById("card-number");
        var selectedOption = paymentMethodSelect.options[paymentMethodSelect.selectedIndex];
        var last4 = selectedOption.getAttribute("data-last4");
        cardNumberInput.value = last4;
    }
</script>

<script src="${pageContext.request.contextPath}/public/vendor/isotope/isotope.pkgd.min.js"></script>

<script src="${pageContext.request.contextPath}/public/vendor/MagnificPopup/jquery.magnific-popup.min.js"></script>

<script src="${pageContext.request.contextPath}/public/vendor/perfect-scrollbar/perfect-scrollbar.min.js"></script>
<script>
    $('.js-pscroll').each(function () {
        $(this).css('position', 'relative');
        $(this).css('overflow', 'hidden');
        var ps = new PerfectScrollbar(this, {
            wheelSpeed: 1,
            scrollingThreshold: 1000,
            wheelPropagation: false,
        });

        $(window).on('resize', function () {
            ps.update();
        })
    });
</script>

<script>
    var success = "${success}";
    var error = "${error}";

    if (success) {
        swal.fire({
            title: 'Welcome!',
            icon: 'success',
            text: 'Login successful!',
            showCancelButton: false,
            confirmButtonColor: '#3085d6',
            confirmButtonText: 'OK'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "${pageContext.request.contextPath}/user";
            }
        });

    }

    if (error) {
        swal.fire({
            title: 'Error',
            icon: 'error',
            text: '${error}',
            showCancelButton: false,
            confirmButtonColor: '#3085d6',
            confirmButtonText: 'OK'
        });
    }
</script>

<script src="${pageContext.request.contextPath}/public/js/map-custom.js"></script>

<script src="${pageContext.request.contextPath}/public/js/main.js"></script>

<script>
    function checkOut() {
        let paymentMethodId = document.getElementById("payment_method").value;
        fetch("${pageContext.request.contextPath}/cart/checkout", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            }
        }).then(response => {
            if (response.status === 200) {
                return response.json();
            }
        }).then(json => {
            var stripe = Stripe('${stripe_pk}');
            stripe.confirmCardPayment(json.client_secret, {
                payment_method: paymentMethodId
            }).then(function (result) {
                if (result.error) {
                    // Show error to your customer (e.g., insufficient funds)
                    Swal.fire({
                        title: 'Payment Failed!',
                        icon: 'error',
                        text: result.error.message,
                        showCancelButton: false,
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK',
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = "${pageContext.request.contextPath}/user";
                        }
                    });
                } else {
                    // The payment has been processed!
                    if (result.paymentIntent.status === 'succeeded') {
                        fetch(`${pageContext.request.contextPath}/order/confirm?paymentIntentId=\${result.paymentIntent.id}`, {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            }
                        }).then(response => {
                            if (response.status === 200) {
                                // Show a success message to your customer
                                // There's a risk of the customer closing the window before callback
                                // execution. Set up a webhook or plugin to listen for the
                                // payment_intent.succeeded event that handles any business critical
                                // post-payment actions.
                                Swal.fire({
                                    title: 'Payment Successful!',
                                    icon: 'success',
                                    text: 'Your payment was successful.',
                                    showCancelButton: false,
                                    confirmButtonColor: '#3085d6',
                                    confirmButtonText: 'OK',
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.location.href = "${pageContext.request.contextPath}/user";
                                    }
                                });
                            } else {
                                Swal.fire({
                                    title: 'Payment Failed!',
                                    icon: 'error',
                                    text: "There was an error processing your order.",
                                    showCancelButton: false,
                                    confirmButtonColor: '#3085d6',
                                    confirmButtonText: 'OK',
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        window.location.href = "${pageContext.request.contextPath}/user";
                                    }
                                });
                            }
                        })


                    }
                }
            });
        })
    }
</script>
</html>
