import React from 'react'
import ReactDOM from 'react-dom';
import { Route, RouterProvider, createBrowserRouter, createRoutesFromElements } from 'react-router-dom'
import Home from './components/Home/Home.jsx'
import MyPatients from './components/MyPatients/MyPatients.jsx';
import DocumentCenter from './components/DocumentCenter/DocumentCenter.jsx'
import Layout from './Layout.jsx'


const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path='/' element={<Layout />}>
      <Route path='/' element={<Home />} />
      <Route path='/my-patients' element={<MyPatients />} />
      <Route path='/documentcenter' element={<DocumentCenter />} />
    </Route>
  )
)

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
)
