<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description"
	content="Explore the rooms, facilities and shared spaces at Happy Homes Hotel.">
<title>Gallery | Happy Homes Hotel</title>
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
					href="Book.jsp">Rooms and Booking</a><a href="Gallery.jsp">Gallery</a><a
					href="About.jsp#contact">Contact</a>
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
				<div class="breadcrumb"><a href="index.html">HOME / </a><a href="Gallery.jsp"> GALLERY</a></div>
				<span class="eyebrow">A closer look</span>
				<h1 class="display">Spaces to make memories.</h1>
				<p>Explore the rooms, shared spaces and little details that make
					a Happy Homes stay.</p>
			</div>
		</section>
		<section class="section">
			<div class="container">
				<div class="section-head">
					<span class="eyebrow">The gallery</span>
					<h2 class="display">Take a look around</h2>
					<p>Select any image to view it larger.</p>
				</div>
				<div class="gallery-grid">
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View The hotel">
						<img src="Happy_Hotel.jpg" alt="The hotel" ><span
							class="gallery-caption">The hotel</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View A warm welcome">
						<img src="reception.jpg" alt="A warm welcome" ><span
							class="gallery-caption">A warm welcome</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Restful bedrooms">
						<img src="Deluxe_Room.jpeg" alt="Restful bedrooms" ><span
							class="gallery-caption">Restful bedrooms</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Swimming pool">
						<img src="Pool.jpg" alt="Swimming pool" ><span
							class="gallery-caption">Swimming pool</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Dining spaces">
						<img src="Dinning.webp" alt="Dining spaces" ><span
							class="gallery-caption">Dining spaces</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Relaxing living area">
						<img src="living.jpg" alt="Relaxing living area"><span
							class="gallery-caption">Relaxing living area</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Garden moments">
						<img src="garden.jpg" alt="Garden moments"><span
							class="gallery-caption">Garden moments</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Fitness centre">
						<img src="gym.webp" alt="Fitness centre"><span
							class="gallery-caption">Fitness centre</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Banquet hall">
						<img src="banquet.webp" alt="Banquet hall"><span
							class="gallery-caption">Banquet hall</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Games & leisure">
						<img src="games.avif" alt="Games & leisure"><span
							class="gallery-caption">Games and leisure</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Kitchen details">
						<img src="kitchen.webp" alt="Kitchen details"><span
							class="gallery-caption">Kitchen details</span>
					</button>
					<button class="gallery-item" type="button" data-gallery-image
						aria-label="View Safety & security">
						<img src="security.webp" alt="Safety & security"><span
							class="gallery-caption">Safety and security</span>
					</button>
				</div>
				<div class="text-center mt-3">
					<a class="btn btn-dark" href="Book.jsp">Make it your stay <span
						aria-hidden="true">→</span></a>
				</div>
			</div>
		</section>
		<div class="gallery-modal" data-gallery-modal aria-hidden="true"
			role="dialog" aria-modal="true" aria-label="Expanded gallery image">
			<button class="modal-close" type="button" data-gallery-close
				aria-label="Close image">×</button>
			<img src="" alt="Expanded hotel gallery image">
		</div>
	</main>
	<footer class="site-footer">
		<div class="container">
			<div class="footer-grid">
				<div class="footer-brand">
					<a class="brand" href="index.html"><span class="brand-mark">H</span><span
						class="brand-copy"><strong>Happy Homes</strong><small>Stay
								beautifully</small></span></a>
					<p>A calm, welcoming stay with thoughtful details, warm
						hospitality and spaces that feel like yours.</p>
				</div>
				<div class="footer-col">
					<h3>Explore</h3>
					<a href="index.html">Home</a><a href="About.jsp">Our story</a><a
						href="Book.jsp">Rooms and booking</a><a href="Gallery.jsp">Gallery</a>
				</div>
				<div class="footer-col">
					<h3>Guest services</h3>
					<a href="Book.jsp">Check availability</a><a
						href="About.jsp#facilities">Facilities</a><a
						href="About.jsp#contact">Contact us</a><a href="About.jsp#contact">Getting
						here</a>
				</div>
				<div class="footer-col" id="contact">
					<h3>Get in touch</h3>
					<p>Morni Hills, Chandigarh, India</p>
					<p>
						<a href="tel:+917399182000">+91 73991 82000</a><a
							href="mailto:happyhomehotel@gmail.com">happyhomehotel@gmail.com</a>
					</p>
				</div>
			</div>
			<div class="footer-bottom">
				<span>© 2026 Happy Homes Hotel. All rights reserved.</span><span>Made
					for memorable stays.</span>
			</div>
		</div>
	</footer>
	<script src="assets/js/site.js" defer></script>
</body>
</html>