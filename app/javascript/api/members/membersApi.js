import axios from "../../modules/axios/index";

export const getMembers = async (workspace, query, sort) => {
  let result = axios.get(`/v1/workspaces/${workspace}/profiles`, {
    params: {
      workspace: workspace,
      query: query,
      sort: sort,
    },
  });
  return ((await result).data.profiles);
}

export const addMemberstoChannel = async (channel, members) => 
{
  // let result = await axios.post(`/v1/channel_participants`, {
  //   params: {   
  //     bench_channel_name : channel ,
  //     user_ids : members
  //   },
  // })
  // console.log(result)
  // return ((await result).data.members);

  
  console.log(channel, members)
  return await axios.post(`/v1/channel_participants`, 
    {   
      bench_channel_name : channel,
      user_ids : members
    })
  }
