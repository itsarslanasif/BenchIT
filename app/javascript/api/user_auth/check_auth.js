import axios from './index';

export const checkAuth = async () => {
  try {
    const { data } = await axios.get('/check_auth');
    return data.success
  } catch (e) {
    return false;
  }
}
