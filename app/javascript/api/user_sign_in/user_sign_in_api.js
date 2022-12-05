import axios from 'axios';

export const userSignIn = async payload => {
  let result = axios.post('http://127.0.0.1:5100/users/sign_in', payload);
  return (await result);
};
