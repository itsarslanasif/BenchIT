<template>
  <div class="flex flex-col">
    <div class="text-md font-semibold">Channel Type</div>
    <n-space vertical>
      <n-select :options="options" @update:value="handleUpdateValue" />
    </n-space>
    <div class="text-md font-semibold">More Options:</div>
    <div>
      <n-checkbox v-model:checked="hideMyChannels" label="Hide My Channels" @update:checked="handleCheckedChange" />
    </div>
  </div>
</template>

<script>
import { useChannelStore } from "../../stores/useChannelStore";
import { NSelect, NSpace, NCheckbox } from "naive-ui";
import { storeToRefs } from "pinia";
import { ref } from "vue";

export default {
  components:{
    NSelect,
    NSpace,
    NCheckbox
  },
  setup() {
    const channelStore = useChannelStore()
    const filterChannelsValue = storeToRefs(channelStore)
    const hideMyChannels = ref(false)
    const options = ref([
        {
          label: "All channels types",
          value: "all"
        },
        {
          label: "Public Channels",
          value: "public"
        },
        {
          label: "Private Channels",
          value: "private"
        },
        {
          label: "Archived Channels",
          value: "archived"
        },
      ])
    const handleCheckedChange = (checked) => {
        console.log(checked)
      }
    const handleUpdateValue = (value) => {
        channelStore.filterChannelsValue = value
      }

    return {
      options,
      filterChannelsValue,
      hideMyChannels,
      handleCheckedChange,
      handleUpdateValue
    };
  }
};
</script>