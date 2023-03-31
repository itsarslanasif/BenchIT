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
              <h1>{{ $t('chat.edit_description') }}</h1>
            </div>

            <font-awesome-icon
              @click="closeModal"
              class="hover:text-primary text-black-500 px-3 py-1 w-5 h-5 cursor-pointer"
              icon="fa-solid fa-xmark"
            />
          </header>
          <div class="m-0 relative mt-5">
            <textarea
              :placeholder="$t('chat_detail.add_a_description')"
              class="w-full border rounded h-32 p-3"
              v-model="value"
            />
            <div class="mb-6 text-black-500 mt-4">
              <p>
                {{ $t('chat_detail.channel_description') }}
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
import { useChannelStore } from '../../../stores/useChannelStore';
import vClickOutside from 'click-outside-vue3';

export default {
  data() {
    return {
      value: this.chat.description,
    };
  },
  setup() {
    const channelStore = useChannelStore();
    return { channelStore };
  },
  props: { closeModal: Function, chat: Object },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  methods: {
    async onSubmit() {
      this.channelStore.updateChannel(
        this.chat.id,
        this.chat.is_private,
        this.value
      );
      this.closeModal();
    },
  },
};
</script>
