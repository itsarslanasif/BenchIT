import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const unsave = id =>
  axios.delete(`/v1/conversation_messages/${id}/unsave_message`, {
    headers: getHeaders(),
  });
