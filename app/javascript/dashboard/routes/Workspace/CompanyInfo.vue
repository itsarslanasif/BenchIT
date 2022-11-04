<template>
  <form @submit.prevent="handleSubmit">
    <h1>What's your company called?</h1>
    <label>Company name</label>
    <input
      v-model="company_name"
      type="text"
      placeholder="Ex. Acme or Acme Marketing"
      required
    />
    <h4>
      We'll use this to name your Slack workspace, which you can always change
      later.
    </h4>
    <div class="next">
      <button>Continue to Workspace URL</button>
    </div>
  </form>
</template>
<script>
export default {
  data() {
    return {
      company_name: '',
    };
  },
  methods: {
    handleSubmit() {
      this.$router.push('/app/workspace_url');
    },
  },
};
</script>
