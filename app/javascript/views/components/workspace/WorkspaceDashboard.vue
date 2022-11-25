<template>
  <div class="btn-div">
    <button class="dashboard-btn" @click="createWorkspace">
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
