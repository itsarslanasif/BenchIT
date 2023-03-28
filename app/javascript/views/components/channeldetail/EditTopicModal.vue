<template>
  <transition name="fade" appear>
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div
        class="modal rounded-md w-2/5 h-2/5 shadow-md bg-white"
        role="dialog"
      >
        <div class="p-8">
          <header class="flex w-full justify-between">
            <div class="w-5/6 text-lg text-black-900 font-semibold cursor-pointer">
              <h1>Edit Topic</h1>
            </div>

            <font-awesome-icon
              @click="closeModal"
              class="hover:text-primary text-black-500 px-3 py-1 w-5 h-5 cursor-pointer"
              icon="fa-solid fa-xmark"
            />
          </header>
          <div class="m-0 relative mt-5">
            <textarea :placeholder="$t('chat_detail.add_a_topic')" class="w-full border rounded h-32 p-3" v-model="value" />
            <div
              v-if="
                selectedChat.conversation_type === 'Profile' ||
                selectedChat.conversation_type === 'Group'
              "
              class="mb-6 text-black-500 mt-4 cursor-pointer"
            >
              <p>
                {{ $t('chat_detail.add_topic_desc1') }}
                <span class="font-semibold">{{ getChatName }}</span>
                <span v-if="selectedChat.conversation_type === 'Profile'">{{
                  $t('chat_detail.add_topic_desc2')
                }}</span>
                <span v-if="selectedChat.conversation_type === 'Group'">{{
                  $t('chat_detail.add_topic_desc3')
                }}</span>
              </p>
            </div>
            <div v-else class="mb-6 text-black-500 mt-4">
              <p>
                {{ $t('chat_detail.add_topic_channel_desc1') }}
                <span class="font-semibold">{{ getChatName }}</span>
                {{ $t('chat_detail.add_topic_channel_desc2') }}
              </p>
            </div>

            <div class="flex items-center justify-end">
              <button
                @click="closeModal"
                class="bg-transparent text-black py-2 px-5 text-base float-right mb-3 rounded border"
              >
                {{ $t('actions.cancel') }}
              </button>
              <button
                @click="onSubmit"
                class="bg-success text-white py-2 px-5 text-base float-right mx-3 mb-3 rounded"
                type="success"
              >
                {{ $t('actions.save') }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import { editTopic } from '../../../api/conversation/conversation';
import { errorHandler } from '../../widgets/messageProvider';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { storeToRefs } from 'pinia';

export default {
  data() {
    return {
      value: this.selectedChat.topic,
    };
  },
  setup() {
    const messagesStore = useMessageStore();
    const { selectedChat } = storeToRefs(messagesStore);
    return { selectedChat };
  },
  props: { closeModal: Function, chat: Object },

  computed: {
    getChatName() {
      if (this.chat.conversation_type == 'Profile')
        return `@${this.chat.username}`;
      else if (this.chat.conversation_type == 'Channel')
        return `#${this.chat.name}`;
      else return `${this.chat.name}`;
    },
  },
  methods: {
    async onSubmit() {
      editTopic(this.chat.bench_conversation_id, this.value)
        .then(res => {
          this.selectedChat.topic = this.value;
          this.closeModal();
        })
        .catch(e => {
          errorHandler(e.response.data.message);
        });
    },
  },
};
</script>
