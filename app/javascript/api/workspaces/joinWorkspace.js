import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios/index';

export const joinWorkspace = async (workspace_id, username, description) => {
  return axios
    .post(
      `/v1/workspaces/${workspace_id}/profiles`,
      {
        username: username,
        description: description,
        workspace_id: workspace_id,
      },
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response;
    });
};
