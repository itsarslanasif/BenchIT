<template>
	<div class="emojiModalStyle">
		<emojiModal @select="addReaction" :native="true" class="emojiModalStyle" />
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
	props: ["addReaction"],
}
</script>
<style>
.emojiModalStyle {
	font-size: 3px;
}
</style>