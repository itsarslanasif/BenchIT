<template>
  <div class="bg-white flex flex-col p-5 gap-3">
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.topic') }}</p>
      <p>{{ topic }}</p>
    </div>
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.description') }}</p>
      <p>{{ conversationInfo.description }}</p>
    </div>
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.created_by') }}</p>
      <p>{{ channelCreator }} </p>
    </div>
    <div
      class="bg-danger text-white hover:bg-dangerHover p-2 rounded-md"
      @click="leaveChannel"
    >
      <p class="font-black">{{ $t('channeldetail.leave') }}</p>
    </div>
    <div class="bg-white hover:bg-transparent p-2 rounded-md">
      <p class="font-black">{{ $t('channeldetail.files') }}</p>
      <p>{{ $t('channeldetail.filecontent') }}</p>
    </div>
  </div>
</template>

<script>
import { storeToRefs } from 'pinia';
import { ref } from 'vue';
import { computed } from '@vue/reactivity';
import { useRouter } from 'vue-router'
import { useChannelStore } from '../../../stores/useChannelStore';
import { useConversationInfoStore } from '../../../stores/useConversationInfoStore';
import {convertUTCToLocal} from '../../widgets/dateUtils'

export default {
  name: 'About',
  setup() {
    const channelStore = useChannelStore();
    const conversationInfoStore = useConversationInfoStore();
    const {conversationInfo} = storeToRefs(conversationInfoStore)
    
    const router = useRouter()
    const topic = ref('No Topic set')
    const date = computed (()=>{
    return convertUTCToLocal(conversationInfo.value.created_at)
    })
    const channelCreator = computed(()=>{
      return `${conversationInfo.value.creator_name} on ${date.value.month} ${date.value.day}, ${date.value.year}`
    })

    const leaveChannel = async () =>{
        await channelStore.leaveChannel(conversationInfo.value.creator_id);
        router.push('/');
    }
    
    return {
      conversationInfo,
      channelStore,
      topic,
      channelCreator,
      leaveChannel
    };
  },

};
</script>
