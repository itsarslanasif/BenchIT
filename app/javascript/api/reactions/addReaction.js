import axios from '../../modules/axios';

export const addReaction = async (message_id, emoji) => {
  return await axios.post(
    `/v1/reactions`,
    {
      conversation_message_id: message_id,
      emoji: emoji,
    },
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};
