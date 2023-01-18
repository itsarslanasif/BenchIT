import { defineStore } from 'pinia';
import { getHeaders } from '../modules/auth';

export const SampleStore = defineStore('users', {
  state: () => {
    return {
      user: {},
      users: [],
    };
  },

  actions: {
    async index() {
      return this.axios
        .get('/users', {
          headers: getHeaders(),
        })
        .then(response => {
          this.users = response.data.users;
        });
    },
    async show(id) {
      return this.axios
        .get(`/user/${id}`, {
          headers: getHeaders(),
        })
        .then(response => {
          this.user = response.data.user;
        });
    },
  },
});
