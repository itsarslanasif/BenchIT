<template>
  <transition name="fade" appear>
    <div
      class="flex flex-wrap justify-center items-center z-10 inset-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div
        v-click-outside="closeModal"
        class="modal rounded-md w-2/5 h-2/5 shadow-md bg-white"
        role="dialog"
      >
        <div class="p-8">
          <header class="flex w-full justify-between">
            <div
              class="w-5/6 text-lg text-black-900 font-semibold cursor-pointer"
            >
              <h1>{{ $t('chat_detail.edit_topic') }}</h1>
            </div>

            <font-awesome-icon
              @click="closeModal"
              class="hover:text-primary text-black-500 px-3 py-1 w-5 h-5 cursor-pointer"
              icon="fa-solid fa-xmark"
            />
          </header>
          <div class="m-0 relative mt-5">
            <textarea
              :placeholder="$t('chat_detail.add_a_topic')"
              class="w-full border rounded h-32 p-3"
              v-model="value"
            />
            <div v-if="isProfile || isGroup" class="mb-6 text-black-500 mt-4">
              <p>
                {{ $t('chat_detail.add_topic_desc1') }}
                <span class="font-semibold">{{ getChatName }}</span>
                <span v-if="isProfile">{{
                  $t('chat_detail.add_topic_desc2')
                }}</span>
                <span v-if="isGroup">{{
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

            <div
              class="flex flex-wrap md:justify-end items-center justify-center"
            >
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
import { useMessageStore } from '../../../stores/useMessagesStore';
import vClickOutside from 'click-outside-vue3';

export default {
  data() {
    return {
      value: this.chat.topic,
    };
  },
  setup() {
    const messagesStore = useMessageStore();
    return { messagesStore };
  },
  props: { closeModal: Function, chat: Object },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  computed: {
    getChatName() {
      switch (this.chat.conversation_type) {
        case 'Profile':
          return `@${this.chat.username}. `;
        case 'Channel':
          return `#${this.chat.name} `;
        default:
          return `${this.chat.name}. `;
      }
    },
    isProfile() {
      return this.chat.conversation_type === $t('profile.title');
    },
    isGroup() {
      return this.chat.conversation_type === $t('conversation.group');
    },
  },
  methods: {
    async onSubmit() {
      this.messagesStore.editTopic(this.chat.bench_conversation_id, this.value);
      this.closeModal();
    },
  },
};
</script>
