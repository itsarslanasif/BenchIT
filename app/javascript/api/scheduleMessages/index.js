import axios from '../../modules/axios';
import { getHeaders } from '../../modules/auth';

export const getScheduleMessages = async () => {
  return axios
    .get(`v1/schedule_messages`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const sendScheduledMessageNow = async id => {
  return axios
    .get(`v1/schedule_messages/${id}/send_now`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const deleteScheduledMessage = async id => {
  return axios
    .delete(`v1/schedule_messages/${id}`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const editScheduledContent = async payload => {
  return axios
    .patch(`v1/schedule_messages/${payload.id}`, { content: payload.content }, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};
