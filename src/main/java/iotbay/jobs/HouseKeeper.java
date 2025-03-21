package iotbay.jobs;

import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import iotbay.database.DatabaseManager;
import iotbay.enums.OrderStatus;
import iotbay.models.Invoice;
import iotbay.models.Order;
import iotbay.models.OrderLineItem;
import iotbay.models.Product;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * A job runs at a specific interval to check for pending orders and delete old pending orders.
 */
public class HouseKeeper implements Job {

    /**
     * An instance of the database manager
     */
    DatabaseManager db;

    /**
     * The logger for this class
     */
    private static final Logger logger = LogManager.getLogger(HouseKeeper.class);

    /**
     * The database logger for this class.
     */
    private static final Logger iotbayLogger = LogManager.getLogger("iotbayLogger");

    @Override
    public void execute(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        JobDataMap dataMap = jobExecutionContext.getJobDetail().getJobDataMap();
        this.db = (DatabaseManager) dataMap.get("db");

        try {
            checkStripePayments();
        } catch (SQLException | StripeException e) {
            logger.error("Error checking stripe payments", e);
        }

        try {
            deleteOldPendingOrders();
        } catch (SQLException e) {
            logger.error("Error deleting old pending orders", e);
        }
    }

    private void checkStripePayments() throws SQLException, StripeException {
        // get orders with OrderStatus enum of PENDING
        List<Order> pendingOrders = db.getOrders().getOrders(OrderStatus.PENDING);

        for (Order order : pendingOrders) {
            PaymentIntent paymentIntent = PaymentIntent.retrieve(order.getStripePaymentIntentId());

            // check if payment intent exists
            if (paymentIntent == null) {
                logger.error("Payment intent {} does not exist", order.getStripePaymentIntentId());
                order.setOrderStatus(OrderStatus.EXCEPTION);
                order.update();
                continue;
            }

            // check if payment intent is paid
            if (paymentIntent.getStatus().equals("succeeded")) {
                logger.info("Order {} has been paid for. Updating status to processing.", order.getId());
                iotbayLogger.info("Received payment for order number {}. Updating status to processing.", order.getId());
                Invoice invoice = order.getInvoice();
                if (invoice == null) {
                    logger.error("Invoice for order {} does not exist", order.getId());
                    order.setOrderStatus(OrderStatus.EXCEPTION);
                    order.update();
                    continue;
                }

                db.getPayments().addPayment(
                        invoice.getId(),
                        new Timestamp(paymentIntent.getCreated()),
                        db.getPaymentMethods().getPaymentMethod(paymentIntent.getPaymentMethod()).getId(),
                        paymentIntent.getAmount());
                order.setOrderStatus(OrderStatus.PROCESSING);
                order.update();
            }
        }

    }

    /**
     * Delete pending orders that are older than 5 minutes.
     */
    private void deleteOldPendingOrders() throws SQLException {

        // we need to delete the order line items and invoices first as there is a foreign key constraint.
        try (Connection conn = db.getDbConnection()) {
            String sql = "SELECT * FROM CUSTOMER_ORDER WHERE order_status = 'PENDING' AND {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, order_date, CURRENT_TIMESTAMP)} > 5";

            try (ResultSet rs = conn.createStatement().executeQuery(sql)) {
                List<Order> oldPendingOrders = new ArrayList<>();
                while (rs.next()) {
                    oldPendingOrders.add(db.getOrders().getOrder(rs.getInt("id")));
                }

                for (Order order : oldPendingOrders) {
                    order.delete();
                    logger.info("Deleted old pending order {}", order.getId());
                    iotbayLogger.info("Deleted old pending order {}", order.getId());
                }
            }
        }
    }

}
