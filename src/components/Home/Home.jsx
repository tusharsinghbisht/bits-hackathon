import React from "react";
import agencyImage from "./agency.png";
import "./Home.css";

export default function Home() {
  return (
    <div className="home-container">
      <div className="content-wrapper"> {/* Wrap content in a flexbox container */}
        <div className="agency-details">
          <h1>Agency Details</h1>
          <p>
            <strong>Agency Name:</strong> HealthCare Agency
          </p>
          <p>
            <strong>Agency ID:</strong> 12345
          </p>
          <p>
            <strong>Address:</strong> 123 Main St, City, State, ZIP
          </p>
          <p>
            <strong>Phone Number:</strong> (123) 456-7890
          </p>
          <p>
            <strong>Email:</strong> contact@healthcareagency.com
          </p>
          <p>
            <strong>Type:</strong> Hospital
          </p>
        </div>
        <div className="agency-image">
          <img src={agencyImage} alt="Agency Image" />
        </div>
      </div>
    </div>
  );
}