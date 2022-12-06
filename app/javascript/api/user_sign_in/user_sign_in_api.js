import axios from 'axios';

export const userSignIn = async payload => {
  let result = axios.post('http://localhost:5100/users/sign_in', payload);
  return await result;
};
