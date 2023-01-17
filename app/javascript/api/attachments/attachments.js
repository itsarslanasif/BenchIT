import axios from '../../modules/axios'
import { getHeaders } from '../../modules/auth'

export const getAllRecentAttachments = () => {
  return axios
    .get('v1/conversation_messages/recent_files', {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data
    })
}

export const getFileFromURL = (attachment) => {
  return fetch(attachment.attachment_link).then(async response => {
    const contentType = response.headers.get('content-type');
    const blob = await response.blob();
    const file = new File([blob], attachment.attachment.filename, {
      contentType,
    });
    return file
  });
}