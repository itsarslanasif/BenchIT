import axios from '../../modules/axios';

export const pinnedMessages = (conversation_type, conversation_id) => {
  return axios
    .get(
      `v1/pins?conversation_type=${conversation_type}&conversation_id=${conversation_id}`,
      {
        headers: { Authorization: localStorage.getItem('token') },
      }
    )
    .then(response => {
      return response.data;
    });
};

export const pinMessage = (conversation_type, conversation_id, message_id) => {
  return axios
    .post(
      `v1/pins`,
      {
        conversation_type: conversation_type,
        conversation_id: conversation_id,
        conversation_message_id: message_id,
      },
      {
        headers: { Authorization: localStorage.getItem('token') },
      }
    )
    .then(response => {
      return response.data;
    });
};

export const unPinMessage = (pin_id) => {
  return axios
    .delete(
      `v1/pins${pin_id}`,
      {
        headers: { Authorization: localStorage.getItem('token') },
      }
    )
    .then(response => {
      return response.data;
    });
};
