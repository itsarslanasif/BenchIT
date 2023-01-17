<template>
  <div
    class="flex py-1 w-full hover-trigger hover:bg-slate-800 rounded-md group hover:text-white"
  >
    <span @click="onSelect(status)" class=" px-2 cursor-pointer">{{
      status.emoji
    }}</span>
    <span @click="onSelect(status)" class="font-medium cursor-pointer">{{
      status.text
    }}</span>
    <span
      @click="onSelect(status)"
      class="text-slate-300 cursor-pointer w-3/12"
      >  -{{ handleDateTime.secondsToHoursAndMinutes(status.clear_after)}}</span
    >
    <span v-if="isRecent" class=" flex-grow mx-3 cursor-pointer">
      <span @click="deleteRecentStatus(status.id)" class="float-right hover-target">X</span>
    </span>
  </div>
</template>

<script>
import EmojiPicker from '../../widgets/emojipicker.vue';
import { handleDateTime } from '../../../handleDateTime.js';
export default {
  components: { EmojiPicker },
  props: ['status', 'onSelect','isRecent','deleteRecentStatus'],
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
