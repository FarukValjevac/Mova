import React from 'react';
import EarlyBirdForm from './components/EarlyBirdForm';
import './App.css';

const App: React.FC = () => {
  return (
    <div className="app">
      <div className="container">
        <header className="header">
          <div className="logo">
            <h1>Mova</h1>
          </div>
        </header>

        <main className="main">
          <div className="hero">
            <h2 className="coming-soon">Coming Soon</h2>
            <p className="subtitle">
              Revolutionary movement equipment is on its way. 
              Be among the first to experience the future.
            </p>
          </div>

          <div className="form-section">
            <EarlyBirdForm />
          </div>
        </main>

        <footer className="footer">
          <p>&copy; 2025 Mova. All rights reserved.</p>
        </footer>
      </div>
    </div>
  );
};

export default App;