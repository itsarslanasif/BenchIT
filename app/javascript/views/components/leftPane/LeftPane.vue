<template>
  <div class="container bg-primary">
    <hr class="text-slate-400" />
    <div class="menu mt-4 mb-4 text-white">
      <IconElement icon="&#8860;" :name="$t(CONSTANTS.THREADS)" />
      <IconElement icon="&#8704;" :name="$t(CONSTANTS.DIRECT_MESSAGES)" />
      <IconElement icon="&#64;" :name="$t(CONSTANTS.MENTIONS_AND_REACTIONS)" />
      <IconElement icon="&#8634;" :name="$t(CONSTANTS.DRAFT_AND_SEND)" />
      <IconElement icon="&#8285;" :name="$t(CONSTANTS.MORE)" />
    </div>
    <hr class="text-slate-400" />
    <div>
      <p>
        <ChannelsAccordion />
      </p>
      <p>
        <ChannelsAccordion />
      </p>
    </div>
    <div class="absolute bottom-0 text-sm text-white ml-3 p-2 rounded-md hover:bg-primaryHover">
      {{ $t(CONSTANTS.SELECTED_CHANNELS) }}
    </div>
  </div>
</template>

<script>
import ChannelsAccordion from '../channels/ChannelsAccordion.vue';
import IconElement from '../../widgets/IconElement.vue';
import { CONSTANTS } from '../../../assets/constants';

export default {
  components: { ChannelsAccordion, IconElement },
  data() {
    return {
      CONSTANTS: CONSTANTS,
    };
  },
};
</script>

<style scoped>
.menu {
  position: relative;
}
</style>
