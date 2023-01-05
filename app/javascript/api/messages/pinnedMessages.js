import axios from '../../modules/axios';

export const pinnedMessages = (conversation_type, conversation_id) => {
  return axios
    .get(
      `v1/pins?conversation_type=${conversation_type}&conversation_id=${conversation_id}`,
      {
        headers: { Authorization: sessionStorage.getItem('token') },
      }
    )
    .then(response => {
      return response.data;
    });
};

export const createPin = (conversation_type, conversation_id, message_id) => {
  return axios
    .post(
      `v1/pins`,
      {
        conversation_type: conversation_type,
        conversation_id: conversation_id,
        conversation_message_id: message_id,
      },
      {
        headers: { Authorization: sessionStorage.getItem('token') },
      }
    )
    .then(response => {
      return response.data;
    });
};
