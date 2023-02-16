import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios';

export const pinnedMessages = (benchConversationId) => {
  return axios
    .get(
      `v1/pins?bench_conversation_id=${benchConversationId}`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};

export const pinMessage = (benchConversationId, messageId) => {
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
