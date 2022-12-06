<template>
  <div class="flex justify-center">
    <button class="w-64" @click="createWorkspace">
      {{ $t('workspace.create_new_workspace') }}
    </button>
  </div>
</template>

<script>
import './style.css';

export default {
  methods: {
    createWorkspace() {
      this.$router.push('/new_workspace');
    },
  },
};
</script>
