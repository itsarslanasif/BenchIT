<template>
  <div>
    <h4 class="form-h">{{ $t('company.title') }}</h4>
    <label>{{ $t('company.name') }}</label>
    <input
      v-model="workspaceStore.workspace.company_name"
      type="text"
      class="form-input-select"
      placeholder="Ex. Acme or Acme Marketing"
      required
    />
    <p class="form-h">{{ $t('company.description') }}</p>
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
