import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const pinnedMessages = (conversation_type, conversation_id) => {
  return axios
    .get(
      `v1/pins?conversation_type=${conversation_type}&conversation_id=${conversation_id}`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};

export const pinMessage = (
  benchConversationId,
  messageId
) => {
  return axios
    .post(
      `v1/pins`,
      {
        bench_conversation_id: benchConversationId,
        conversation_message_id: messageId,
      },
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};

export const unPinMessage = pin_id => {
  return axios
    .delete(`v1/pins/${pin_id}`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
