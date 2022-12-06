import axios from './index';

export const userSignIn = async payload => {
  let result = axios.post('/users/sign_in', payload);
  return await result;
};
