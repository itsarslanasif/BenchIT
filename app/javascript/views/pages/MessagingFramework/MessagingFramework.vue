<template>
  <div>
    <template v-for="block in message.blocks" :key="block">
      <slack-section v-if="block.type === 'section'" :section="block" />
      <slack-actions v-if="block.type === 'actions'" :action="block.elements" />
    </template>
  </div>
</template>

<script>
import { Message, Blocks, Elements } from 'slack-block-builder';
import SlackSection from './SlackSection.vue';
import SlackActions from './SlackActions.vue';

export default {
  components: {
    Message,
    Blocks,
    Elements,
    SlackSection,
    SlackActions,
  },
  data() {
    return {
      message: null,
    };
  },
  created() {
    this.message = Message({ text: 'Alas, my friend.' })
      .blocks(
        Blocks.Section({
          text: 'One does not simply walk into Slack and click a button.',
        }),
        Blocks.Section({
          text: "At least that's what my friend Slackomir said :crossed_swords:",
        }),
        Blocks.Divider(),
        Blocks.Actions().elements(
          Elements.Button({
            text: 'Sure',
            actionId: 'gotClicked',
          }).danger(),
          Elements.Button({
            text: 'Not',
            actionId: 'scaredyCat',
          }).primary()
        )
      )
      .asUser()
      .buildToObject();
  },
};
</script>
