import axios from '../../modules/axios/index';

export const getAllProfiles = async () => {
  return await axios
    .get(`/v1/users`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
