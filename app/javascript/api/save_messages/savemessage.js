import axios from '../../modules/axios';

export const save = (id, data) =>
  axios.post(`/v1/conversation_messages/${id}/save_message`, data, {
    headers: { Authorization: sessionStorage.getItem('token') },
  });
