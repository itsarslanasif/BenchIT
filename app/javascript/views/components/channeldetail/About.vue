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
import { ref, onUnmounted } from 'vue';
import { computed } from '@vue/reactivity';
import { useRouter } from 'vue-router'
import { useChannelStore } from '../../../stores/useChannelStore';
import { useConversationInfoStore } from '../../../stores/useConversationInfoStore';

export default {
  name: 'About',
  setup() {
    const channelStore = useChannelStore();
    const conversationInfoStore = useConversationInfoStore();
    const {conversationInfo} = storeToRefs(conversationInfoStore)
    
    const router = useRouter()
    const topic = ref('No Topic set')
    const date = ref(conversationInfo.value.created_at)
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    const month = ref(months[new Date(date.value).getUTCMonth()]);
    const day = ref(new Date(date.value).getUTCDate());
    const year = ref(new Date(date.value).getUTCFullYear());


    const channelCreator = computed(()=>{
      return `${conversationInfo.value.creator_name} on ${month.value} ${day.value}, ${year.value}`
    })

    const leaveChannel = async () =>{
        await channelStore.leaveChannel(conversationInfo.value.creator_id);
        router.push('/');
    }

    onUnmounted(()=>{
      topic = null
      months = null
      date = null
    })
    
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
