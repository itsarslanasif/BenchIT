import axios from '../../modules/axios'

export const getChannels = async () => {
  return await axios.get(`/v1/bench_channels`).then(response => {
    return response.data;
  });
}
