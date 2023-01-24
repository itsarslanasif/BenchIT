import axios from "../../modules/axios";
import { getHeaders } from "../../modules/auth";

export const getScheduleMessages = () => {
  return axios
    .get(
      `v1/schedule_messages`,
      {
        headers: getHeaders(),
      }
    )
    .then(response => {
      return response.data;
    });
}
