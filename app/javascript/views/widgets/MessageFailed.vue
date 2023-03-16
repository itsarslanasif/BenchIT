<template>
  <div class="text-xs">
    <p class="text-gray-600 font-semibold">
      <font-awesome-icon icon="fa-xmark" class="pr-1 text-sm" />
      {{ $t('connection.message_failed') }}
    </p>
    <div class="flex gap-3 my-2">
      <p
        @click="deleteMessage"
        class="hover:text-white hover:bg-danger text-danger py-0.5 px-2 border border-danger hover:border-transparent rounded duration-200 cursor-pointer"
      >
        <font-awesome-icon icon="fa-trash" class="pr-1" />
        {{ $t('connection.delete') }}
      </p>
      <p
        @click="retry"
        class="hover:text-white hover:bg-info text-info py-0.5 px-2 border border-info hover:border-transparent rounded duration-200 cursor-pointer"
      >
        <font-awesome-icon icon="fa-arrow-rotate-right" class="pr-1" />
        {{ $t('connection.retry') }}
      </p>
    </div>
  </div>
</template>

<script>
import { useConnectionStore } from '../../stores/useConnectionStore.js';
import { useMessage } from 'naive-ui';
export default {
  props: {
    message: {
      type: Object,
    },
  },

  setup() {
    const connectionStore = useConnectionStore();
    const message = useMessage();

    const error = errorMessage => {
      message.error(errorMessage);
    };

    const success = successMessage => {
      message.success(successMessage);
    };

    return {
      connectionStore,
      error,
      success,
    };
  },

  methods: {
    deleteMessage() {
      this.connectionStore.deleteMessage(this.message);
      this.success(this.$t('connection.message_deleted_successfully'));
    },
    retry() {
      this.error(this.$t('connection.not_connected_to_internet'));
    },
  },
};
</script>
