import axios from "../../modules/axios";

export const unstar =  id =>
axios.delete('http://127.0.0.1:5100/api/v1/favourites/'+id);
