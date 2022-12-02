import axios from "axios";

export const createWorkspace = async (workspace) => {
  axios.post(`${import.meta.env.VITE_APP_SERVER_URL}api/v1/workspaces`, workspace)
};

