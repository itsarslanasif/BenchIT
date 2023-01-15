import axios from '../../modules/axios';

export const getChannel = async channelId => {
  return await axios
    .get(`/v1/bench_channels/${channelId}`, {
      headers: { Authorization: localStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};

export const getChannels = async query => {
  return await axios
    .get(`/v1/bench_channels`, {
      headers: { Authorization: localStorage.getItem('token') },
      params: {
        query: query,
      },
    })
    .then(response => {
      return response.data;
    });
};

export const getJoinedChannels = async () => {
  return await axios
    .get(`/v1/bench_channels/joined_channels`, {
      headers: { Authorization: localStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};

export const getChannelMembers = async (query, bench_channel_id) => {
  return await axios
    .get(`/v1/channel_participants`, {
      headers: { Authorization: localStorage.getItem('token') },
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
      headers: { Authorization: localStorage.getItem('token') },
    }
  );
};

export const memberLeaveChannel = async channel_id => {
  return await axios
    .delete(`v1/bench_channels/${channel_id}/leave`, {
      headers: { Authorization: localStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};

export const memberJoinChannel = async channel_id => {
  return await axios.post(
    `/v1/channel_participants/join_public_channel`,
    {
      bench_channel_id: channel_id,
    },
    {
      headers: { Authorization: localStorage.getItem('token') },
    }
  );
};
