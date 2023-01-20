<template>
	<div v-click-outside="toggleModal" >
		<emojiModal  @select="addReaction" :native="true" class="text-sm" />
	</div>
</template>
<script>
import emojiModal from 'vue3-emoji-picker'
import "../../../../node_modules/vue3-emoji-picker/dist/style.css";
import vClickOutside from 'click-outside-vue3';
export default {
	name: 'EmojiPicker',
	components: {
		emojiModal
	},
	directives: {
    clickOutside: vClickOutside.directive,
  },
	props: ["addReaction","toggleModal"],
}
</script>
