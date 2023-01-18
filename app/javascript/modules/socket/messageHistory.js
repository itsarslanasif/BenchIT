import axios from '../axios';

export const getMessageHistory = async (conversation_type, id, page) => {
  if (conversation_type === 'channel') {
    conversation_type = 'bench_channel';
  }
  return await axios
    .get(`/v1/conversation_messages/${id}/${conversation_type}_messages`, {
      headers: { Authorization: localStorage.getItem('token') },
      params: {
        page,
      },
    })
    .then(response => {
      return response.data;
    });
};
