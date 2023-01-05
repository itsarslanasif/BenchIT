import axios from "../../modules/axios";

export const unstar = id => axios.delete('/v1/favourites/' + id, { headers: { Authorization: localStorage.getItem('token') } });
