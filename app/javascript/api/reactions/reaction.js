import axios from '../../modules/axios';

export const add_reaction = async (message_id, emoji) => {
  return await axios.post(
    `/v1/reactions`,
    {
      conversation_message_id: message_id,
      emoji: emoji,
    },
    { headers: { Authorization: sessionStorage.getItem('token') } }
  );
};

export const remove_reaction = async id => {
  return await axios.delete(`/v1/reactions/${id}`, {
    headers: { Authorization: sessionStorage.getItem('token') },
  });
};
