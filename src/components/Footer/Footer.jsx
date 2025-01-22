import React from 'react';
import './Footer.css';
import { Link } from 'react-router-dom';
import logo from "./caresathi.png"

function Footer() {
  return (
    <footer className="footer">
      <div className="footer-container">
        {/* Footer Links */}
        <div className="footer-links">
          <Link to="/" className="footer-link">Home</Link>
          <Link to="/about" className="footer-link">About</Link>
          <Link to="/contact" className="footer-link">Contact</Link>
        </div>

        {/* Social Links */}
        <div className="footer-social">
          <img src={logo} style={{ width: "70px", aspectRatio: 1 }} alt="CareSathi" />
        </div>
      </div>
    </footer>
  );
}

export default Footer;
