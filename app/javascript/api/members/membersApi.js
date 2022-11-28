import axios from "axios";

export const getMembers = async ( workspace,query,sort) => {
  let result = axios.get(`http://127.0.0.1:5100/api/v1/workspaces/${workspace}/profiles`, {
    params: {
      workspace: workspace,
      query: query,
      sort: sort,
    },
  });
  return ((await result).data.profiles);
}

//  return ((await result).data.profiles);
