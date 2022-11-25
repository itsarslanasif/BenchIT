<template>
  <n-popover style="backgroundcolor: #1e293b" trigger="hover">
    <template #trigger>
      <template v-if="actionText == 'More actions'">
        <n-dropdown
          placement="bottom-start"
          trigger="click"
          size="medium"
          :options="options"
          @select="handleSelect"
          @mouseleave="action"
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
  props: ['icon', 'emoji', 'actionText', 'action'],
  data() {
    return {
      options,
      handleSelect(key) {
        message.info(String(key));
      },
    };
  },
};
</script>
