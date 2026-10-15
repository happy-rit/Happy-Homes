# Happy Homes Hotel — UI refresh and booking flow

This is an updated version of the supplied Eclipse Dynamic Web Project. It keeps your existing hotel photos and JSP/HTML structure, adds a responsive shared design system, and implements a server-side Oracle booking flow.

## What is included

- `src/main/webapp/index.html` — responsive homepage and quick booking search
- `src/main/webapp/About.jsp` — story, facilities and contact details
- `src/main/webapp/Book.jsp` — booking form, date validation and live price estimate
- `src/main/webapp/Gallery.jsp` — responsive gallery with an accessible image lightbox
- `src/main/webapp/Confirmation.jsp` — shown only after the booking is committed
- `src/main/webapp/assets/css/site.css` and `assets/js/site.js` — shared styles and interactions
- `src/main/java/com/happyhomes/servlet/BookingServlet.java` — server-side validation, room availability check and booking insert
- `src/main/java/com/happyhomes/db/Database.java` — Oracle JDBC connection helper
- `database/oracle_schema.sql` — Oracle tables and sample room inventory

## Requirements

- JDK 17 or newer (the supplied `ojdbc17.jar` is intended for Java 17)
- Apache Tomcat 9.x for the `javax.servlet` API used by this project
- Oracle Database 12c or newer
- The included `src/main/webapp/WEB-INF/lib/ojdbc17.jar` Oracle JDBC driver

The source project did not contain Java backend source files or database credentials/schema. The booking feature therefore needs the database setup below before a booking can be saved. The UI works without database access, but the server deliberately does **not** show a false success when the database is missing.

## Setup

1. Back up your current project folder.
2. Copy the contents of this project over your Eclipse Dynamic Web Project, preserving the `src/main/webapp` and `src/main/java` structure. Do not remove your existing image files or `ojdbc17.jar`.
3. In Oracle SQL Developer, connect as the schema user for the app and run `database/oracle_schema.sql`. This creates `HH_ROOM_TYPES` and `HH_BOOKINGS` and inserts example room inventory/rates. If the tables already exist, back up and adapt the script rather than running it twice.
4. Set these environment variables in the environment that launches Tomcat:
   - `HAPPY_HOME_DB_URL` — e.g. `jdbc:oracle:thin:@//localhost:1521/FREEPDB1` (replace with your actual host, port and service name)
   - `HAPPY_HOME_DB_USER` — Oracle schema username
   - `HAPPY_HOME_DB_PASSWORD` — Oracle schema password
5. Restart Tomcat after setting variables. Make sure `ojdbc17.jar` remains under `src/main/webapp/WEB-INF/lib`.
6. Use Tomcat 9.x for this source as written (`javax.servlet`). In Eclipse, add the Tomcat runtime to the project build path and ensure the server runtime provides the Servlet API; do not copy a servlet API jar into `WEB-INF/lib`.
7. Run the project on server and open the context path, e.g. `http://localhost:8080/Happy_Homes/`.

## Booking behaviour

- Server-side validation checks guest details, dates, allowed room types, payment preference and maximum stay length.
- Inventory is checked on the server against overlapping confirmed bookings. A lock on the room-type inventory row serializes concurrent booking attempts for that room type.
- The database transaction is committed before the confirmation page is shown.
- Payment choices are **pay at property** preferences only. No online payment gateway is connected, and no card data is collected.
- Room rates and inventory are sample values. Update the `HH_ROOM_TYPES` rows to match the real hotel's inventory and approved prices.

## Before production use

This is a student-project implementation, not a complete production reservation platform. Add authentication/authorization for staff functions, HTTPS, CSRF protection, booking cancellation/refund workflows, email notifications, audit logging, rate limiting and formal privacy/retention policies before public deployment. Confirm contact details, location, facility availability, rates, room capacities and testimonials. The displayed sample testimonial is explicitly marked as illustrative and should be replaced with verified feedback or removed.

## Common troubleshooting

- **404 `/booking`**: confirm `BookingServlet.java` is under `src/main/java`, the project is deployed to Tomcat 9, and the build has no errors.
- **Database is not configured**: set all three environment variables in the Tomcat launch environment and restart the server.
- **Oracle driver missing**: confirm `ojdbc17.jar` exists under `WEB-INF/lib` and restart Tomcat.
- **Invalid username/password or service**: test the same connection details in SQL Developer and verify `HAPPY_HOME_DB_URL` uses your Oracle service name.
- **No availability**: edit `TOTAL_ROOMS` in `HH_ROOM_TYPES` to reflect real inventory; don't use sample counts for a live hotel.
