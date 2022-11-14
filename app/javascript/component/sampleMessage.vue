<template>
    <div class="outerDiv" @mouseover="emojiModalStatus = true" @mouseleave="emojiModalStatus = false">
        <div class="messageStyle">
            {{ name }}
        </div>
        <div class="emojiModalToggle" v-if="emojiModalStatus || openEmojiModal" @click="openEmojiModal = !openEmojiModal">
            <font-awesome-icon icon="fa-solid fa-face-smile-wink" />
        </div>
        <div v-if="openEmojiModal" class="emojiModal">
            <EmojiPicker />
        </div>
    </div>
</template>

<script>
import EmojiPicker from '../widget/emojipicker.vue'
export default {
    name: 'SampleMessage',
    components: {
        EmojiPicker,
    },
    data() {
        return {
            emojiModalStatus: false,
            openEmojiModal: false,
            name: 'Hello everyone!',
        }
    }
}
</script>
<style>
.messageStyle {
    background-color: #18232bce;
    padding: 10px;
    border-radius: 10px;
}

.outerDiv {
    margin-bottom: 5%;
}

.emojiModalToggle {
    background-color: #151f25;
    float: right;
    margin-top: -5px;
    padding: 5px;
    border-radius: 4px;
}

.emojiModal {
    float: right;
}
</style>