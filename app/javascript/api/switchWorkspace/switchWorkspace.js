import axios from '../../modules/axios/index';

export const switchWorkspace = async id => {
  return await axios
    .get(`v1/workspaces/${id}/switch_workspace`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
