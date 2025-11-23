<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>NexusBank — Smart. Secure. Seamless.</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

  <style>
    :root {
      --primary: #0066ff;
      --primary-dark: #0044cc;
      --bg-light: #f8faff;
      --text-dark: #1e1e1e;
      --text-light: #555;
      --white: #fff;
      --radius: 12px;
      --transition: 0.3s ease;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: "Poppins", sans-serif;
      color: var(--text-dark);
      background-color: var(--bg-light);
      scroll-behavior: smooth;
    }

    /* Navbar */
    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 18px 5%;
      background: var(--white);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
      position: sticky;
      top: 0;
      z-index: 1000;
    }

    .logo {
      font-size: 1.6em;
      font-weight: 700;
      color: var(--primary);
      display: flex;
      align-items: center;
    }

    .logo i {
      margin-right: 10px;
    }

    .nav-links a {
      text-decoration: none;
      margin: 0 15px;
      font-weight: 600;
      color: var(--text-dark);
      position: relative;
    }

    .nav-links a::after {
      content: "";
      position: absolute;
      bottom: -5px;
      left: 0;
      width: 0%;
      height: 2px;
      background: var(--primary);
      transition: width var(--transition);
    }

    .nav-links a:hover::after {
      width: 100%;
    }

    .auth-buttons .btn {
      margin-left: 10px;
    }

    /* Buttons */
    .btn {
      padding: 10px 22px;
      border: none;
      border-radius: var(--radius);
      font-weight: 600;
      cursor: pointer;
      transition: var(--transition);
    }

    .login-btn {
      background: var(--primary);
      color: var(--white);
    }

    .login-btn:hover {
      background: var(--primary-dark);
    }

    .register-btn,
    .primary-btn {
      background: var(--primary);
      color: var(--white);
    }

    .register-btn:hover,
    .primary-btn:hover {
      background: var(--primary-dark);
    }

    /* Hero Section */
    .hero-section {
      background: linear-gradient(135deg, #0066ff 0%, #00aaff 100%);
      color: var(--white);
      text-align: center;
      padding: 120px 5%;
    }

    .hero-section h1 {
      font-size: 3em;
      margin-bottom: 15px;
    }

    .hero-section h1 span {
      color: #ffe000;
    }

    .hero-section p {
      max-width: 700px;
      margin: 0 auto 25px;
      font-size: 1.1em;
    }

    .hero-actions {
        display: flex;
        flex-direction: row;
        justify-content: center;
        gap: 30px;
        align-items: center;
    }

    .text-link {
      color: var(--white);
      text-decoration: underline;
      font-weight: 600;
      text-align: center;
    }

    /* About Section */
    .about-section {
      padding: 100px 5%;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap-reverse;
      gap: 50px;
      background: linear-gradient(135deg, #e0f0ff, #ffffff);
      border-radius: var(--radius);
      box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05);
    }

    .about-image {
      flex: 1;
      text-align: center;
    }

    .about-image img {
      max-width: 420px;
      border-radius: var(--radius);
      box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
      transition: transform 0.4s ease, box-shadow 0.4s ease;
    }

    .about-image img:hover {
      transform: scale(1.05);
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    }

    .about-content {
      flex: 1;
      min-width: 300px;
    }

    .about-content h2 {
      font-size: 2.8em;
      margin-bottom: 25px;
      color: var(--primary);
    }

    .about-content h2 span {
      color: var(--text-dark);
    }

    .about-content p {
      color: var(--text-light);
      margin-bottom: 25px;
      line-height: 1.8;
      font-size: 1.1em;
    }

    .about-features {
      list-style: none;
      margin-bottom: 30px;
    }

    .about-features li {
      margin-bottom: 15px;
      font-size: 1.05em;
      color: var(--text-dark);
    }

    .about-features li i {
      color: var(--primary);
      margin-right: 10px;
    }

    /* Services Section */
    .services-section {
      padding: 100px 5%;
      background: #f5f5f5;
      text-align: center;
      color: #fff;
    }

    .services-section h2 {
      color: var(--primary);
      font-size: 2.8em;
      margin-bottom: 50px;
    }

    .services-section h2 span {
      color: var(--text-dark);
    }

    .service-cards {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 30px;
    }

    .card {
      background: #2c2f36;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 6px 20px rgba(0,0,0,0.2);
      transition: transform 0.4s ease, box-shadow 0.4s ease;
      cursor: pointer;
      height: 400px;
      width: 300px;
    }

    .card:hover {
      transform: translateY(-10px);
      box-shadow: 0 12px 30px rgba(0, 170, 255, 0.5);
    }

    .card-image {
      width: 100%;
      height: 220px;
      background-size: cover;
      background-position: center;
    }

    .card-content {
      padding: 20px;
      height: calc(100% - 220px);
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      text-align: center;
    }

    .card-content h3 {
      color: #00ffff;
      font-size: 1.3em;
      margin-bottom: 10px;
    }

    .card-content p {
      color: #ccc;
      font-size: 1em;
      line-height: 1.6;
    }

    /* Contact */
    .contact-section {
      background: #f9fafc;
      padding: 80px 5%;
      font-family: 'Poppins', sans-serif;
      text-align: center;
    }

    .section-title {
      font-size: 2.5em;
      color: var(--primary);
      margin-bottom: 60px;
      font-weight: 700;
    }

    .section-title span {
      color: var(--text-dark);
    }

    .contact-container {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      gap: 60px;
      flex-wrap: wrap;
      text-align: left;
    }

    .contact-info {
      display: flex;
      flex-direction: column;
      gap: 10px;
      width: 350px;
    }

    .info-box {
      background: #fff;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }

    .info-box h3 {
      color: var(--primary);
      font-size: 1.1em;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .info-box i {
      color: #e91e63;
      font-size: 1.2em;
    }

    .info-box p {
      color: #555;
      font-size: 0.95em;
      line-height: 1.6;
    }

    .contact-form-box {
      background: #fff;
      border-radius: 12px;
      padding: 52px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
      width: 450px;
    }

    .contact-form-box h2 {
      color: var(--primary);
      margin-bottom: 25px;
      text-align: center;
    }

    .contact-form {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .contact-form input,
    .contact-form textarea {
      width: 100%;
      padding: 12px 15px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 1em;
    }

    .contact-form input:focus,
    .contact-form textarea:focus {
      color: var(--primary);
      outline: none;
    }

    .btn.primary-btn {
      color: #ffffff;
      border: none;
      padding: 12px;
      border-radius: 8px;
      font-size: 1em;
      cursor: pointer;
      transition: background 0.3s ease;
    }

    .btn.primary-btn:hover {
      background: #00aaff;
    }

    /* Footer */
    .footer {
      background: var(--primary-dark);
      color: var(--white);
      padding: 60px 5% 30px;
    }

    .footer-container {
      display: flex;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 40px;
    }

    .footer-section h3 {
      margin-bottom: 20px;
    }

    .footer-section ul {
      list-style: none;
    }

    .footer-section ul li {
      margin-bottom: 8px;
    }

    .footer-section ul li a {
      color: var(--white);
      text-decoration: none;
      transition: color var(--transition);
    }

    .footer-section ul li a:hover {
      color: #ffe000;
    }

    .footer-section p {
      margin-bottom: 10px;
    }

    .footer-section i {
      margin-right: 10px;
      color: #ffe000;
    }

    .social-icons a {
      color: var(--white);
      margin-right: 15px;
      font-size: 1.4em;
      transition: color var(--transition);
    }

    .social-icons a:hover {
      color: #ffe000;
    }

    .footer-bottom {
      text-align: center;
      border-top: 1px solid rgba(255,255,255,0.2);
      margin-top: 30px;
      padding-top: 15px;
      font-size: 0.9em;
    }

    /* Responsive */
    @media (max-width: 992px) {
      .service-cards {
        grid-template-columns: repeat(2, 1fr);
      }
    }

    @media (max-width: 900px) {
      .contact-container {
        flex-direction: column;
        align-items: center;
        gap: 30px;
      }

      .contact-info,
      .contact-form-box {
        width: 100%;
        max-width: 500px;
      }
    }

    @media (max-width: 768px) {
      .hero-section h1 {
        font-size: 2.2em;
      }

      .hero-actions {
        flex-direction: column;
      }

      .about-section {
        flex-direction: column;
        text-align: center;
      }

      .service-cards {
        grid-template-columns: 1fr;
      }

      .footer-container {
        flex-direction: column;
        text-align: center;
      }
    }
  </style>
</head>

<body>
  <!-- Navbar -->
  <header class="navbar">
    <div class="logo">
      <i class="fas fa-landmark"></i>
      <span class="bank-name">NexusBank</span>
    </div>

    <nav class="nav-links">
      <a href="#home">Home</a>
      <a href="#about">About</a>
      <a href="#services">Services</a>
      <a href="#contact">Contact</a>
    </nav>

    <div class="auth-buttons">
     	<a href="SignIn.jsp">
  			<button type="button" class="btn login-btn">Login</button>
		</a>
		<a href="SignUp.jsp">
  			<button type="button" class="btn register-btn">Register</button>
		</a>
	</div>
  </header>

  <!-- Hero Section -->
  <section id="home" class="hero-section">
    <div class="hero-content">
      <h1>Bank Smarter with <span>NexusBank</span></h1>
      <p>Empowering your financial journey with seamless, secure, and transparent banking solutions — anytime, anywhere.</p>
      <div class="hero-actions">
      	<a href="AccountType.jsp">
        	<button class="btn primary-btn">Open an Account</button>
        </a>
        <a href="#services" class="text-link">View Services →</a>
      </div>
    </div>
  </section>

  <!-- About Section -->
  <section id="about" class="about-section">
    <div class="about-image">
      <img src="https://www.idfcfirstbank.com/content/dam/idfcfirstbank/images/blog/mobile-banking/how-new-age-banking-is-transforming-the-banking-industry-717x404.jpg" alt="Digital Banking Illustration" />
    </div>
    <div class="about-content">
      <h2>About <span>Us</span></h2>
      <p>NexusBank has been at the forefront of digital banking since 1998, combining technology, trust, and transparency. We empower customers with intuitive, seamless, and secure banking solutions designed for the modern world.</p>
      <ul class="about-features">
        <li><i class="fas fa-check-circle"></i> Secure online transactions</li>
        <li><i class="fas fa-check-circle"></i> Customer-first support 24/7</li>
        <li><i class="fas fa-check-circle"></i> Innovative digital tools</li>
      </ul>
      <button class="btn primary-btn">Learn More</button>
    </div>
  </section>

  <!-- Services Section -->
  <section id="services" class="services-section">
    <h2>Our <span>Services</span></h2>
    <div class="service-cards">
      <div class="card">
        <div class="card-image" style="background-image: url('https://www.pathwaybank.com/assets/files/uhWFol37/Checking-vs.-Savings.jpg');"></div>
        <div class="card-content">
          <h3>Checking & Savings</h3>
          <p>Instant access accounts with zero hidden fees and real-time monitoring.</p>
        </div>
      </div>

      <div class="card">
        <div class="card-image" style="background-image: url('https://www.ftc.gov/sites/default/files/styles/wide_standard_sm/public/ftc_gov/images/BusinessCredit-640x360.png?h=7a6e80fd&itok=afs-dT5a');"></div>
        <div class="card-content">
          <h3>Loans & Credit</h3>
          <p>Flexible personal loans and credit lines with competitive interest rates.</p>
        </div>
      </div>

      <div class="card">
        <div class="card-image" style="background-image: url('https://www.localmarketlaunch.com/wp-content/uploads/2019/12/stockmarket.jpg');"></div>
        <div class="card-content">
          <h3>Investments</h3>
          <p>Grow your wealth with curated investment portfolios and expert insights.</p>
        </div>
      </div>

      <div class="card">
        <div class="card-image" style="background-image: url('https://t4.ftcdn.net/jpg/02/90/20/37/360_F_290203792_VjIVJ40veTvAqv6y88AHKiZlo0SaCsIY.jpg');"></div>
        <div class="card-content">
          <h3>Insurance</h3>
          <p>Protect your assets and family with our range of insurance plans.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- Contact Section -->
<section id="contact" class="contact-section">
    <h2 class="section-title">Contact <span>Us</span></h2>
    <div class="contact-container">
        <div class="contact-info">
            <div class="info-box">
                <h3><i class="fas fa-map-marker-alt"></i> Head Office</h3>
                <p>45 Finance Avenue,<br>Bengaluru, India</p>
            </div>

            <div class="info-box">
                <h3><i class="fas fa-phone"></i> Phone</h3>
                <p>1-900-NexusBank<br>(+91 98765 43210)</p>
            </div>

            <div class="info-box">
                <h3><i class="fas fa-envelope"></i> Email</h3>
                <p>info@nexusbank.com<br>support@nexusbank.com</p>
            </div>

            <div class="info-box">
                <h3><i class="fas fa-clock"></i> Business Hours</h3>
                <p>Mon - Fri: 9:00 AM - 6:00 PM<br>Sat: 10:00 AM - 2:00 PM</p>
            </div>
        </div>

        <div class="contact-form-box">
            <h2>Send us a Message</h2>

            <% 
                String status = (String) request.getAttribute("mailStatus");
                String msgText = (String) request.getAttribute("msg");
            %>

            <% if (status != null) { %>
                <div style="
                    padding:15px;
                    margin-bottom:20px;
                    border-radius:10px;
                    font-family:Poppins;
                    font-size:16px;
                    font-weight:500;
                    color:white;
                    text-align:center;
                    background:<%= status.equals("success") ? "#28a745" : "#dc3545" %>;
                ">
                    <%= msgText %>
                </div>
            <% } %>

            <form class="contact-form" action="sendMessage" method="post">
                <input type="text" name="name" placeholder="Your Name" required>
                <input type="email" name="email" placeholder="Your Email" required>
                <input type="text" name="subject" placeholder="Subject" required>
                <textarea name="message" placeholder="Your Message" rows="5" required></textarea>
                <button type="submit" class="btn primary-btn">Send Message</button>
            </form>

        </div>
    </div>
</section>


  <!-- Footer -->
  <footer class="footer">
    <div class="footer-container">
      <div class="footer-section">
        <h3>Quick Links</h3>
        <ul>
          <li><a href="#home">Home</a></li>
          <li><a href="#about">About</a></li>
          <li><a href="#services">Services</a></li>
          <li><a href="#contact">Contact</a></li>
        </ul>
      </div>

      <div class="footer-section">
        <h3>Contact Info</h3>
        <p><i class="fas fa-envelope"></i> support@nexusbank.com</p>
        <p><i class="fas fa-envelope"></i> info@nexusbank.com</p>
        <p><i class="fas fa-phone"></i> +91 98765 43210</p>
        <p><i class="fas fa-map-marker-alt"></i> 45 Finance Avenue, Bengaluru, India</p>
      </div>

      <div class="footer-section">
        <h3>Follow Us</h3>
        <div class="social-icons">
          <a href="#"><i class="fab fa-facebook-f"></i></a>
          <a href="#"><i class="fab fa-twitter"></i></a>
          <a href="#"><i class="fab fa-linkedin-in"></i></a>
          <a href="#"><i class="fab fa-instagram"></i></a>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <p>© 2025 NexusBank. All Rights Reserved.</p>
    </div>
  </footer>
</body>
</html>
