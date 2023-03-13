import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const getSaveMessages = async () => {
  return await axios
    .get(`/v1/saved_items`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data.saved_items;
    });
};
