import React from "react";
import { Link, NavLink } from "react-router-dom";
import "./Header.css";

export default function Header() {
  return (
    <header className="header">
      {/* Logo Section */}
      <div className="logo">CareSathi</div>

      {/* Navigation Bar */}
      <nav className="navbar">
        <ul className="navbar-links">
          <li>
            <NavLink
              to="/"
              className={({ isActive }) => (isActive ? "active" : "")}
            >
              Home
            </NavLink>
          </li>
          
          <li>
            <NavLink
              to="/documentcenter"
              className={({ isActive }) => (isActive ? "active" : "")}
            >
              Document Center
            </NavLink>
          </li>
          <li>
            <NavLink
              to="/my-patients"
              className={({ isActive }) => (isActive ? "active" : "")}
            >
              My Patients
            </NavLink>
          </li>
        </ul>
      </nav>
    </header>
  );
}