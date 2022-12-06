import axios from "../../modules/axios/index";

export const getDirectMessagesList = async () => {
  let result = axios.get(`v1/users/previous_direct_messages`, {
  });
  return ((await result).data.users_ids);
}
