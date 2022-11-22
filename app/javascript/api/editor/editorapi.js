import axios from "axios";

export const conversation = async (payload) => {
  await axios.post(`http://127.0.0.1:5100/api/v2/conversation_messages`, payload,{ headers: {
    Authorization: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI1NjBjZTRlYy1hMmUyLTRhZDctYTQ4MS05N2RjNzZiNTMzODMiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjY5MTI4OTQ2LCJleHAiOjE2NjkxMzYxNDZ9.vXvkfF6XT9uZUGCm9LmmfMgCgs2Cz8wXaECBp5aA_7E'
  }});
}
