import axios from './index';

export const userSignOut = async token => {
  let result = await axios.get('/users/sign_out', {
    headers: { Authorization: token },
  });
  sessionStorage.removeItem('token');
  return result;
};
