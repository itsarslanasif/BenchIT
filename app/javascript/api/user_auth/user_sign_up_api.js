import axios from './index';

export const userSignUp = async payload => {
  let result = axios.post('api/v1/users', { user: payload });
  return await result;
};
