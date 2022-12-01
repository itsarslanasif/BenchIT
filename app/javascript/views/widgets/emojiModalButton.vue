<template>
  <n-popover style="backgroundcolor: #1e293b" trigger="hover">
    <template #trigger>
      <template v-if="actionText == 'More actions'">
        <n-dropdown
          placement="bottom-start"
          trigger="click"
          size="medium"
          :message="message"
          :options="options"
          @select="handleSelect($event, message)"
          class="rounded-md border border-slate-100"
        >
          <span @click="action" class="p-1 hover:bg-slate-100 rounded">
            <font-awesome-icon :icon="icon" />
          </span>
        </n-dropdown>
      </template>
      <template v-else>
        <span @click="action(emoji)" class="p-1 hover:bg-slate-100 rounded">
          <font-awesome-icon v-if="icon" :icon="icon" />
          <template v-if="emoji">
            {{ emoji.i }}
          </template>
        </span>
      </template>
    </template>
    <span>{{ actionText }}</span>
  </n-popover>
</template>

<script>
import options from './options.js';
import { NPopover, NDropdown } from 'naive-ui';
export default {
  name: 'EmojiModalButton',
  components: { NPopover, NDropdown },
  props: ['icon', 'emoji', 'actionText', 'action', 'message'],
  data() {
    return {
      options,
      handleSelect(key, message) {
        if (key === 'copy-link') {
          var TempText = document.createElement('input');
          TempText.value = `${import.meta.env.VITE_APP_SERVER_URL}channels/${
            message.bench_conversation_id}/${message.id
          }`;
          document.body.appendChild(TempText);
          TempText.select();
          document.execCommand('copy');
          document.body.removeChild(TempText);
        }
      },
    };
  },
};
</script>
