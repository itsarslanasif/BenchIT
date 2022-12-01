import axios from "axios";

export const getDirectMessagesList = async (currentUser) => {
  let result = axios.get(`${import.meta.env.VITE_APP_SERVER_URL}/api/v1/users/previous_direct_messages`, {
    params: {
      id: currentUser,
    },
  });
  return ((await result).data.users_ids);
}
