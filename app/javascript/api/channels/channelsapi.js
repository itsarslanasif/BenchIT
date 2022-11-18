import axios from "axios";

export const getChannels=async()=>{
  let result = axios.get("https://mocki.io/v1/f4eff2a8-537f-4feb-9095-265e27a28085");
  return ((await result).data);
}
