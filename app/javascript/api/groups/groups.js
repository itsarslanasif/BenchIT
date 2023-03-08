import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getGroups = async () => {
  let result = await axios.get(`/v1/groups`, {
    headers: getHeaders(),
  });
  return result.data.groups;
};

export const getGroup = async id => {
  return await axios
    .get(`/v1/groups/${id}`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const createGroup = async members => {
  let result = await axios.post(`/v1/groups`, {
    headers: getHeaders(),
      profile_ids:members
  });
  return result.data;
};

export const addGroupMembers = async (members,id) => {
  let result = await axios.post(`/v1/groups/${id}/add_member`, {
    headers: getHeaders(),
      profile_ids:members
  });
  return result.data;
};


