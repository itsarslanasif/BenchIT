import axios from '../../modules/axios/index';
import { getHeaders } from '../../modules/auth';

export const setProfileStatus = async (
  currentWorkspaceID,
  currentProfileID,
  statusPayload
) => {
  return await axios
    .post(
      `/v1/workspaces/${currentWorkspaceID}/profiles/${currentProfileID}/set_status`,
      statusPayload,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};

export const getRecentStatuses = async () => {
  return await axios
    .get(`/v1/statuses`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const deleteRecentStatus = async id => {
  return await axios
    .delete(`/v1/statuses/${id}`, {
      headers: getHeaders(),
    })
    .then(response => {
      return response.data;
    });
};

export const clearStatus = async (currentWorkspaceID, currentProfileID) => {
  return await axios
    .post(
      `/v1/workspaces/${currentWorkspaceID}/profiles/${currentProfileID}/clear_status`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};

export const setActiveStatus = async (currentWorkspaceID, currentProfileID) => {
  return await axios
    .patch(
      `/v1/workspaces/${currentWorkspaceID}/profiles/${currentProfileID}`,
      {
        is_active: true,
      },
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};

export const removeActiveStatus = async (
  currentWorkspaceID,
  currentProfileID
) => {
  return await axios
    .patch(
      `/v1/workspaces/${currentWorkspaceID}/profiles/${currentProfileID}`,
      {
        is_active: false,
      },
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
};
