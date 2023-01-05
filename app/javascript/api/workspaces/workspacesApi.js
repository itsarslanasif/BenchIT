import axios from '../../modules/axios';

export const createWorkspace = async workspace => {
  axios.post(
    `/v1/workspaces`,
    workspace,
    { headers: { Authorization: localStorage.getItem('token') } }
  );
};

export const invite_user = async (currentWorkspace, email) => {
  return await axios.post(
    `/v1/workspaces/${currentWorkspace}/invite`,
    { email: email },
    { headers: { Authorization: localStorage.getItem('token') } }
  );
};

export const joinedWorkspaces = async () => {
  return axios.get('v1/workspaces/', { headers: { Authorization: localStorage.getItem('token') } }).then((response) => {
    return response.data.workspaces
  })
}
