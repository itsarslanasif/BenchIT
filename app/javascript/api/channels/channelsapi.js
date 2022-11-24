import axios from "axios";

export const getChannels=async()=>{
  let result = axios.get("http://127.0.0.1:5100/api/v1/channels");
  return ((await result).data);
}
