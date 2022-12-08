import axios from "axios";

export const saveMessage = async (message) => {
  axios.post(`${import.meta.env.VITE_APP_SERVER_URL}api/v1/conversation_messages/${message.id}/save_message`)
};
