import axios from '../../modules/axios/index'
import { getHeaders } from '../../modules/auth';

export const getSearching = async (query, filter) => {
  return await axios
    .get(`/v1/searches`, {
      headers: getHeaders(),
      params: { query: query, filter: filter },
    })
    .then(response => {
      return response.data;
    });
}
