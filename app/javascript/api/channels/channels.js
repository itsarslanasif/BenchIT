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

export const getChannelMembers = async (query, bench_channel_id) => {
  return await axios
    .get(`/v1/channel_participants`, {
      headers: { Authorization: sessionStorage.getItem('token') },
      params: { query: query, bench_channel_id: bench_channel_id },
    })
    .then(response => {
      return response.data.profiles;
    });
};

export const createChannel = async (name, description, is_private) => {
  return await axios.post(
    `/v1/bench_channels`,
    {
      bench_channel: {
        name: name,
        description: description,
        is_private: is_private,
      },
    },
    {
      headers: { Authorization: sessionStorage.getItem('token') },
    }
  );
};

export const memberLeaveChannel = async channel_id => {
  return await axios
    .delete(`v1/bench_channels/${channel_id}/leave`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
