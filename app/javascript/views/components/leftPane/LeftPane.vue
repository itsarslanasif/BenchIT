<template>
  <div class=" bg-primary flex flex-col h-full overflow-auto">
    <hr class="text-slate-400" />
    <div class="mt-4 mb-4 text-white">
      <IconElement icon="&#8860;" :name="$t('sidebar.threads')" />
      <IconElement icon="&#8704;" :name="$t('sidebar.direct_messages')" />
      <IconElement icon="&#64;" :name="$t('sidebar.mentions_and_reactions')" />
      <IconElement icon="&#8634;" :name="$t('sidebar.draft_and_sent')" />
      <IconElement
        icon="&#128101;"
        :name="$t('sidebar.people_and_user_group')"
      />
      <IconElement
        icon="&#xf097;"
        :name="$t('sidebar.save_message')"
        @click="getdata(`/savemessages`)"
      />
      <IconElement
        icon="&#xf292;"
        :name="$t('sidebar.all_channels')"
        @click="getdata(`/browse-channels`)"
      />
      <IconElement icon="&#8285;" :name="$t('sidebar.more')" />
    </div>
    <hr class="text-slate-400" />
    <div>
      <!-- <StarredChannels /> -->
      <ChannelsAccordion />
      <DirectMessageAccordian />
    </div>
  </div>
</template>

<script>
import ChannelsAccordion from '../channels/ChannelsAccordion.vue';
import IconElement from '../../widgets/IconElement.vue';
import DirectMessageAccordian from '../directMessages/directMessagesAccordion.vue';
import StarredChannels from '../channels/StarredChannels.vue';

export default {
  components: { ChannelsAccordion, IconElement, DirectMessageAccordian, StarredChannels },

  methods: {
    getdata(chatURL) {
      this.$router.push(chatURL);
    },
  },
};
</script>
<style>
.container {
  height: 88vh;
}
</style>

