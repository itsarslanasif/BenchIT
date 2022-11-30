import axios from "../axios";

export const getMessageHistory = async (conversation_type, id) => {
    return axios
        .get(`/v1/${conversation_type}/${id}`)
        .then(response => {
            return response.data
        })
};
