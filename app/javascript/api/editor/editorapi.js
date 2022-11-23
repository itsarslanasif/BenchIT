import axios from "../../modules/axios";

export const conversation = async (payload) => {
  await axios.post(`api/v2/conversation_messages`, payload,{ headers: {
    Authorization: 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI0MjI2YTBiZi0wYWRjLTQ1NTAtYjFiZS02NmU4OWQyNzlhZWIiLCJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjY5MjA4MjYyLCJleHAiOjE2NjkyMTU0NjJ9.5G4NydLqTdMw3yQNd2jEyMMNCh-mhEotH_kvx5s2Wgo'
  }});
}

