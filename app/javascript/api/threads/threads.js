import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getThreads = async () => {
  return axios
    .get(`v1/conversation_messages/threads`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
