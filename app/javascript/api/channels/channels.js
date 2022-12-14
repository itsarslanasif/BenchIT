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

export const memberLeaveChannel = async (channel_id) => {
  return await axios
    .delete(`v1/bench_channels/${channel_id}/leave`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
}