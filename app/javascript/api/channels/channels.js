import axios from '../../modules/axios';

export const getChannels = async (query) => {
  return await axios
    .get(`/v1/bench_channels`, {
      headers: { Authorization: sessionStorage.getItem('token') }, params: {
        query: query,
      },
    })
    .then(response => {
      return response.data;
    });
};
