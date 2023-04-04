import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const editTopic = async (conversation_id, value) => {
  return axios
    .patch(`v1/bench_conversations/${conversation_id}`, {
      headers: getHeaders(),
      topic: value,
    })
    .then(response => {
      return response.data;
    });
};
