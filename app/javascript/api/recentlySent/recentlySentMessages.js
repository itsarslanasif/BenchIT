import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios/index';

export const getMessages = async () => {
  return await axios
    .get(`/v1/conversation_messages/sent_message`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data.messages;
    });
};

