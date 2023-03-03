import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const getGroups = async () => {
  let result = await axios.get(`/v1/groups`, {
    headers: getHeaders(),
  });
  return result.data.groups;
};

// export const getGroups = () => {
//    axios
//     .get(`/v1/groups`, {
//       headers: getHeaders(),
//     })
//     .then(response => {
//       return response;
//     });
// };
