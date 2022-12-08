import axios from '../../modules/axios/index';

export const getDirectMessagesList = async () => {
  return axios
    .get(`v1/users/previous_direct_messages`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
