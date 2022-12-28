import axios from '../../modules/axios/index';

export const getAllProfiles = async workspace_id => {
  return await axios
    .get(`/v1/workspaces/${workspace_id}/profiles`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
