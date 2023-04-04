import axios from './index';

export const userSignOut = async token => {
  let result = await axios.get('/users/sign_out', {
    headers: { Authorization: token },
  });
  localStorage.removeItem('token');
  localStorage.removeItem('currentUser');
  sessionStorage.removeItem('currentWorkspace');
  sessionStorage.removeItem('currentProfile');
  return result;
};
