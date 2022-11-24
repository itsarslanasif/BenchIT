<template>
  <div>
    <h4 class="form-h3">{{ $t('url.title') }}</h4>
    <h6 class="form-h">{{ $t('url.description') }}</h6>
    <label>{{ $t('url.name') }}</label>
    <input
      v-model="workspaceStore.workspace.bench_it_url"
      class="form-input-select"
      type="email"
      placeholder="acme@benchit.com"
      required
    />
  </div>
</template>

<script>
import { WorkspaceStore } from '../../../stores/workspace_store';
import './style.css';

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
};
</script>
