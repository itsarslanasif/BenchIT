import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const getReactions = async () => {
  return axios
    .get(`v1/conversation_messages/reactions`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
