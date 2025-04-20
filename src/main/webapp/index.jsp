<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Financial Portfolio Manager</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;700&display=swap"
	rel="stylesheet">
<style>
html {
	scroll-behavior: smooth;
}

body {
	font-family: 'Poppins', sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f2f2f2;
}

.navbar {
	background-color: #00274D;
	position: fixed;
	width: 100%;
	top: 0;
	z-index: 999;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.navbar-brand, .nav-link {
	color: white !important;
	font-weight: 500;
}

.nav-link:hover {
	background-color: #0056b3;
	color: #fff !important;
	border-radius: 5px;
}

.hero {
	background: url('Resources/Land-Image.jpg') no-repeat center center/cover;
	height: 100vh;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	text-align: center;
	color: white;
	position: relative;
}

section {
	scroll-margin-top: 100px; /* This is already set */
	padding-top: 100px; /* Adjust based on navbar height */
}

.hero::before {
	content: "";
	position: absolute;
	top: 0;
	left: 0;
	height: 100%;
	width: 100%;
	background-color: rgba(0, 39, 77, 0.6);
	z-index: 0;
}

.hero-content {
	position: relative;
	z-index: 1;
	max-width: 800px;
	margin-top: 60px;
}

.hero h1 {
	font-size: 3.5rem;
	font-weight: 700;
}

h5 {
	color: #003366; /* deep navy */
	font-weight: 600;
}

.hero p {
	font-size: 1.3rem;
	margin-top: 20px;
}

.btn-primary {
	background-color: #00bfff;
	border: none;
	font-size: 1rem;
}

.btn-primary:hover {
	background-color: #009acd;
}

.features, .why-choose {
	padding: 80px 20px;
	text-align: center;
}

.feature-box {
	padding: 30px;
	border-radius: 10px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
	background-color: #f8f9fa;
	transition: transform 0.3s ease;
}

.feature-box:hover {
	transform: translateY(-5px);
}

.feature-icon {
	font-size: 50px;
	color: #0056b3;
	margin-bottom: 20px;
}

.why-choose .card {
	border: none;
	transition: transform 0.3s ease;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
	display: flex; /* Enable flexbox for vertical alignment */
	flex-direction: column;
	height: 100%;
}

.why-choose .card:hover {
	transform: translateY(-10px);
}

.why-choose .card-body {
	display: flex; /* Enable flexbox for horizontal alignment of image and text */
	flex-direction: column;
	align-items: flex-start; /* Align items to the start (top in column direction) */
	text-align: left; /* Re-align text to the left within the card body */
	flex-grow: 1; /* Allow the body to take up space */
}

.why-choose .card-title {
	margin-bottom: 1rem;
}

.get-started {
	background-color: #00274D;
	color: white;
	padding: 60px 20px;
	text-align: center;
}

footer {
	background-color: #00274D;
	color: white;
	padding: 20px 0;
	text-align: center;
}

section {
	scroll-margin-top: 100px;
}

.why-choose .card-img-top {
	object-fit: cover;
	height: 200px; /* Or whatever height you want */
}
</style>
<script src="https://kit.fontawesome.com/a076d05399.js"
	crossorigin="anonymous"></script>
</head>
<body>

	<nav class="navbar navbar-expand-lg navbar-dark">
		<div class="container">
			<a class="navbar-brand" href="#">FinManage</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNav">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav ms-auto">
					<li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
					<li class="nav-item"><a class="nav-link" href="#features">Features</a></li>
					<li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
					<li class="nav-item"><a class="nav-link" href="register.jsp">Register</a></li>
					<li class="nav-item"><a class="nav-link" href="admin-login.jsp">Admin</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<section class="hero" id="home">
		<div class="hero-content">
			<h1>Smart Financial Portfolio Management</h1>
			<p>Securely monitor, grow, and control your investments.</p>
			<a href="#features" class="btn btn-primary mt-4 px-4 py-2">Explore
				Features</a>
		</div>
	</section>

	<section class="features container" id="features">
		<h2 class="mb-5">Key Platform Features</h2>
		<div class="row g-4">
			<div class="col-md-4 d-flex">
				<div class="feature-box h-100 w-100">
					<div class="feature-icon">
						<i class="fas fa-chart-line"></i>
					</div>
					<h5>Live Portfolio Tracking</h5>
					<p>Monitor market changes and your investments in real-time
						with rich dashboards.</p>
				</div>
			</div>
			<div class="col-md-4 d-flex">
				<div class="feature-box h-100 w-100">
					<div class="feature-icon">
						<i class="fas fa-user-shield"></i>
					</div>
					<h5>Bank-Level Security</h5>
					<p>We use top encryption practices to keep your financial data
						secure and private.</p>
				</div>
			</div>
			<div class="col-md-4 d-flex">
				<div class="feature-box h-100 w-100">
					<div class="feature-icon">
						<i class="fas fa-file-alt"></i>
					</div>
					<h5>Reports & Analysis</h5>
					<p>Download detailed reports and insights to stay ahead with
						your finances.</p>
				</div>
			</div>
			<div class="col-md-4 d-flex">
				<div class="feature-box h-100 w-100">
					<div class="feature-icon">
						<i class="fas fa-chart-pie"></i>
					</div>
					<h5>Investment Insights</h5>
					<p>Get actionable insights and analytics to optimize your
						investment strategy.</p>
				</div>
			</div>

			<div class="col-md-4 d-flex">
				<div class="feature-box h-100 w-100">
					<div class="feature-icon">
						<i class="fas fa-cogs"></i>
					</div>
					<h5>Customizable Dashboards</h5>
					<p>Create personalized dashboards to track what matters most to
						you.</p>
				</div>
			</div>

			<div class="col-md-4 d-flex">
				<div class="feature-box h-100 w-100">
					<div class="feature-icon">
						<i class="fas fa-hand-holding-usd"></i>
					</div>
					<h5>Smart Portfolio Rebalancing</h5>
					<p>Automatically rebalance your portfolio based on market
						conditions and your goals.</p>
				</div>
			</div>

		</div>
	</section>

	<section class="why-choose container" id="why">
		<h2 class="mb-5">Why Choose FinManage?</h2>
		<div class="row g-4">
			<div class="col-md-4">
				<div class="card h-100">
					<img src="Resources/Data-Security.jpg" class="card-img-top"
						alt="Secure Platform">
					<div class="card-body">
						<h5 class="card-title">Data Security First</h5>
						<p class="card-text">Advanced authentication and encrypted
							transactions keep your money and data safe.</p>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card h-100">
					<img src="Resources/Real-Time-Analytics.jpg" class="card-img-top"
						alt="Real-Time Analytics">
					<div class="card-body">
						<h5 class="card-title">Real-Time Insights</h5>
						<p class="card-text">Understand your portfolio with visual
							graphs, charts, and alerts as markets move.</p>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card h-100">
					<img src="Resources/Expert-Support.avif" class="card-img-top"
						alt="Personal Support">
					<div class="card-body">
						<h5 class="card-title">Expert Support</h5>
						<p class="card-text">Our team is ready to assist you anytime
							with insights, tips, or technical help.</p>
					</div>
				</div>
			</div>
		</div>
	</section>

	<section class="get-started">
		<h2>Ready to Take Control of Your Finances?</h2>
		<p class="lead mt-3">Join thousands of users managing their
			portfolios with FinManage.</p>
		<a href="register.jsp" class="btn btn-primary mt-4 px-4 py-2">Create
			Your Free Account</a>
	</section>

	<footer>
		<div class="container">
			<p>&copy; 2025 FinManage. All rights reserved.</p>
		</div>
	</footer>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth',
            block: 'start'
        });
    });
});

// Highlight active section on scroll
const sections = document.querySelectorAll('section');
const navLinks = document.querySelectorAll('.nav-link');

window.addEventListener('scroll', () => {
    let current = '';
    
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        if (pageYOffset >= sectionTop - 60) {
            current = section.getAttribute('id');
        }
    });

    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});
</script>
</body>
</html>
