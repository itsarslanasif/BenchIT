<template>
  <div class="flex py-2 px-4 border-b border-black-300">
    <div class="flex overflow-y-hidden text-ellipsis">
      <p class="text-slate-800 text-xl font-semibold">
        {{ $t('mentions_and_reactions.title') }}
      </p>
    </div>
  </div>
  <div
    class="overflow-auto h-screen bg-gray-100"
    :class="!messages.length && 'flex items-center justify-center'"
  >
    <div v-if="messages.length">
      <div v-for="message in messages" :key="message.id">
        <MessageContent :currMessage="message" />
      </div>
    </div>
    <div v-else>
      <p class="text-xl">
        {{ $t('mentions_and_reactions.no_mentions_and_reactions') }}
      </p>
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
