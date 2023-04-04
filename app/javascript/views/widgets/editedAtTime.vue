<template>
  <div>
    <n-tooltip placement="top" :style="{ width: '150px' }" trigger="hover">
      <template #trigger>
        <n-text
          class="text-center text-xs ml-2 text-black-500 hover:underline cursor-pointer"
          >{{ $t('actions.edited') }}</n-text
        >
      </template>
      <div class="flex flex-col items-center">
        <span class="text-md">{{ time() }}</span>
      </div>
    </n-tooltip>
  </div>
</template>

<script>
import { NTooltip } from 'naive-ui';
import moment from 'moment';
export default {
  props: ['updated_at'],
  components: {
    NTooltip,
  },
  methods: {
    time() {
      return moment(new Date(this.updated_at).getTime()).fromNow();
    },
  },
};
</script>
