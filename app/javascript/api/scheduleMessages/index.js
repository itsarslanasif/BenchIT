import axios from "../../modules/axios";
import { getHeaders } from "../../modules/auth";

export const getScheduleMessages = () => {
  console.log('Hello World')
  return axios
    .get(
      `api/v1/schedule_messages`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      console.log(response)
      return response.data;
    });
}
