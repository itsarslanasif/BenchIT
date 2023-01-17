<template>
  <div class="flex p-1 px-3 border-x-0 border-t-0 border-b border-black-300">
    <div class="flex overflow-y-hidden text-ellipsis p-1">
      <p class="text-slate-800 text-xl font-semibold">
        {{ $t('actions.saved_items') }}
      </p>
    </div>
  </div>
  <div
    class="overflow-auto chatBody bg-gray-100"
    :class="{ 'flex justify-center items-center': !hasSavedItems }"
  >
    <div
      class="flex flex-col justify-center mt-8 w-100 items-center"
      v-if="!hasSavedItems"
    >
      <font-awesome-icon
        icon="far fa-bookmark"
        class="text-2xl text-danger mb-2"
      ></font-awesome-icon>
      <p class="font-bold text-base">
        {{ $t('saved_items.title') }}
      </p>
      <p class="text-base text-center">
        {{ $t('saved_items.description') }}
      </p>
    </div>
    <div
      else
      v-for="message in savedItemsStore.savedItems"
      :key="message.id"
      :id="message.id"
    >
      <div class="border border-black-200 m-5">
        <SaveMessageWrapper :currMessage="message" />
      </div>
    </div>
  </div>
</template>

<script>
import { getSaveMessages } from '../../../api/save_messages/savemessages.js';
import SaveMessageWrapper from './SaveMessageWrapper.vue';
import { useSavedItemsStore } from '../../../stores/useSavedItemStore.js';

export default {
  components: {
    SaveMessageWrapper,
  },
  setup() {
    const savedItemsStore = useSavedItemsStore();
    return { savedItemsStore };
  },
  computed: {
    hasSavedItems() {
      return this.savedItemsStore.savedItems.length != 0;
    },
  },
  async beforeMount() {
    try {
      this.savedItemsStore.savedItems = await getSaveMessages();
    } catch (e) {
      console.error(e);
    }
  },
};
</script>
<style scoped>
.chatBody {
  height: 87vh;
}

.highlight {
  animation: background-fade 7s;
}

@keyframes background-fade {
  0% {
    background: rgba(253, 245, 221, 255);
  }
}
</style>
