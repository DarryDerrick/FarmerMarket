import { useState } from 'react';
import { FarmerMarket_backend } from 'declarations/FarmerMarket_backend';

function App() {
  const [greeting, setGreeting] = useState('');

  async function handleSubmit(event) {
    event.preventDefault();
    const name = event.target.elements.name.value;
    try {
      const greeting = await FarmerMarket_backend.greet(name);
      setGreeting(greeting);
    } catch (error) {
      console.error('Error fetching greeting:', error);
      setGreeting('Error fetching greeting');
    }
  }

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" onSubmit={handleSubmit}>
        <label htmlFor="name">Enter your name: &nbsp;</label>
        <input id="name" alt="Name" type="text" />
        <button type="submit">Click Me!</button>
      </form>
      <section id="greeting">{greeting}</section>
    </main>
  );
}

export default App;
