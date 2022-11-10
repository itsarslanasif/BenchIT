import axios from 'axios';

export default axios.create({
  baseURL: 'http://localhost:3000/workspace/api/v1/identities/4',
});
