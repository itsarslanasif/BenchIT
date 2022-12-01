import axios from '../../modules/axios/index'

export const getAllProfiles = async () => {
  return await axios.get(`/v1/users`).then(response => {
    return response.data;
  });
}
