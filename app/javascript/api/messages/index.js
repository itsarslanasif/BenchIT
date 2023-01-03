import axios from '../../modules/axios'

export const deleteMessage = (id) => {
  return axios
    .delete(`v1/conversation_messages/${id}`, {
      headers: { Authorization: sessionStorage.getItem('token') },
    })
    .then(response => {
      console.log('Message deleted', response)
      return response.data
    })
}
