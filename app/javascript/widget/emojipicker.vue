<template>
	<div class="emojiModalStyle">
		<emojiModal @select="onSelectEmoji" :native="true" class="emojiModalStyle" />
	</div>
</template>
<script>
import emojiModal from 'vue3-emoji-picker'
import "../../../node_modules/vue3-emoji-picker/dist/style.css";
export default {
	name: 'EmojiPicker',
	components: {
		emojiModal
	},
	methods: {
		onSelectEmoji(emoji) {
			console.log(emoji)
		}
	}
}
</script>
<style>
	.emojiModalStyle{
		font-size: 3px;
	}
</style>