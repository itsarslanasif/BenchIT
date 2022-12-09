import axios from '../axios';

export const getMessageHistory = async (conversation_type, id) => {
  if (conversation_type === 'channels') {
    conversation_type = 'bench_channels';
  }
  return await axios
    .get(`/v1/${conversation_type}/${id}`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
