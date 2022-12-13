<template>
  <div class="screen-height">
    <div class="sticky w-full h-auto bg-blue-500 divide-y divide-slate-200">
      <div class="px-5 py-3 text-xl font-bold	">
        All channels

      </div>
      <div class="px-5 py-3">
        <n-space vertical class="w-3/4">
          <form @submit.prevent="handleSubmit">
          <n-input type="text" size="large"  v-model:value="term" @keyup.enter="handleSubmit" placeholder="Search by channel name or description" />
          </form>
          <p class="text-small text-gray-100 font-thin">50 results</p>
        </n-space>
      </div>
    </div>
    <div class="px-5 py-3">
      <div class="hover:bg-slate-100 py-4 rounded-md flex " v-for="channel in channels.query" :key="channel">
        <div class="w-5/6 px-2">
          #{{ channel.name}}
        </div>
        <div class="" @click="joinChannel(channel.id)">
          Join
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { NInput, NSpace, } from 'naive-ui';
import { getChannels } from '../../api/channels/channels';
export default {
  name: 'AllChannels',
  components: {
    NInput,
    NSpace,
  },
  data() {
    return {
      channels: [],
      term : ''

    }
  },
  methods:
  {
    async handleSubmit()
    {
      this.channels = await getChannels(this.term)
      debugger
    },
    joinChannel()
    {
      //join channel api goes here
    }
  }
};
</script>
<style>
.screen-height {
  height: 94vh;
}
</style>