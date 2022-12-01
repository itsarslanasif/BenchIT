import axios from '../../modules/axios';

export const conversation = async payload => {
  await axios.post(`/v1/conversation_messages`, payload);
};
