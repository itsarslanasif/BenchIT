import axios from '../../modules/axios';

export const getChannels = async () => {
  return await axios
    .get(`/v1/bench_channels`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
