<template>
  <div>
    <h4 class="form-h">What URL do you want for your workspace?</h4>
    <h6 class="form-h">Choose the address you'll use to sign in</h6>
    <label>Your workspace URL</label>
    <input
      v-model="workspaceStore.workspace.benchIT_URL"
      class="form-input-select"
      type="email"
      placeholder="acme@benchit.com"
      required
    />
  </div>
</template>

<script>
import { WorkspaceStore } from '../../stores/workspace_store';
import './style.css';

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
};
</script>

