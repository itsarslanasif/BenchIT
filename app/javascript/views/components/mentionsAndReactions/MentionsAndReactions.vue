<template>
  <div class="flex p-1 px-3 border-x-0 border-t-0 border-b border-black-300">
    <div class="flex overflow-y-hidden text-ellipsis p-1">
      <p class="text-slate-800 text-xl font-semibold">
        {{ $t('mentions_and_reactions.title') }}
      </p>
    </div>
  </div>
  <div class="overflow-auto h-screen bg-gray-100">
    <div v-for="message in messages" :key="message.id">
      <MessageContent :currMessage="message" />
    </div>
  </div>
</template>

<script>
import { getReactions } from '../../../api/mentions_and_reactions/reactions';
import MessageContent from './MessageContent.vue';

export default {
  data() {
    return {
      messages: [],
    };
  },
  components: { MessageContent },
  async mounted() {
    try {
      this.messages = await getReactions();
    } catch (e) {
      console.error(e);
    }
  },
};
</script>

<style></style>
