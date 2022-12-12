import axios from '../../modules/axios/index';

export const getMembers = async (workspace, query, sort) => {
  let result = axios.get(
    `/v1/workspaces/${workspace}/profiles`,
    {
      headers: { Authorization: sessionStorage.getItem('token') },
    },
    {
      params: {
        workspace: workspace,
        query: query,
        sort: sort,
      },
    }
  );
  return (await result).data.profiles;
};

export const addMemberstoChannel = async (channel_id, members) => {
  return await axios.post(
    `/v1/channel_participants`,
    {
      bench_channel_id: channel_id,
      user_ids: members,
    },
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};
