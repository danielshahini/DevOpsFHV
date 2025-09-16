import axios from 'axios'

// In Dev zeigt '/api' über den Vite-Proxy auf http://localhost:8081
const baseURL = '/api/v1'; // <-- passt zu deinem Controller

export const api = axios.create({ baseURL });
