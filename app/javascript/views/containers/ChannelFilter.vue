<template>
  <div class="flex flex-col">
    <div class="text-md font-semibold py-2">{{$t('filters.channel_type')}}</div>
      <div class=""><n-select :options="options" v-model:value=filterChannelsValue @update:value="handleUpdateValue" /></div>
    <div class="text-md font-semibold py-3">{{$t('filters.more_options')}}</div>
      <n-checkbox :label="$t('filters.hide_my_channels')" v-model:checked=hideMyChannels @update:checked="handleCheckedChange" />
  </div>
</template>

<script>
import { useChannelStore } from "../../stores/useChannelStore";
import { NSelect, NCheckbox } from "naive-ui";
import { storeToRefs } from "pinia";
import { ref } from "vue";
import { CONSTANTS } from "../../assets/constants";

export default {
  components:{
    NSelect,
    NCheckbox
  },
  setup() {
    const channelStore = useChannelStore()
    const { filterChannelsValue, hideMyChannels } = storeToRefs(channelStore)
    const options = ref([
        {
          label: CONSTANTS.ALL_CHANNELS,
          value: ""
        },
        {
          label: CONSTANTS.PUBLIC_CHANNELS,
          value: CONSTANTS.PUBLIC
        },
        {
          label: CONSTANTS.PRIVATE_CHANNELS,
          value: CONSTANTS.PRIVATE
        },
        {
          label: CONSTANTS.ARCHIVED_CHANNELS,
          value: CONSTANTS.ARCHIVED
        },
      ])
    const handleCheckedChange = (checked) => {  
          hideMyChannels.value = checked;
      }
    const handleUpdateValue = (value) => {
        filterChannelsValue.value = value
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
