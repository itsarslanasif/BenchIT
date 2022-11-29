<template>
  <div class="flex justify-center">
    <button class="w-64" @click="createWorkspace">
      Create New Workspace
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
