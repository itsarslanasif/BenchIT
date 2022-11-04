<template>
  <form @submit.prevent="handleSubmit">
    <h1>What URL do you want for your Slack workspace?</h1>
    <h4>Choose the address you'll use to sign in to Slack</h4>
    <label>Your workspace URL (letters, numbers, and dashes only)</label>
    <input v-model="slack_URL" type="text" class="input-email" required />
    <span>
      <strong>.slack.com</strong>
    </span>
    <h4>
      We'll use this to name your Slack workspace, which you can always change
      later.
    </h4>
    <div class="next">
      <button>Create Workspace</button>
    </div>
  </form>
</template>

<script>
export default {
  data() {
    return {
      slack_URL: '',
    };
  },
  methods: {
    handleSubmit() {
      // console.log('form submitted');
    },
  },
};
</script>

<style>
.input-email {
  width: 75%;
  display: inline-block;
}
</style>
