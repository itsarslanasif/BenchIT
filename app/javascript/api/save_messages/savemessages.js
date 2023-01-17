import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const getSaveMessages = async () => {
  return await axios
    .get(`/v1/conversation_messages/index_saved_messages`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
