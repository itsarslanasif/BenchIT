import axios from './index';

export const userSignUp = async payload => {
  let result = axios.post('/users', { user: payload });
  debugger;
  return await result;
};
