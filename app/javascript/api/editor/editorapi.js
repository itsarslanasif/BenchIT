import axios from "../../modules/axios";

export const conversation = async (payload) => {
  await axios.post(`api/v1/conversation_messages`, payload,{ headers: {
    Authorization: ''
  }});
}

