import axios from '../../modules/axios/index';

export const getMessages = async () => {
  return await axios
    .get(`/v1/conversation_messages/send_message`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};

