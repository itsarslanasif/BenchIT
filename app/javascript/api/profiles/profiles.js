import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios/index';

export const getAllProfiles = async workspace_id => {
  return await axios
    .get(`/v1/workspaces/${workspace_id}/profiles`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const updateCurrentProfile = async (
  workspace_id,
  profile_id,
  payload
) => {
  return await axios
    .patch(`/v1/workspaces/${workspace_id}/profiles/${profile_id}`, payload, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
