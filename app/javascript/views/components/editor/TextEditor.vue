<template>
  <div>
    <div v-if="showMentions || showChannels"
      class="w-1/4 p-2 text-sm shadow-inner bg-secondary text-white absolute z-10">
      <div v-if="
  (showMentions && hasMentionCommand) ||
  (showChannels && hasChannelCommand)
">
        <div v-for="item in filteredList" :key="item.name" class="p-1 rounded-md hover:bg-secondaryHover"
          @click="addMentionToText">
          {{ item.creator_id ? item.name : item.username }}
        </div>
      </div>
    </div>
    <div>
      <editor v-model="newMessage" @keydown.enter="sendMessagePayload" api-key="no-api-key" :init="{
  menubar: false,
  statusbar: false,
  plugins: 'lists link code codesample',
  toolbar:
    'bold italic underline strikethrough | link |  bullist numlist  | alignleft | code | codesample',
  codesample_languages: [none],
  formats: {
    code: {
      selector: 'p',
      styles: {
        background:
          'rgba(var(--sk_foreground_min_solid, 248, 248, 248), 1)',
        'border-left': '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
        'border-right': '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
        'border-top': '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
        'border-bottom': '1px solid rgba(var(--sk_foreground_low_solid, 221, 221, 221), 1)',
        'border-radius': '3px',
        'font-size': '10px',
        'font-variant-ligatures': 'none',
        'line-height': '1.5',
        'margin-bottom': '14px',
        'padding-left': '8px',
        'padding-right': '8px',
        position: 'relative',
        'font-family': 'monospace',
      },
    },
  },
}" />
    </div>
    <div>
      <div v-if="readerFile.length" class="flex mt-2">
        <div v-for="file in readerFile" :key="file" class="w-12 h-12 border-primary border mr-3 rounded-md">
          <font-awesome-icon icon="fa-circle-xmark" class="float-right" @click="removeFile(file)" />
          <img :src="file" class="self-baseline" />
        </div>
      </div>
    </div>
    <div class="flex w-full relative">
      <Attachments :getImages="getImages" />
      <div class="w-1/12">
        <button @click="sendMessagePayload"
          class="px-4 py-1 bg-success my-4 rounded-md text-white hover:bg-successHover">
          {{ $t('actions.send') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, watch } from 'vue'
import Editor from '@tinymce/tinymce-vue';
import Attachments from '../attachments/Attachments.vue';
import { useProfileStore } from '../../../stores/useProfileStore'
import { useChannelStore } from '../../../stores/useChannelStore'
import { storeToRefs } from 'pinia'
import { NMention } from 'naive-ui';

export default
  {
    components:
    {
      editor: Editor,
      Attachments,
      NMention
    },
    props: ["sendMessage"],
    setup(props) {
      const channelStore = useChannelStore()
      const profileStore = useProfileStore()
      const { channels } = storeToRefs(channelStore)
      const { profiles } = storeToRefs(profileStore)
      const newMessage = ref('')
      const showMentions = ref(false)
      const showChannels = ref(false)
      const hasMentionCommand = ref(false)
      const hasChannelCommand = ref(false)
      const readerFile = ref([])
      const files = ref([])
      const filteredList = ref([])

      watch(newMessage, (curr, old) => {
        const currentMessage = ignoreHTML(curr)
        const oldMessage = ignoreHTML(old)
        const message = ignoreHTML(newMessage.value)

        if (message && getLastIndex(currentMessage) == '@' && getLastIndex(oldMessage) == ';') {
          enableMention()
        }
        else if (message && getLastIndex(currentMessage) == '#' && getLastIndex(oldMessage) == ';') {
          enableChannels()
        }
        else if (message.length === 1 && getLastIndex(currentMessage) == '@') {
          enableMention()
        }
        else if (message.length === 1 && getLastIndex(currentMessage) == '#') {
          enableChannels()
        }
        else if (!message) {
          disableAll()
        }
        else {
          disableAll()
        }
      }
      )

      const getLastIndex = (value) => {
        return value[value.length - 1]
      }

      const sendMessagePayload = (event) => {
        if (event.keyCode === 13 && !event.shiftKey) {
          let messageData;
          let filterData;
          let actuallData;
          const startWithBr = newMessage.value.startsWith('<p><br />', 0);
          const startWithNonBreakSpace = newMessage.value.startsWith('<p>&nbsp;</p>');
          const endWithBr = newMessage.value.endsWith("<br /></p>\n<p>&nbsp;</p>");
          if (startWithBr || endWithBr) {
            messageData = newMessage.value.split('<br />');
            filterData = messageData.filter(function (el) { return el !== '' });
            actuallData = filterData.join().split('\n')[0].replace(/,/g, " ");
          }
          else {
            actuallData = newMessage?.value?.split('\n')[0];
          }
          if (actuallData !== '' && actuallData !== '<p> </p>' && !startWithNonBreakSpace) {
            props.sendMessage(actuallData, files.value)
            newMessage.value = ''
            readerFile.value = []
            files.value = []
          }
        }
      };

      const enableMention = () => {
        filteredList.value = profiles.value;
        hasMentionCommand.value = true;
        showMentions.value = true;
        hasChannelCommand.value = false;
        showChannels.value = false;
      }

      const enableChannels = () => {
        filteredList.value = channels.value;
        hasChannelCommand.value = true;
        showChannels.value = true;
        hasMentionCommand.value = false;
        showMentions.value = false;
      }

      const disableAll = () => {
        hasMentionCommand.value = false;
        showMentions.value = false;
        hasChannelCommand.value = false;
        showChannels.value = false;
      }

      const addMentionToText = (e) => {
        newMessage.value = `${newMessage.value.slice(0, -4)}<span>${e.target.outerText}</span> ${newMessage.value.slice(-4)}`
        showMentions.value = false;
        hasMentionCommand.value = false;
      }

      const ignoreHTML = (message) => {
        return message.replace(/<[^>]+>/g, '');
      }

      const removeFile = (file) => {
        const index = readerFile.value.indexOf(file);
        files.value.splice(index, 1);
        readerFile.value.splice(index, 1);
      }

      const getImages = (file) => {
        files.value[files.value?.length] = file;
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => readerFile.value.push(reader.result);
      }

      return {
        newMessage,
        readerFile,
        files,
        showMentions,
        showChannels,
        hasChannelCommand,
        hasMentionCommand,
        filteredList,
        channels,
        profiles,
        removeFile,
        sendMessagePayload,
        getImages,
        addMentionToText
      }
    }
  }
</script>
