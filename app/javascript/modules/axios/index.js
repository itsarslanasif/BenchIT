import axios from 'axios';
export default axios.create({
  baseURL: `http://localhost:3000/api`,
  headers: { Authorization: sessionStorage.getItem('token') },
});
