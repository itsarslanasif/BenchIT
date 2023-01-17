import axios from '../../modules/axios/index';

export const setProfileStatus = async (
  currentWorkspaceID,
  currentProfileID,
  statusPayload
) => {
  return await axios
    .post(
      `/v1/workspaces/${currentWorkspaceID}/profiles/${currentProfileID}/set_status`,
      statusPayload, {
        headers: {
          Authorization: localStorage.getItem('token')
        },
      }
    )
    .then(response => {
      return response.data;
    });
};

export const getRecentStatuses = async () => {
  return await axios
    .get(`/v1/statuses`, {
      headers: {
        Authorization: localStorage.getItem('token'),
      },
    })
    .then(response => {
      return response.data;
    });
};

export const deleteRecentStatus = async (id) => {
  return await axios
    .delete(`/v1/statuses/${id}`, {
      headers: {
        Authorization: localStorage.getItem('token'),
      },
    })
    .then(response => {
      return response.data;
    });
};

export const clearStatus = async (currentWorkspaceID, currentProfileID) => {
  console.log(localStorage.getItem('token'))
  return await axios
    .post(
      `/v1/workspaces/${currentWorkspaceID}/profiles/${currentProfileID}/clear_status`, {
        headers: {
          Authorization: JSON.stringify(localStorage.getItem('token'))
        },
      }
    )
    .then(response => {
      return response.data;
    });
};
