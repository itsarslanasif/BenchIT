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
      >{{ convertToHours(status.timestamp) }}</span
    >
    <span v-if="status.recent" class=" flex-grow mx-3 cursor-pointer">
      <span class="float-right hover-target">X</span>
    </span>
  </div>
</template>

<script>
import EmojiPicker from '../../widgets/emojipicker.vue';

export default {
  components: { EmojiPicker },
  props: ['status', 'selectOption'],
  data() {
    return {
      currentTimestamp: new Date(),
      openEmojiModal: false,
      emoji: '👍',
      text: 'AFKsdadassdccccdsknjfansfjanj',
      time: '- 24 hour',
      recent: true,
    };
  },
  methods: {
    addReaction(emoji) {
      // console.log(emoji)
    },
    setEmojiModal() {
      this.openEmojiModal = !this.openEmojiModal;
    },
    handleDeleteRecentStatus() {
      console.log('deleted');
    },

    convertToHours(time) {

      const myDate = new Date(time);
      return '-' + myDate.getHours() + ' hours';
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
