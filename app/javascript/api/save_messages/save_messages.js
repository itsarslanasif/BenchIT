import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const saveMessage = async message => {
  axios.post(`v1/conversation_messages/${message.id}/save_message`, {
    headers: getHeaders(),
  });
};
