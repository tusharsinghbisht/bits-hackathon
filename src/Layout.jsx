import React from 'react';
import Header from './components/Header/Header';
import Footer from './components/Footer/Footer';
import { Outlet } from 'react-router-dom';
import './Layout.css'; // Ensure this CSS is imported

function Layout() {
  return (
    <div id="root">
      <Header />
      <div className="main-content">
        <Outlet />
      </div>
      <Footer />
    </div>
  );
}

export default Layout;
