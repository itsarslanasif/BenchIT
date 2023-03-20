import { getHeaders } from '../../modules/auth';
import axios from '../../modules/axios/index';

export const getSentMessages = async page => {
  return await axios
    .get(`/v1/conversation_messages/sent_message`, {
      headers: getHeaders(),
      params: {
        page,
      },
    })
    .then(response => {
      return response.data;
    });
};

export const fetchDraftMessages = async page => {
  return await axios
    .get(`/v1/draft_messages`, {
      headers: getHeaders(),
      params: {
        page,
      },
    })
    .then(response => {
      return response.data;
    });
};

