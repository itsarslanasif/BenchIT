import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const unsave = id =>
  axios.delete(`/v1/saved_items/${id}`, {
    headers: getHeaders(),
  });
