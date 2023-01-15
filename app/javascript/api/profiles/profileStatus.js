import axios from '../../modules/axios/index';

export const setProfileStatus = async statusPayload => {
  return await axios
    .post(`/v1/statuses`,statusPayload, {
      headers: {
        Authorization: localStorage.getItem('token')
      },
    })
    .then(response => {
      return response.data;
    });
};


export const getRecentStatuses = async () => {
  return await axios
    .get(`/v1/statuses`,{
      headers: {
        Authorization: localStorage.getItem('token')
      },
    })
    .then(response => {
      return response.data;
    });
};


export const deleteRecentStatus = async (id) => {
  return await axios
    .get(`/v1/statuses/${id}`,{
      headers: {
        Authorization: localStorage.getItem('token')
      },
    })
    .then(response => {
      return response.data;
    });
};




