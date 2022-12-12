import axios from "../../modules/axios";

export const star = data => axios.post('/v1/favourites', data, { headers: { Authorization: sessionStorage.getItem('token') } });
