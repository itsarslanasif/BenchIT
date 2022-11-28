import axios from "axios";

export const getChannels=async()=>{
  let result = axios.get("/v1/channels");
  return ((await result).data);
}
