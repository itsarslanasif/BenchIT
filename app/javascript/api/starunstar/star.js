import axios from "../../modules/axios";

export const star =  data =>
axios.post('http://127.0.0.1:5100/api/v1/favourites',data);
