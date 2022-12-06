import axios from 'axios';

export const userSignOut = async token => {
  let result = await axios.get('http://127.0.0.1:5100/users/sign_out', {
    headers: { Authorization: token },
  });
  sessionStorage.removeItem('token');
  return result;
};
