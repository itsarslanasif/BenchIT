import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const createWorkspace = async workspace => {
  axios.post(
    `/v1/workspaces`,
    workspace,
    { headers: getHeaders() }
  );
};

export const invite_user = async (currentWorkspace, email) => {
  return await axios.post(
    `/v1/workspaces/${currentWorkspace}/invite`,
    { email: email },
    { headers: getHeaders() }
  );
};

export const joinedWorkspaces = async () => {
  return axios.get('v1/workspaces/', { headers: getHeaders() })
    .then((response) => {
      return response.data.workspaces
    })
}
