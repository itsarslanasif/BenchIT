<template>
  <div class="text-xs">
    <p class="text-gray-600 font-semibold">
      <font-awesome-icon icon="fa-xmark" class="pr-1 text-sm" />
      Failed to send
    </p>
    <div class="flex gap-3 my-2">
      <p
        @click="deleteTheMessage"
        class="hover:text-white hover:bg-danger text-danger py-0.5 px-2 border border-danger hover:border-transparent rounded duration-200 cursor-pointer"
      >
        <font-awesome-icon icon="fa-trash" class="pr-1" />
        Delete this message
      </p>
      <p
        class="hover:text-white hover:bg-info text-info py-0.5 px-2 border border-info hover:border-transparent rounded duration-200 cursor-pointer"
      >
        <font-awesome-icon icon="fa-arrow-rotate-right" class="pr-1"  />
        Retry
      </p>
    </div>
  </div>
</template>

<script>
import { useConnectionStore } from '../../stores/useConnectionStore.js';
export default {
  props: {
    message: {
      type: Object,
    }
  },
  setup() {
    const connectionStore = useConnectionStore()
    return {
      connectionStore,
    }
  },
  methods: {
    deleteTheMessage() {
      this.connectionStore.deleteTheMessage(this.message)
    }
  }
};
</script>
