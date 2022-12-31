import axios from '../../modules/axios';

export const createWorkspace = async workspace => {
  axios.post(
    `/v1/workspaces`,
    workspace,
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};

export const invite_user = async (currentWorkspace, email) => {
  return await axios.post(
    `/v1/workspaces/${currentWorkspace}/invite`,
    { email: email },
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};
