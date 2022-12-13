<template>
  <div class="container bg-primary">
    <hr class="text-slate-400" />
    <div class="relative mt-4 mb-4 text-white">
      <IconElement icon="&#8860;" :name="$t('sidebar.threads')" />
      <IconElement icon="&#8704;" :name="$t('sidebar.direct_messages')" />
      <IconElement icon="&#64;" :name="$t('sidebar.mentions_and_reactions')" />
      <IconElement icon="&#8634;" :name="$t('sidebar.draft_and_sent')" />
      <IconElement icon="&#128101;" :name="$t('sidebar.people_and_user_group')" />
      <button @click="goToAllChannels">Home view</button>
      <IconElement icon="&#8285;" :name="$t('sidebar.more')" />
    </div>
    <hr class="text-slate-400" />
    <div>
      <ChannelsAccordion />
      <DirectMessageAccordian />
    </div>
    <div class="absolute bottom-0 text-sm text-white ml-3 p-2 rounded-md hover:bg-primaryHover">
      {{ $t('channels.selected_channels') }}
    </div>
  </div>
</template>

<script>
import ChannelsAccordion from '../channels/ChannelsAccordion.vue';
import IconElement from '../../widgets/IconElement.vue';
import DirectMessageAccordian from '../directMessages/directMessagesAccordion.vue';

export default {
  components: { ChannelsAccordion, IconElement, DirectMessageAccordian },
  methods:{
    goToAllChannels() {
      this.$router.push('/browse-channels');
    },
  }
};
</script>
