import axios from "axios";

export const getMembers = async (workspace, query, sort) => {
  let result = axios.get(`${import.meta.env.VITE_APP_SERVER_URL}/api/v1/workspaces/${workspace}/profiles`, {
    params: {
      workspace: workspace,
      query: query,
      sort: sort,
    },
  });
  return ((await result).data.profiles);
}
