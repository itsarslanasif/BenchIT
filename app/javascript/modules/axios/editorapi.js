import axios from '../../modules/axios';

export const conversation = async payload => {
  await axios.post(`/v1/conversation_messages`, payload, {
    headers: { Authorization: localStorage.getItem('token') },
  });
};



export const updateMessage = async payload => {
  await axios.patch(`/v1/conversation_messages/${payload.id}`, payload, {
    headers: { Authorization: localStorage.getItem('token') },
  });
};
