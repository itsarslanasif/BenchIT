import axios from '../../modules/axios/index';

export const switchWorkspace = async id => {
  return axios
    .get(`v1/workspaces/${id}/switch_workspace`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      console.log(response.data)
      return response.data;
    });
};
