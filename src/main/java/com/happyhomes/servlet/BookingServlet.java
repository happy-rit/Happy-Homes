package com.happyhomes.servlet;

import com.happyhomes.db.Database;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Locale;
import java.util.UUID;
import java.util.regex.Pattern;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONE = Pattern.compile("^[+0-9 ()-]{8,20}$");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String roomType = trim(request.getParameter("roomType")).toUpperCase(Locale.ROOT);
        String paymentMethod = trim(request.getParameter("paymentMethod")).toUpperCase(Locale.ROOT);
        String requests = trim(request.getParameter("requests"));
        String checkInText = trim(request.getParameter("checkIn"));
        String checkOutText = trim(request.getParameter("checkOut"));
        int guests;
        LocalDate checkIn;
        LocalDate checkOut;
        try {
            guests = Integer.parseInt(trim(request.getParameter("guests")));
            checkIn = LocalDate.parse(checkInText);
            checkOut = LocalDate.parse(checkOutText);
        } catch (Exception e) {
            fail(request, response, "Enter valid check-in, check-out and guest details."); return;
        }
        if (fullName.length() < 2 || fullName.length() > 100 || email.length() > 150 || !EMAIL.matcher(email).matches()) {
            fail(request, response, "Enter a valid full name and email address."); return;
        }
        if (!PHONE.matcher(phone).matches()) { fail(request, response, "Enter a valid mobile number using 8–20 digits, spaces, +, brackets or hyphens."); return; }
        if (guests < 1 || guests > 6) { fail(request, response, "Guest count must be between 1 and 6."); return; }
        if (checkIn.isBefore(LocalDate.now()) || !checkOut.isAfter(checkIn) || ChronoUnit.DAYS.between(checkIn, checkOut) > 60) {
            fail(request, response, "Choose a check-in date today or later and a check-out date after check-in (maximum 60 nights)."); return;
        }
        if (!(roomType.equals("STANDARD") || roomType.equals("DELUXE") || roomType.equals("SUITE") || roomType.equals("FAMILY"))) {
            fail(request, response, "Select a valid room type."); return;
        }
        if (!(paymentMethod.equals("PAY_AT_HOTEL") || paymentMethod.equals("UPI_AT_HOTEL") || paymentMethod.equals("CARD_AT_HOTEL"))) {
            fail(request, response, "Select a valid payment preference."); return;
        }
        if (requests.length() > 500) { fail(request, response, "Special requests must be 500 characters or fewer."); return; }

        Connection connection = null;
        try {
            connection = Database.getConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            int inventory;
            int maxGuests;
            BigDecimal rate;
            // Lock this room-type inventory row so concurrent requests for the same type cannot overbook it.
            try (PreparedStatement roomStmt = connection.prepareStatement(
                    "SELECT TOTAL_ROOMS, NIGHTLY_RATE, MAX_GUESTS FROM HH_ROOM_TYPES WHERE ROOM_TYPE = ? FOR UPDATE")) {
                roomStmt.setString(1, roomType);
                try (ResultSet rs = roomStmt.executeQuery()) {
                    if (!rs.next()) { connection.rollback(); fail(request, response, "That room type is not configured. Please contact the hotel."); return; }
                    inventory = rs.getInt("TOTAL_ROOMS");
                    rate = rs.getBigDecimal("NIGHTLY_RATE");
                    maxGuests = rs.getInt("MAX_GUESTS");
                }
            }
            if (guests > maxGuests) { connection.rollback(); fail(request, response, "The selected room type supports up to " + maxGuests + " guest(s). Choose another room type or reduce the guest count."); return; }
            String overlapSql = "SELECT COUNT(*) FROM HH_BOOKINGS WHERE ROOM_TYPE = ? AND STATUS = 'CONFIRMED' AND CHECK_IN < ? AND CHECK_OUT > ?";
            int overlapping;
            try (PreparedStatement overlapStmt = connection.prepareStatement(overlapSql)) {
                overlapStmt.setString(1, roomType);
                overlapStmt.setDate(2, Date.valueOf(checkOut));
                overlapStmt.setDate(3, Date.valueOf(checkIn));
                try (ResultSet rs = overlapStmt.executeQuery()) { rs.next(); overlapping = rs.getInt(1); }
            }
            if (overlapping >= inventory) {
                connection.rollback(); fail(request, response, "Sorry, this room type is not available for those dates. Please try different dates or another room type."); return;
            }
            long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
            BigDecimal total = rate.multiply(BigDecimal.valueOf(nights));
            String bookingCode = "HH-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase(Locale.ROOT);
            String insertSql = "INSERT INTO HH_BOOKINGS (BOOKING_CODE, FULL_NAME, EMAIL, PHONE, ROOM_TYPE, CHECK_IN, CHECK_OUT, GUESTS, NIGHTLY_RATE, NIGHTS, TOTAL_AMOUNT, PAYMENT_METHOD, SPECIAL_REQUESTS, STATUS, CREATED_AT) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', SYSTIMESTAMP)";
            try (PreparedStatement insert = connection.prepareStatement(insertSql)) {
                insert.setString(1, bookingCode); insert.setString(2, fullName); insert.setString(3, email);
                insert.setString(4, phone); insert.setString(5, roomType); insert.setDate(6, Date.valueOf(checkIn));
                insert.setDate(7, Date.valueOf(checkOut)); insert.setInt(8, guests); insert.setBigDecimal(9, rate);
                insert.setLong(10, nights); insert.setBigDecimal(11, total); insert.setString(12, paymentMethod);
                if (requests.isEmpty()) insert.setNull(13, java.sql.Types.VARCHAR); else insert.setString(13, requests);
                insert.executeUpdate();
            }
            connection.commit();
            request.setAttribute("bookingCode", bookingCode);
            request.getRequestDispatcher("/Confirmation.jsp").forward(request, response);
        } catch (SQLException e) {
            if (connection != null) try { connection.rollback(); } catch (SQLException ignored) { }
            log("Booking could not be saved", e);
            String message = e.getMessage() != null && e.getMessage().contains("Database is not configured")
                    ? "The booking database is not configured yet. Follow the README setup steps, then try again. Your booking has not been saved."
                    : "We could not save your booking because the booking service or database is unavailable. No booking was confirmed. Please try again later or contact the hotel.";
            fail(request, response, message);
        } finally {
            if (connection != null) try { connection.close(); } catch (SQLException ignored) { }
        }
    }

    private void fail(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("bookingError", message);
        request.getRequestDispatcher("/Book.jsp").forward(request, response);
    }
    private static String trim(String value) { return value == null ? "" : value.trim(); }
}
