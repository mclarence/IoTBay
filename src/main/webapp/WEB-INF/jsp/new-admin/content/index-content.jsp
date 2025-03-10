<%--
  Created by IntelliJ IDEA.
  User: cmesina
  Date: 1/5/2023
  Time: 10:23 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Dashboard</h1>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body d-flex align-items-center">
                        <i class="zmdi zmdi-shopping-cart zmdi-hc-5x mr-3 p-r-10" style="color: #6c7ae0"></i>
                        <div>
                            <h5 class="card-title mb-0">Total Orders</h5>
                            <p class="card-text">${orderCount}</p>
                            <!-- Chart for total orders -->
                        </div>
                    </div>

                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body d-flex align-items-center">
                        <i class="zmdi zmdi-account zmdi-hc-5x mr-3 p-r-10" style="color: #6c7ae0"></i>
                        <div>
                            <h5 class="card-title mb-0 ">Total Customers</h5>
                            <p class="card-text">${userCount}</p>
                            <!-- Chart for customer growth -->
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card">
                    <div class="card-body d-flex align-items-center">
                        <i class="zmdi zmdi-archive zmdi-hc-5x mr-3 p-r-10" style="color: #6c7ae0"></i>
                        <div>
                            <h5 class="card-title mb-0">Total Products</h5>
                            <p class="card-text">${productCount}</p>
                            <!-- Chart for total products -->
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <h3>Monthly Orders</h3>
                <!-- Original chart for total yearly orders -->
                <canvas id="orderChart"></canvas>
            </div>
            <div class="col-md-6">
                <h3>Monthly User Registrations</h3>
                <canvas id="customerGrowthChart"></canvas>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${pageContext.request.contextPath}/public/js/jsp/admin-index.js.jsp"></script>