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


export const getChannelMembers = async (query,bench_channel_id) => {
  return await axios
    .get(`/v1/channel_participants`, {
      headers: { Authorization: sessionStorage.getItem('token') },
      params:{
        query: query,
        bench_channel_id:bench_channel_id
      }
    })
    .then(response => {
      return response.data;
    });
};
