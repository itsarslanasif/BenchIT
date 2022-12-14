import axios from '../../modules/axios'

export const getAllRecentAttachments = () => {
  return axios.get('v1/conversation_messages/recent_files', {
    headers: { Authorization: sessionStorage.getItem('token') },
  })
    .then(response => {
      return response.data
    })
}