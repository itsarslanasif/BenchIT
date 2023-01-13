import { defineStore } from 'pinia';

export const useApiResponseStatusStore = defineStore(
  'useApiResponseStatusStore',
  {
    state: () => ({
      responseStatus: null,
      successMessage: '',
      errorMessage: '',
    }),
    actions: {
      setApiResponseStatus(responseStatus) {
        this.responseStatus = responseStatus;
      },
      setApiResponseStatusNull() {
        this.responseStatus = null;
      },
    },
  }
);
