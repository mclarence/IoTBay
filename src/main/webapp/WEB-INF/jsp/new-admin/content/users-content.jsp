<%--
  Created by IntelliJ IDEA.
  User: cmesina
  Date: 1/5/2023
  Time: 11:00 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://unpkg.com/tabulator-tables@5.4.4/dist/css/tabulator.min.css" rel="stylesheet">
<script type="text/javascript" src="https://unpkg.com/tabulator-tables@5.4.4/dist/js/tabulator.min.js"></script>
<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Users</h1>
        <div class="row">
            <div class="card p-all-10">
                <div class="flex-b" style="gap: 5px">
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle" type="button"
                                data-bs-toggle="dropdown"
                                aria-expanded="false">
                            <i class="fa-solid fa-user"></i>

                            Users
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" onclick="$('#add-user-modal').modal('show')"><i
                                    class="fa-solid fa-plus"></i> Add</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="card p-all-10 gy-2">
                <div class="input-group">
                    <span class="input-group-text" id="basic-addon1">Search (Username)</span>
                    <input type="text" class="form-control" placeholder="Enter search term"
                           aria-describedby="basic-addon1" id="search-input">
                </div>
            </div>
        </div>

        <div class="row">
            <div id="user-table" class="gy-2 bg-transparent p-all-0 "></div>
        </div>
    </div>
</main>

<jsp:include page="../../components/modals/admin-users-add-user-modal.jsp"/>
<jsp:include page="../../components/modals/admin-users-edit-user-modal.jsp"/>

<script src="${pageContext.request.contextPath}/public/js/jsp/admin-users.js.jsp"></script>


