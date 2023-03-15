<template>
  <div class="flex py-1 px-4 border-b border-black-300">
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
import { errorHandler } from '../../widgets/messageProvider';
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
      errorHandler(e.response.data.message);
    }
  },
};
</script>
