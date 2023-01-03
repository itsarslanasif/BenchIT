import axios from '../../modules/axios/index';

export const getDirectMessagesList = async id => {
  return axios
    .get(`v1/workspaces/${id}/profiles/previous_direct_messages`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
