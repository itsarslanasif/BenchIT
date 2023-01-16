import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getMembers = async (workspace, query, sort) => {
  let result = axios.get(`/v1/workspaces/${workspace}/profiles`, {
    headers: getHeaders(),
    params: {
      workspace: workspace,
      query: query,
      sort: sort,
    },
  });
  return (await result).data;
};

export const addMemberstoChannel = async (channel_id, members) => {
  return await axios.post(
    `/v1/channel_participants`,
    {
      bench_channel_id: channel_id,
      profile_ids: members,
    },
    { headers: getHeaders() }
  );
};
