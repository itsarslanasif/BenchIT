import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const save = (id, data) =>
  axios.post(`/v1/saved_items`, { conversation_message_id: id }, data, {
    headers: getHeaders(),
  });
