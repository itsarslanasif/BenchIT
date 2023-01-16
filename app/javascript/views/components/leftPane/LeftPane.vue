<template>
  <WorkspaceDropdown/>
  <div class="bg-primary flex flex-col h-full overflow-auto">
    <hr class="text-slate-400" />
    <div class="mt-4 mb-4 text-white">
      <IconElement icon="fa-regular fa-comment" :name="$t('sidebar.threads')" />
      <IconElement
        icon="fa-regular fa-comments"
        :name="$t('sidebar.direct_messages')"
      />
      <IconElement icon="fa-at" :name="$t('sidebar.mentions_and_reactions')" />
      <IconElement icon="fa-paper-plane" :name="$t('sidebar.draft_and_sent')" />
      <IconElement icon="fa-regular fa-address-book" :name="$t('sidebar.people_and_user_group')" />
      <IconElement icon="fa-regular fa-bookmark" :name="$t('sidebar.save_message')" @click="getdata(`/savemessages`)" />
      <IconElement icon="fa-hashtag" :name="$t('sidebar.all_channels')" @click="getdata(`/browse-channels`)" />
      <IconElement icon="fa-ellipsis-vertical" :name="$t('sidebar.more')" />
    </div>
    <hr class="text-slate-400" />
    <div>
      <ChannelsAccordion />
      <DirectMessageAccordian />
    </div>
  </div>
</template>

<script>
import ChannelsAccordion from '../channels/ChannelsAccordion.vue';
import IconElement from '../../widgets/IconElement.vue';
import DirectMessageAccordian from '../directMessages/directMessagesAccordion.vue';
import WorkspaceDropdown from '../../widgets/workspaceDropdown/WorkspaceDropdown.vue';

export default {
  components: {
    ChannelsAccordion,
    IconElement,
    DirectMessageAccordian,
    WorkspaceDropdown,
  },

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
