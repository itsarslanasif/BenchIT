import axios from "axios";

export const getChannels = async () => {
  let response = await axios.get("/v1/bench_channels");
  return response.data;
}
