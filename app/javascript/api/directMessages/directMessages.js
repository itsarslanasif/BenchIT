import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getDirectMessagesList = async id => {
  return axios
    .get(`v1/workspaces/${id}/profiles/previous_direct_messages`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const getLastDirectMessagesList = async dmIDs => {
  console.log(dmIDs);
  return axios
    .post(
      `v1/conversation_messages/last_messages`,
      { dmIDs: dmIDs },
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};
