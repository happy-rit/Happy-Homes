<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<%
String cp = request.getContextPath();
String error = (String) request.getAttribute("bookingError");
String selectedRoom = request.getParameter("roomType");
if (selectedRoom == null)
	selectedRoom = "DELUXE";
String ci = request.getParameter("checkIn");
String co = request.getParameter("checkOut");
String guestParam = request.getParameter("guests");
if (guestParam == null)
	guestParam = "2";
String today = LocalDate.now().toString();
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description"
	content="Book your Happy Homes Hotel stay. Choose your dates, room type and guest details.">
<title>Book a Stay | Happy Homes Hotel</title>
<link rel="stylesheet" href="assets/css/site.css">
</head>
<body>
	<header class="site-header">
		<div class="container nav-wrap">
			<a class="brand" href="index.html"
				aria-label="Happy Homes Hotel home"><span class="brand-mark">H</span><span
				class="brand-copy"><strong>Happy Homes</strong><small>Stay
						beautifully</small></span></a>
			<nav class="nav-links" data-nav aria-label="Main navigation">
				<a href="index.html">Home</a><a href="About.jsp">Our Story</a><a
					href="Book.jsp" aria-current="page">Rooms and Booking</a><a
					href="Gallery.jsp">Gallery</a><a href="About.jsp#contact">Contact</a>
			</nav>
			<div class="nav-actions">
				<a class="btn btn-primary" href="Book.jsp">Book your stay <span
					aria-hidden="true">↗</span></a>
				<button class="menu-toggle" type="button" data-menu-toggle
					aria-expanded="false" aria-label="Open navigation menu">☰</button>
			</div>
		</div>
	</header>
	<main>
		<section class="page-hero">
			<div class="container">
				<div class="breadcrumb"><a href="index.html">HOME / </a><a href="Book.jsp"> BOOK YOUR STAY</a></div>
				<span class="eyebrow">Your stay starts here</span>
				<h1 class="display">Make yourself at home.</h1>
				<p>Share a few details and we’ll help you plan a comfortable
					stay.</p>
			</div>
		</section>
		<section class="section">
			<div class="container">
				<%
				if (error != null && !error.trim().isEmpty()) {
				%><div
					class="alert alert-error" role="alert">
					<strong>We couldn't complete your booking.</strong><br><%=error%></div>
				<%
				}
				%><div class="booking-layout">
					<form class="booking-card" action="<%=cp%>/booking" method="post"
						id="booking-form">
						<h2>Guest and stay details</h2>
						<p class="card-subtitle">Fields marked * are required. Your
							booking is confirmed only after the server saves it successfully.</p>
						<div class="form-grid">
							<div class="field full">
								<label for="fullName">Full name *</label><input id="fullName"
									name="fullName" type="text" autocomplete="name"
									maxlength="100" placeholder="Enter the lead guest's full name"
									required
									value="<%=request.getParameter("fullName") == null ? ""
		: request.getParameter("fullName").replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;")%>">
							</div>
							<div class="field">
								<label for="email">Email address *</label><input id="email"
									name="email" type="email" autocomplete="email" maxlength="150"
									placeholder="you@example.com" required
									value="<%=request.getParameter("email") == null ? ""
		: request.getParameter("email").replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;")%>">
							</div>
							<div class="field">
								<label for="phone">Mobile number *</label><input id="phone"
									name="phone" type="tel" autocomplete="tel" inputmode="tel"
									pattern="[+0-9 ()-]{8,20}" maxlength="20"
									placeholder="+91 98765 43210" required
									value="<%=request.getParameter("phone") == null ? ""
		: request.getParameter("phone").replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;")%>"><small>Include
									country code if possible.</small>
							</div>
						</div>
						<hr class="form-divider">
						<h2>Your dates</h2>
						<p class="card-subtitle">Check-in and check-out are used to
							calculate your stay.</p>
						<div class="form-grid">
							<div class="field">
								<label for="checkIn">Check-in *</label><input id="checkIn"
									name="checkIn" type="date" data-checkin required
									min="<%=today%>"
									value="<%=ci == null ? "" : ci.replace("\"", "")%>">
							</div>
							<div class="field">
								<label for="checkOut">Check-out *</label><input id="checkOut"
									name="checkOut" type="date" data-checkout required
									value="<%=co == null ? "" : co.replace("\"", " ")%>">
							</div>
							<div class="field">
								<label for="guests">Number of guests *</label><select
									id="guests" name="guests" data-guests required><option
										value="1" <%="1".equals(guestParam) ? "selected" : ""%>>1
										guest</option>
									<option value="2" <%="2".equals(guestParam) ? "selected" : ""%>>2
										guests</option>
									<option value="3" <%="3".equals(guestParam) ? "selected" : ""%>>3
										guests</option>
									<option value="4" <%="4".equals(guestParam) ? "selected" : ""%>>4
										guests</option>
									<option value="5" <%="5".equals(guestParam) ? "selected" : ""%>>5
										guests</option>
									<option value="6" <%="6".equals(guestParam) ? "selected" : ""%>>6
										guests</option></select>
							</div>
							<div class="field">
								<label for="roomType">Room type *</label><select id="roomType"
									name="roomType" data-room-type required><option
										value="STANDARD" data-rate="2500"
										<%="STANDARD".equals(selectedRoom) ? "selected" : ""%>>Classic
										Room — ₹2,500/night</option>
									<option value="DELUXE" data-rate="3800"
										<%="DELUXE".equals(selectedRoom) ? "selected" : ""%>>Deluxe
										Room — ₹3,800/night</option>
									<option value="SUITE" data-rate="6500"
										<%="SUITE".equals(selectedRoom) ? "selected" : ""%>>Signature
										Suite — ₹6,500/night</option>
									<option value="FAMILY" data-rate="5200"
										<%="FAMILY".equals(selectedRoom) ? "selected" : ""%>>Family
										Room — ₹5,200/night</option></select>
							</div>
							<div class="field full">
								<label for="requests">Special requests (optional)</label>
								<textarea id="requests" name="requests" rows="3" maxlength="500"
									placeholder="Accessibility needs, arrival notes, or other requests"></textarea>
								<small>Requests are subject to availability and are not
									guaranteed.</small>
							</div>
						</div>
						<hr class="form-divider">
						<h2>Payment preference</h2>
						<p class="card-subtitle">No payment is collected online by
							this demo project. Select how you prefer to settle the bill at
							the property.</p>
						<div class="field">
							<label for="paymentMethod">Payment method *</label><select
								id="paymentMethod" name="paymentMethod" required><option
									value="PAY_AT_HOTEL">Pay at hotel</option>
								<option value="UPI_AT_HOTEL">UPI at hotel</option>
								<option value="CARD_AT_HOTEL">Card at hotel</option></select>
						</div>
						<div class="mt-3">
							<button class="btn btn-primary" type="submit" style="width: 100%">
								Confirm booking request <span aria-hidden="true">→</span>
							</button>
							<p class="no-results">By continuing, you confirm that the
								details provided are accurate. No card number or sensitive
								payment information is requested.</p>
						</div>
					</form>
					<aside class="summary-card">
						<h2>Your stay summary</h2>
						<p class="card-subtitle">Estimate updates as you select your
							room and dates.</p>
						<div class="summary-line">
							<span>Room rate</span><strong data-rate>₹0</strong>
						</div>
						<div class="summary-line">
							<span>Number of nights</span><strong data-nights>0</strong>
						</div>
						<div class="summary-line">
							<span>Guests</span><strong id="summary-guests"><%=guestParam%></strong>
						</div>
						<div class="summary-line">
							<span>Room subtotal</span><strong data-subtotal>₹0</strong>
						</div>
						<div class="summary-total">
							<span>Estimated total</span><strong data-total>₹0</strong>
						</div>
						<p class="summary-note">Estimate excludes any taxes or
							additional services that may apply. The final rate is confirmed
							by the hotel.</p>
						<div class="summary-line">
							<span>✓ Secure form</span><strong>Protected</strong>
						</div>
						<div class="summary-line">
							<span>✓ Availability check</span><strong>On submit</strong>
						</div>
						<p class="summary-note">A successful booking requires the
							Oracle database connection to be configured and available.</p>
					</aside>
				</div>
			</div>
		</section>
	</main>
	<footer class="site-footer">
		<div class="container">
			<div class="footer-grid">
				<div class="footer-brand">
					<a class="brand" href="index.html"><span class="brand-mark">H</span><span
						class="brand-copy"><strong>Happy Homes</strong><small>Stay
								beautifully</small></span></a>
					<p>A calm, welcoming stay with thoughtful details and warm
						hospitality.</p>
				</div>
				<div class="footer-col">
					<h3>Explore</h3>
					<a href="index.html">Home</a><a href="About.jsp">Our story</a><a
						href="Gallery.jsp">Gallery</a>
				</div>
				<div class="footer-col">
					<h3>Bookings</h3>
					<a href="Book.jsp">Book a room</a><a href="About.jsp#facilities">Facilities</a>
				</div>
				<div class="footer-col">
					<h3>Contact</h3>
					<p>Morni Hills, Chandigarh, India</p>
					<a href="tel:+917399182000">+91 73991 82000</a><a
						href="mailto:happyhomehotel@gmail.com">happyhomehotel@gmail.com</a>
				</div>
			</div>
			<div class="footer-bottom">
				<span>© 2026 Happy Homes Hotel. All rights reserved.</span><span>Stay
					beautifully.</span>
			</div>
		</div>
	</footer>
	<script src="assets/js/site.js" defer></script>
	<script>document.getElementById('guests')?.addEventListener('change',e=>{const n=document.getElementById('summary-guests');if(n)n.textContent=e.target.value});</script>
</body>
</html>