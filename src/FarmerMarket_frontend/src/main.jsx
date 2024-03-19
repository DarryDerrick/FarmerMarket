import React, { useState, useEffect } from 'react';
import axios from 'axios';

const FarmerMarketApp = () => {
  const [farmers, setFarmers] = useState([]);
  const [newFarmer, setNewFarmer] = useState({});

  // Fetch all farmers from backend on component mount
  useEffect(() => {
    fetchFarmers();
  }, []);

  // Function to fetch all farmers from backend
  const fetchFarmers = async () => {
    try {
      const response = await axios.get('http://127.0.0.1:4943/?canisterId=br5f7-7uaaa-aaaaa-qaaca-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai/api/getAllFarmers');
      setFarmers(response.data);
    } catch (error) {
      console.error('Error fetching farmers:', error);
    }
  };

  // Function to handle form submission and register a new farmer
  const handleSubmit = async (event) => {
    event.preventDefault();
    try {
      await axios.post('http://127.0.0.1:4943/?canisterId=br5f7-7uaaa-aaaaa-qaaca-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai/api/registerFarmer', newFarmer);
      setNewFarmer({});
      fetchFarmers(); // Refresh farmers list after registration
    } catch (error) {
      console.error('Error registering farmer:', error);
    }
  };

  // Function to handle input change in the form
  const handleChange = (event) => {
    const { name, value } = event.target;
    setNewFarmer((prevFarmer) => ({
      ...prevFarmer,
      [name]: value,
    }));
  };

  return (
    <div>
      <h1>Farmer Market Dashboard</h1>
      <h2>Register New Farmer</h2>
      <form onSubmit={handleSubmit}>
        <label>
          Name:
          <input type="text" name="name" value={newFarmer.name || ''} onChange={handleChange} />
        </label>
        <label>
          Produce:
          <input type="text" name="produce" value={newFarmer.produce || ''} onChange={handleChange} />
        </label>
        <label>
          Quantity:
          <input type="number" name="quantity" value={newFarmer.quantity || ''} onChange={handleChange} />
        </label>
        <label>
          Price:
          <input type="number" name="price" value={newFarmer.price || ''} onChange={handleChange} />
        </label>
        <button type="submit">Register Farmer</button>
      </form>
      <h2>Farmers</h2>
      <ul>
        {farmers.map((farmer) => (
          <li key={farmer.id}>
            {farmer.name} - {farmer.produce} - {farmer.quantity} - {farmer.price}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default FarmerMarketApp;

