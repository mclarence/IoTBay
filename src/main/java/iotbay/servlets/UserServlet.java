/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package iotbay.servlets;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.Phonenumber;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentMethod;
import com.stripe.model.SetupIntent;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;
import iotbay.database.DatabaseManager;
import iotbay.exceptions.UserExistsException;
import iotbay.models.User;
import iotbay.models.httpResponses.GenericApiResponse;
import iotbay.util.CustomHttpServletRequest;
import iotbay.util.CustomHttpServletResponse;
import iotbay.util.Misc;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;
import java.util.Properties;

/**
 * @author cmesina
 */
public class UserServlet extends HttpServlet {

    DatabaseManager db;

    private static final Logger logger = LogManager.getLogger(UserServlet.class);
    private static final Logger iotbayLogger = LogManager.getLogger("iotbayLogger");

    @Override
    public void init() throws ServletException {
        super.init();
        this.db = (DatabaseManager) getServletContext().getAttribute("db");
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();
        switch (path) {
            case "/payments/add/success" -> addPaymentMethodSuccess(request, response);
            case "/payments/add/cancel" -> response.sendRedirect(getServletContext().getContextPath() + "/user");
            case "/" -> request.getRequestDispatcher("/WEB-INF/jsp/user.jsp").forward(request, response);
            default -> response.sendError(404);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo() == null ? "/" : request.getPathInfo();

        if (path != null) {
            switch (request.getPathInfo()) {
                case "/payments/add" -> addPaymentMethod(request, response);
                case "/payments/remove" -> removePaymentMethod(request, response);
                case "/details/modify" -> updateUserDetails(request, response);
                default -> response.sendError(404);
            }
        }


    }

    private void updateUserDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CustomHttpServletResponse res = (CustomHttpServletResponse) response;
        CustomHttpServletRequest req = (CustomHttpServletRequest) request;
        try {
            Gson gson = new Gson();
            JsonObject requestData = req.getJsonBody();

            String username = requestData.get("username").getAsString();
            String firstname = requestData.get("firstname").getAsString();
            String lastname = requestData.get("lastname").getAsString();
            String address = requestData.get("address").getAsString();
            String email = requestData.get("email").getAsString();
            String phone = requestData.get("phone").getAsString();


            User user = (User) request.getSession().getAttribute("user");
            if (user.getUsername() != username && this.db.getUsers().getUser(username) == null) {
                user.setUsername(username);
            }

            PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();
            Phonenumber.PhoneNumber phoneNumber = null;
            try {
                phoneNumber = phoneUtil.parse(phone, "AU");
                if (!phoneUtil.isValidNumber(phoneNumber)) {
                    res.sendJsonResponse(
                            GenericApiResponse.<String>builder()
                                    .statusCode(400)
                                    .message("Error")
                                    .data("Invalid Australian phone number")
                                    .error(true)
                                    .build()
                    );
                    return;
                }
            } catch (Exception e) {
                res.sendJsonResponse(
                        GenericApiResponse.<String>builder()
                                .statusCode(400)
                                .message("Error")
                                .data("Invalid Australian phone number")
                                .error(true)
                                .build()
                );
                return;
            }


            if (firstname != null && address != null && email != null && phone != null && lastname != null) {
                user.setFirstName(firstname);
                user.setLastName(lastname);
                user.setAddress(address);
                user.setEmail(email);
                user.setPhoneNumber(phoneUtil.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164));
                this.db.getUsers().updateUser(user);
            }

            res.sendJsonResponse(GenericApiResponse.<String>builder()
                    .statusCode(200)
                    .message("Success")
                    .data("Details updated successfully")
                    .error(false)
                    .build());
        } catch (SQLException | IOException e) {
            logger.error(e);

            res.sendJsonResponse(GenericApiResponse.<String>builder()
                    .statusCode(500)
                    .message("Error")
                    .data(e.getMessage())
                    .error(false)
                    .build());
        } catch (NumberFormatException e) {
            logger.error(e);

            res.sendJsonResponse(
                    GenericApiResponse.<String>builder()
                            .statusCode(400)
                            .message("Error")
                            .data("Invalid phone number")
                            .error(false)
                            .build()
            );
        } catch (UserExistsException e) {
            res.sendJsonResponse(
                    GenericApiResponse.<String>builder()
                            .statusCode(400)
                            .message("Error")
                            .data("Username or email already exists.")
                            .error(false)
                            .build()
            );
            return;
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            res.sendJsonResponse(
                    GenericApiResponse.<String>builder()
                            .statusCode(500)
                            .message("Error")
                            .data("Internal server error")
                            .error(false)
                            .build()
            );
            return;
        }
    }

    private void removePaymentMethod(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        // detach payment method from stripe customer and remove from database
        int paymentMethodId = Integer.parseInt(request.getParameter("paymentMethodId"));
        User user = (User) request.getSession().getAttribute("user");

        iotbay.models.PaymentMethod paymentMethod;

        try {
            paymentMethod = user.getPaymentMethod(paymentMethodId);
        } catch (Exception e) {
            throw new ServletException(e);
        }


        // the payment method not found
        if (paymentMethod == null) {
            try {
                response.sendError(404);
                return;
            } catch (IOException e) {
                throw new ServletException(e);
            }
        }

        try {
            try {
                PaymentMethod stripePaymentMethod = PaymentMethod.retrieve(paymentMethod.getStripePaymentMethodId());
                stripePaymentMethod.detach();
            } catch (StripeException e) {
                if (e.getMessage().startsWith("The payment method you provided is not attached to a customer so detachment is impossible.")) {
                    logger.warn("Payment method " + paymentMethod.getId() + " is not attached to a customer on Stripe");
                } else {
                    throw new ServletException(e);
                }

            }

            user.deletePaymentMethod(paymentMethod);

            logger.info("User " + user.getId() + " removed a payment method");
            iotbayLogger.info("User " + user.getId() + " removed a payment method");

            response.sendRedirect(request.getContextPath() + "/user");

        } catch (Exception e) {
            throw new ServletException(e);
        }

    }

    private static void addPaymentMethod(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        String redirectUrl = request.getParameter("redirectUrl");

        // get the host header
        String host = request.getHeader("Host");

        //get current http protocol
        String protocol = request.getScheme();

        if (request.getHeader("X-Forwarded-Proto") != null) {
            protocol = request.getHeader("X-Forwarded-Proto");
        }

        SessionCreateParams params;
        // check if the redirect url is valid
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            params = SessionCreateParams.builder()
                    .addPaymentMethodType(SessionCreateParams.PaymentMethodType.CARD)
                    .setMode(SessionCreateParams.Mode.SETUP)
                    .setCustomer(((User) request.getSession().getAttribute("user")).getStripeCustomerId())
                    .setSuccessUrl(String.format("%s://%s%s/user/payments/add/success?session_id={CHECKOUT_SESSION_ID}", protocol, host, request.getContextPath()))
                    .setCancelUrl(String.format("%s://%s%s/user/payments/add/cancel", protocol, host, request.getContextPath()))
                    .build();
        } else {
            params = SessionCreateParams.builder()
                    .addPaymentMethodType(SessionCreateParams.PaymentMethodType.CARD)
                    .setMode(SessionCreateParams.Mode.SETUP)
                    .setCustomer(((User) request.getSession().getAttribute("user")).getStripeCustomerId())
                    .setSuccessUrl(String.format("%s://%s%s/user/payments/add/success?session_id={CHECKOUT_SESSION_ID}&redirectUrl=%s", protocol, host,request.getContextPath(), redirectUrl))
                    .setCancelUrl(String.format("%s://%s%s/user/payments/add/cancel", protocol, host, request.getContextPath()))
                    .build();
        }


        try {
            Session session = Session.create(params);
            response.sendRedirect(session.getUrl());
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void addPaymentMethodSuccess(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        String sessionId = request.getParameter("session_id");
        try {
            Session session = Session.retrieve(sessionId);
            SetupIntent setupIntent = SetupIntent.retrieve(session.getSetupIntent());
            try {
                User user = (User) request.getSession().getAttribute("user");
                iotbay.models.PaymentMethod paymentMethod = new iotbay.models.PaymentMethod();
                paymentMethod.setStripePaymentMethodId(setupIntent.getPaymentMethod());
                paymentMethod.setUserId(user.getId());

                // retrieve the payment method from stripe
                PaymentMethod stripePaymentMethod = PaymentMethod.retrieve(setupIntent.getPaymentMethod());

                paymentMethod.setPaymentMethodType(stripePaymentMethod.getCard().getBrand());
                paymentMethod.setCardLast4(Integer.parseInt(stripePaymentMethod.getCard().getLast4()));
                user.addPaymentMethod(paymentMethod);

                logger.info("User " + user.getId() + " added a new payment method");
                iotbayLogger.info("User " + user.getId() + " added a new payment method");

                String redirectUrl = request.getParameter("redirectUrl");

                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + redirectUrl);
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/user");
            } catch (Exception e) {
                throw new ServletException(e);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
