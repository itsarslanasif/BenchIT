import axios from '../../modules/axios';

export const createWorkspace = async workspace => {
  axios.post(
    `/v1/workspaces`,
    workspace,
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};

export const invite_user = async (currentWorkspace, workspace_invite) => {
  return await axios.post(
    `/v1/workspaces/${currentWorkspace}/invite`,
    workspace_invite,
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};
