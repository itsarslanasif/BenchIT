import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios/index';

export const switchWorkspace = async id => {
  return await axios
    .get(`v1/workspaces/${id}/switch_workspace`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
