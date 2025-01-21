import React, { useState } from "react";
import "./DocumentCenter.css";

function DocumentCenter() {
  const [cards, setCards] = useState([
    {
      id: 1,
      name: "John Doe",
      age: 30,
      gender: "Male",
      Mobile: "9213131233",
      items: [
        { type: "Report", name: "Liver Function Test", date: "28th December 2024" },
        { type: "Report", name: "Lipid Profile", date: "28th December 2024" },
        { type: "Prescription", name: "Diabetes Medication", date: "28th December 2024" },
      ],
    },
    {
      id: 2,
      name: "Jane Smith",
      age: 28,
      gender: "Female",
      Mobile: "9243131233",
      items: [
        { type: "Report", name: "Blood Sugar Test", date: "28th December 2024" },
        { type: "Report", name: "MRI Scan", date: "28th December 2024" },
        { type: "Prescription", name: "Thyroid Medication", date: "28th December 2024" },
      ],
    },
  ]);

  const [filteredCards, setFilteredCards] = useState(cards);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCard, setSelectedCard] = useState(null);
  const [itemSearchQuery, setItemSearchQuery] = useState("");
  const [searchType, setSearchType] = useState("Report"); // Default to searching for reports

  const handleReset = () => {
    setSearchQuery(""); // Clear the search query
    setFilteredCards(cards); // Reset the filtered cards to all cards
  };

  const handleView = (card) => {
    setSelectedCard(card); // Navigate to the detailed view for this card
  };

  const closeItemView = () => {
    setSelectedCard(null); // Navigate back to the main card list
    setItemSearchQuery(""); // Clear the item search query
  };

  const filteredItems = selectedCard
    ? selectedCard.items.filter(
        (item) =>
          item.type === searchType &&
          item.name.toLowerCase().includes(itemSearchQuery.toLowerCase())
      )
    : [];

  return (
    <main>
      {!selectedCard ? (
        <>
          <div className="search-container">
            <input
              type="text"
              placeholder="Search by Mobile number"
              value={searchQuery}
              onChange={(e) => {
                const query = e.target.value;
                setSearchQuery(query); // Update the search query
                // Filter cards dynamically as the query changes
                setFilteredCards(
                  cards.filter((card) =>
                    card.Mobile.toLowerCase().includes(query.toLowerCase())
                  )
                );
              }}
            />
            <button onClick={handleReset} style={{ marginLeft: "10px" }}>
              Reset
            </button>
          </div>

          <div className="cards-container">
            {filteredCards.length > 0 ? (
              filteredCards.map((card) => (
                <div className="card" key={card.id}>
                  <h3>{card.name}</h3>
                  <p>
                    {card.age}, {card.gender}
                  </p>
                  <p>{card.Mobile}</p>
                  <div className="buttons">
                    <button className="view-btn" onClick={() => handleView(card)}>
                      View
                    </button>
                    <button className="upload-btn">Upload</button>
                  </div>
                </div>
              ))
            ) : (
              <p>No results found</p>
            )}
          </div>
        </>
      ) : (
        <>
          <div className="details-container">
            <button className="back-btn" onClick={closeItemView}>
              &larr; Back
            </button>
            <h2>{selectedCard.name}</h2>
            <p>
              {selectedCard.age}, {selectedCard.gender}
            </p>
            <p>Mobile: {selectedCard.Mobile}</p>

            <div className="search-container">
              <select
                value={searchType}
                onChange={(e) => setSearchType(e.target.value)}
                style={{ marginRight: "10px" }}
              >
                <option value="Report">Reports</option>
                <option value="Prescription">Prescriptions</option>
              </select>
              <input
                type="text"
                placeholder={`Search by ${searchType} name`}
                value={itemSearchQuery}
                onChange={(e) => setItemSearchQuery(e.target.value)}
              />
            </div>

            <div className="items-container">
              {filteredItems.length > 0 ? (
                filteredItems.map((item, index) => (
                  <div className="item-card" key={index}>
                    <h3>{item.name}</h3>
                    <p>{item.date}</p>
                    <p>{item.type}</p>
                    <button className="view-btn">View</button>
                  </div>
                ))
              ) : (
                <p>No {searchType.toLowerCase()}s found</p>
              )}
            </div>
          </div>
        </>
      )}
    </main>
  );
}

export default DocumentCenter;
