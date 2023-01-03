import axios from '../../modules/axios';

export const deleteMessage = id => {
  return axios
    .delete(`v1/conversation_messages/${id}`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
