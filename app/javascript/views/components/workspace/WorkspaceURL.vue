<template>
  <div>
    <h4>{{ $t('url.title') }}</h4>
    <h6>{{ $t('url.description') }}</h6>
    <label>{{ $t('url.name') }}</label>
    <input
      v-model="workspaceStore.workspace.bench_it_url"
      class="border"
      type="email"
      :placeholder="$t('placeholder.workspace')"
      required
    />
  </div>
</template>

<script>
import { WorkspaceStore } from '../../../stores/workspace_store';

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
};
</script>
