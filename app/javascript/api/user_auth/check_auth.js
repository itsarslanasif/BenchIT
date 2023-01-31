import axios from './index';

export const checkAuth = async () => {
  try {
    const { data } = await axios.get('/check_auth');
    if (data.success === true) {
      return true;
    } else {
      return false;
    }
  }
  catch (err) {
    return false;
  }
};
