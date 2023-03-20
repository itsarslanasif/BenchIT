import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const saveMessage = async message => {
  axios.post(
    `v1/saved_items`,
    { conversation_message_id: message.id },
    {
      headers: getHeaders(),
    }
  );
};
