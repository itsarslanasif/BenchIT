import axios from 'axios';
import { getHeaders } from '../auth';

export default axios.create({
  baseURL: `${import.meta.env.VITE_APP_SERVER_URL}/api`,
  headers: getHeaders(),
});
