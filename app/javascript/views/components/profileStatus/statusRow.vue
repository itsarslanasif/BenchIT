<template>
  <div
    class="flex py-1 w-full hover-trigger hover:bg-slate-800 rounded-md group hover:text-white"
  >
    <span @click="selectOption(status)" class=" px-2 cursor-pointer">{{
      status.emoji
    }}</span>
    <span @click="selectOption(status)" class="font-medium cursor-pointer">{{
      status.text
    }}</span>
    <span
      @click="selectOption(status)"
      class="text-slate-300 cursor-pointer w-3/12"
      >{{ handleDateTime.secondsToHoursAndMinutes(status.clear_after)}}</span
    >
    <span v-if="recent" class=" flex-grow mx-3 cursor-pointer">
      <span class="float-right hover-target">X</span>
    </span>
  </div>
</template>

<script>
import EmojiPicker from '../../widgets/emojipicker.vue';
import { handleDateTime } from '../../../handleDateTime.js';
export default {
  components: { EmojiPicker },
  props: ['status', 'selectOption','recent'],
  data() {
    return {
      handleDateTime: new handleDateTime(),
      currentTimestamp: new Date(),
      openEmojiModal: false,
      emoji: '👍',
      text: 'AFKsdadassdccccdsknjfansfjanj',
      time: '- 24 hour',
    };
  },
  methods: {
    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },
    handleDeleteRecentStatus() {
      console.log('deleted');
    },
  },
};
</script>

<style scoped>
.hover-trigger .hover-target {
  display: none;
}
.hover-trigger:hover .hover-target {
  display: flex;
  cursor: pointer;
}
</style>
