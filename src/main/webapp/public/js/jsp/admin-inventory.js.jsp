<%--
  Created by IntelliJ IDEA.
  User: cmesina
  Date: 29/4/2023
  Time: 11:35 am
  To change this template use File | Settings | File Templates.
--%>
    <%@ page contentType="text/javascript" %>



    function fetchProductDetails(productId) {
        fetch('${pageContext.request.contextPath}/product/' + productId)
            .then(response => response.json())
            .then(json => {
                document.querySelector('#edit-product-modal #product-name').value = json.data.name;
                document.querySelector('#edit-product-modal #img-product-modal').src = json.data.imageURL;
                document.querySelector('#edit-product-modal #product-description').innerHTML = json.data.description;
                document.querySelector('#edit-product-modal #product-price').value = json.data.price;
                document.querySelector('#edit-product-modal #product-quantity').value = json.data.quantity;
                document.querySelector('#edit-product-modal #btn-update-product').setAttribute('data-product-id', json.data.id);
                document.querySelector('#edit-product-modal #product-image-full').href = json.data.imageURL;
                document.querySelector('#edit-product-modal #product-image-url').value = json.data.imageURL;
            }).finally(() => {
            // workaround for js-show-modal1 not working as the anchor tags in the tabulator table are dynamically generated.
            $('#edit-product-modal').addClass('show-modal1');
        });
    }

    function deleteProduct(productId) {
        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes!'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch("${pageContext.request.contextPath}/admin/product/delete/" + productId, {
                    method: "DELETE",
                    headers: {
                        "Content-Type": "application/json"
                    }
                })
                    .then(response => response.json())
                    .then(json => {
                        if (json.statusCode === 200) {
                            Swal.fire({
                                title: json.message,
                                icon: 'success',
                                text: json.data,
                                showCancelButton: false,
                                confirmButtonColor: '#3085d6',
                                confirmButtonText: 'OK'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.reload();
                                }
                            });
                        } else {
                            Swal.fire({
                                title: json.message,
                                icon: 'error',
                                text: json.data,
                                showCancelButton: false,
                                confirmButtonColor: '#3085d6',
                                confirmButtonText: 'OK'
                            });
                        }
                    })
            }
        })
    }


    function updateProduct() {
        var productId = document.querySelector('#edit-product-modal #btn-update-product').getAttribute('data-product-id');
        var productName = document.querySelector('#edit-product-modal #product-name').value;
        var productPrice = document.querySelector('#edit-product-modal #product-price').value;
        var productQuantity = document.querySelector('#edit-product-modal #product-quantity').value;
        var productDescription = document.querySelector('#edit-product-modal #product-description').value;
        var productImageUrl = document.querySelector('#edit-product-modal #product-image-url').value;

        var payload = {
            "name": productName,
            "price": productPrice,
            "quantity": productQuantity,
            "description": productDescription,
            "imageURL": productImageUrl
        }

        fetch("${pageContext.request.contextPath}/admin/product/update/" + productId, {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        })
            .then(response => response.json())
            .then(json => {
                if (json.statusCode === 200) {
                    Swal.fire({
                        title: json.message,
                        icon: 'success',
                        text: json.data,
                        showCancelButton: false,
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK',
                        target: document.querySelector('#modal-content')
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.reload();
                        }
                    });
                } else {
                    Swal.fire({
                        title: json.message,
                        icon: 'error',
                        text: json.data,
                        showCancelButton: false,
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK',
                        target: document.querySelector('#modal-content')
                    });
                }
            })
    }

    var table = new Tabulator("#product-table", {
        ajaxURL: "${pageContext.request.contextPath}/shop",
        ajaxConfig: {
            method: "GET",
            headers: {
                "Content-Type": "application/json"
            }
        },
        ajaxResponse: function (url, params, response) {
            return {
                "data": response.data.items,
                "last_page": response.data.totalPages
            };
        },
        dataSendParams: {
            "size": "limit"
        },
        layout: "fitColumns",
        paginationMode: "remote",
        paginationSize: 10,
        pagination: true,
        selectable: false,
        columns: [
            {title: "ID", field: "id", width: 20},
            {title: "Name", field: "name", width: 150},
            {
                title: "Price",
                field: "price",
                width: 100,
                formatter: "money",
                formatterParams: {
                    decimal: ".",
                    thousand: ",",
                    symbol: "$",
                    symbolAfter: false,
                    precision: 2,
                },
            },
            {title: "Stock", field: "quantity", width: 100},
            {title: "Category", field: "categoryName", width: 300},
            {
                title: "Image",
                field: "imageURL",
                width: 200,
                formatter: "image",
                formatterParams: {
                    height: "100px",
                    width: "100px",
                },
            },
            // add an edit button
            {
                title: "Actions",
                formatter: function (cell, formatterParams) {
                    return `
                        <button class='btn btn-primary btn-sm js-show-modal1 border-dark' onClick='fetchProductDetails(\${cell.getData().id})'>Edit</button>
                        <button class='btn btn-danger btn-sm border-dark' onclick='deleteProduct(\${cell.getData().id})'>Delete</button>
                    `
                },
                width: 150,
                hozAlign: "center",
            },
        ],
        rowFormatter: function (row) {
            var data = row.getData();
            if (data.quantity <= 0) {
                row.getElement().style.backgroundColor = "#dc3545";
            }

            if (data.quantity > 0 && data.quantity <= 10) {
                row.getElement().style.backgroundColor = "#ffc107";
            }
        }
    });


    $('#search-input').on('keydown', function (ev) {
        if (ev.keyCode === 13) {
            var searchTerm = ev.target.value;

            if (!searchTerm) {
                table.setData("${pageContext.request.contextPath}/shop")
            } else {
                table.setData("${pageContext.request.contextPath}/shop?searchName=" + searchTerm);
            }
        }
    })
