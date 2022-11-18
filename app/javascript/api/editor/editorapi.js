import axios from "axios";

export const conversation = async (payload) => {
  await axios.post(`http://127.0.0.1:5100/api/v2/conversation_messages`, payload);
}
