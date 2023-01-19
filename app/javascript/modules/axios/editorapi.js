import axios from '../../modules/axios';
import { getHeaders } from '../auth';

export const conversation = async payload => {
  await axios.post(`/v1/conversation_messages`, payload, {
    headers: getHeaders(),
  });
};

export const updateMessage = async payload => {
  await axios.patch(`/v1/conversation_messages/${payload.id}`, payload, {
    headers: getHeaders(),
  });
};
