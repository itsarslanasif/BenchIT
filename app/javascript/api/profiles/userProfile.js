import axios from '../../modules/axios/index';

export const getUserProfile = async (workspace_id, profile_id) => {
  return await axios
    .get(`/v1/workspaces/${workspace_id}/profiles/${profile_id}`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
