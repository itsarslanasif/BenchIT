import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const fileDownload = async (attachment) => {
  return await axios.post(
    `/v1/downloads`,
    {
      download: {
        file_name: attachment.attachment.filename,
        file_link: attachment.attachment_link,
        file_download_link: attachment.attachment_download_link,
        file_type: attachment.attachment.content_type
      }
    },
    { headers: getHeaders() }
  );
};

export const getDownloads = async () => {
  return await axios
    .get('/v1/downloads', {
      headers: getHeaders(),
    })
};

export const deleteAllDownloads = async () => {
  return await axios.post('v1/downloads/clear_all', {
    headers: getHeaders(),
  });
}

export const deleteDownload = async id => {
  return await axios.delete(`/v1/downloads/${id}`, {
    headers: getHeaders(),
  });
};
