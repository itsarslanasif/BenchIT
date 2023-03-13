import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const deleteMessage = async id => {
  return axios
    .delete(`v1/conversation_messages/${id}`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
