import axios from "../../modules/axios";

export const getUnreadMessages = async id => {
  return axios
    .get(`v1/conversation_messages/unread_messages`, {
      headers: { Authorization: localStorage.getItem('token') },
    })
    .then(response => {
      return response.data;
    });
};
