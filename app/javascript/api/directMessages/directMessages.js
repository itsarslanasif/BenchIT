import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getDirectMessagesList = async () => {
  return axios
    .get(`v1/dm_users`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const getLastDirectMessagesList = async () => {
  return axios
    .get(
      `v1/dm_users/last_direct_messages`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};
