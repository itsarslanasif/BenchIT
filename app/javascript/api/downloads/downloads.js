import axios from '../../modules/axios/index';

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
    { headers: { Authorization: localStorage.getItem('token') } }
  );
};

export const getDownloads = async () => {
  return await axios
    .get('/v1/downloads', {
      headers: { Authorization: localStorage.getItem('token') },
    })
};

export const deleteAllDownloads = async () => {
  return await axios.post('v1/downloads/destroy_all', {
    headers: { Authorization: localStorage.getItem('token') },
  });
}

export const deleteDownload = async id => {
  return await axios.delete(`/v1/downloads/${id}`, {
    headers: { Authorization: localStorage.getItem('token') },
  });
};
