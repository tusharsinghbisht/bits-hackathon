import React, { useState } from "react";
import "./MyPatients.css";

export default function MyPatients() {
  const [selectedPatient, setSelectedPatient] = useState(null);
  const [searchTerm, setSearchTerm] = useState("");
  const [editing, setEditing] = useState(false);

  const patients = [
    {
      id: 1,
      name: "John Doe",
      age: 30,
      gender: "Male",
      phoneNumber: "9213131233",
      details: {
        dob: { day: 15, month: "July", year: 1993 },
        bloodGroup: "O+",
        height: 180,
        weight: 75,
        acuteConditions: ["Fever"],
        chronicConditions: ["Hypertension"],
        allergies: ["Pollen", "Peanuts"],
        pastSurgeries: ["Appendectomy"],
        medications: ["Metformin"],
      },
    },
    {
      id: 2,
      name: "Jane Smith",
      age: 28,
      gender: "Female",
      phoneNumber: "9243131233",
      details: {
        dob: { day: 22, month: "March", year: 1995 },
        bloodGroup: "A+",
        height: 165,
        weight: 60,
        acuteConditions: ["Cough"],
        chronicConditions: [],
        allergies: ["Dust"],
        pastSurgeries: [],
        medications: ["Paracetamol"],
      },
    },
  ];

  const handleView = (patient) => {
    setSelectedPatient(patient);
    setEditing(false)
  };

  const handleSearchChange = (e) => {
    setSearchTerm(e.target.value);
    setSelectedPatient(null); // Clear the selected patient when searching
  };

  const handleReset = () => {
    setSearchTerm("");
    setSelectedPatient(null); // Reset the selected patient when clearing search
  };

  const handleEdit = (patient) => {
    // Add your edit logic here
    setSelectedPatient(patient)
    setEditing(true)
    // console.log("Editing patient:", patient);
  };

  const filteredPatients = searchTerm
    ? patients.filter((patient) => patient.phoneNumber === searchTerm)
    : [];

  return (
    <div className="my-patients-container">
      <h1>My Patients</h1>
      <div className="search-bar">
        <input
          type="text"
          placeholder="Search by Mobile number"
          className="search-input"
          value={searchTerm}
          onChange={handleSearchChange}
        />
        <button className="reset-button" onClick={handleReset}>
          Reset
        </button>
      </div>

      <div className="patients-list">
        {filteredPatients.length > 0 ? (
          filteredPatients.map((patient) => (
            <div key={patient.id} className="patient-card">
              <h2>{patient.name}</h2>
              <p>
                {patient.age}, {patient.gender}
              </p>
              <p>{patient.phoneNumber}</p>
              <div className="button-group">
                <button
                  onClick={() => handleView(patient)}
                  className="view-button"
                >
                  View
                </button>
                <button
                  onClick={() => handleEdit(patient)}
                  className="edit-button"
                >
                  Edit
                </button>
              </div>
            </div>
          ))
        ) : (
          searchTerm && <p>Enter complete mobile number.</p>
        )}
      </div>

      {selectedPatient ? editing ? (
        <div className="patient-details">
        <h2>Edit Details for {selectedPatient.name}</h2>
        <p>
          <strong>DOB:</strong>{" "}
          {`${selectedPatient.details.dob.day} ${selectedPatient.details.dob.month}, ${selectedPatient.details.dob.year}`}
        </p>
        <p>
          <strong>Blood Group:</strong> {selectedPatient.details.bloodGroup}
        </p>
        <p>
          <strong>Height:</strong> <input type="text" name="" value={`${selectedPatient.details.height} cm`} />
        </p>
        <p>
          <strong>Weight:</strong> <input type="text" name="" value={`${selectedPatient.details.weight} kg`}/>
        </p>
        <p>
          <strong>Acute Conditions:</strong>{" "}
          <input type="text" name="" value={selectedPatient.details.acuteConditions.join(", ") || "None"} />
        </p>
        <p>
          <strong>Chronic Conditions:</strong>{" "}
          <input type="text" name="" value={selectedPatient.details.chronicConditions.join(", ") || "None"} />
        </p>
        <p>
          <strong>Allergies:</strong>{" "}
          <input type="text" name="" value={selectedPatient.details.allergies.join(", ") || "None"} />
        </p>
        <p>
          <strong>Past Surgeries:</strong>{" "}
          <input type="text" name="" value={selectedPatient.details.pastSurgeries.join(", ") || "None"} />
        </p>
        <p>
          <strong>Medications:</strong>{" "}
          <input type="text" name="" value={selectedPatient.details.medications.join(", ") || "None"} />
        </p>
        <button
          onClick={() => handleView(patient)}
          className="view-button"
        >
          Save
        </button>
      </div>
      ) : (
        <div className="patient-details">
          <h2>Details for {selectedPatient.name}</h2>
          <p>
            <strong>DOB:</strong>{" "}
            {`${selectedPatient.details.dob.day} ${selectedPatient.details.dob.month}, ${selectedPatient.details.dob.year}`}
          </p>
          <p>
            <strong>Blood Group:</strong> {selectedPatient.details.bloodGroup}
          </p>
          <p>
            <strong>Height:</strong> {selectedPatient.details.height} cm
          </p>
          <p>
            <strong>Weight:</strong> {selectedPatient.details.weight} kg
          </p>
          <p>
            <strong>Acute Conditions:</strong>{" "}
            {selectedPatient.details.acuteConditions.join(", ") || "None"}
          </p>
          <p>
            <strong>Chronic Conditions:</strong>{" "}
            {selectedPatient.details.chronicConditions.join(", ") || "None"}
          </p>
          <p>
            <strong>Allergies:</strong>{" "}
            {selectedPatient.details.allergies.join(", ") || "None"}
          </p>
          <p>
            <strong>Past Surgeries:</strong>{" "}
            {selectedPatient.details.pastSurgeries.join(", ") || "None"}
          </p>
          <p>
            <strong>Medications:</strong>{" "}
            {selectedPatient.details.medications.join(", ") || "None"}
          </p>
        </div>
      ): <></>}
    </div>
  );
}