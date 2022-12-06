<template>
  <div class="container bg-primary">
    <hr class="text-slate-400" />
    <div class="relative mt-4 mb-4 text-white">
      <IconElement icon="&#8860;" :name="$t('sidebar.threads')" />
      <IconElement icon="&#8704;" :name="$t('sidebar.direct_messages')" />
      <IconElement icon="&#64;" :name="$t('sidebar.mentions_and_reactions')" />
      <IconElement icon="&#8634;" :name="$t('sidebar.draft_and_sent')" />
      <IconElement icon="&#128101;" :name="$t('sidebar.people_and_user_group')" />
      <IconElement icon="&#8285;" :name="$t('sidebar.more')" />
    </div>
    <hr class="text-slate-400" />
    <div v-if="channels.length">
      <ChannelsAccordion :list="channels" :heading="$t('channels.title')" />
    </div>
    <div>
      <ChannelsAccordion :list="profiles" :heading="$t('sidebar.direct_messages')" />
    </div>
    <div class="absolute bottom-0 text-sm text-white ml-3 p-2 rounded-md hover:bg-primaryHover">
      {{ $t('channels.selected_channels') }}
    </div>
  </div>
</template>

<script>
import ChannelsAccordion from '../channels/ChannelsAccordion.vue';
import IconElement from '../../widgets/IconElement.vue';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
export default {
  components: { ChannelsAccordion, IconElement },
  setup() {
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    profileStore.index();
    channelStore.index();
    return {
      profiles,
      channels,
    };
  },
};
</script>
