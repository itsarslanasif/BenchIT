import axios from '../../modules/axios';
import { getHeaders } from '../../modules/auth';

export const getChannel = async channelId => {
  return await axios
    .get(`/v1/bench_channels/${channelId}`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const getChannels = async (
  query,
  sort,
  filter,
  hideMyChannels,
  page
) => {
  return axios
    .get(`/v1/bench_channels`, {
      headers: getHeaders(),
      params: {
        query: query,
        sort_by: sort,
        filter: filter,
        hide_my_channels: hideMyChannels,
        page: page,
      },
    })
    .then(response => {
      return response.data;
    });
};

export const getJoinedChannels = async () => {
  return await axios
    .get(`/v1/bench_channels/joined_channels`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const getChannelMembers = async (query, bench_channel_id) => {
  return await axios
    .get(`/v1/channel_participants`, {
      headers: getHeaders(),
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
      headers: getHeaders(),
    }
  );
};

export const memberLeaveChannel = async channel_id => {
  return await axios
    .delete(`v1/bench_channels/${channel_id}/leave_channel`, {
      headers: getHeaders(),
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
      headers: getHeaders(),
    }
  );
};

export const updateChannel = async (channel_id, is_private, value, name) => {
  return await axios.patch(
    `/v1/bench_channels/${channel_id}`,
    {
      bench_channel: {
        description: value,
        is_private: is_private,
        name: name,
      },
    },
    {
      headers: getHeaders(),
    }
  );
};
