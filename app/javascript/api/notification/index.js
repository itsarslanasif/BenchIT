import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const getUnreadMessages = async id => {
  return axios
    .get(`v1/conversation_messages/unread_messages`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
