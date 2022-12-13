import axios from '../../modules/axios';

export const getsavemessages = async () => {
  return await axios
    .get(`/v1/conversation_messages/index_saved_messages`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
