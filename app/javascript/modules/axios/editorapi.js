import axios from '../../modules/axios';
import { getHeaders } from '../auth';

export const conversation = async payload => {
  await axios.post(`/v1/conversation_messages`, payload, {
    headers: getHeaders(),
  });
};
