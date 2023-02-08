import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getDirectMessagesList = async () => {
  return axios
    .get(`v1/dm_lists`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const getLastDirectMessagesList = async () => {
  return axios
    .get(
      `v1/dm_lists/last_messages`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};
