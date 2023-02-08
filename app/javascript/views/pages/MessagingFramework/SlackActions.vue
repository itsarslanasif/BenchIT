<template>
  <div class="slack-action">
    <div v-for="element in action" :key="element.actionId">
      <button
        class="slack-button"
        :class="element.style === 'danger' ? 'danger' : 'primary'"
        :action-id="element.actionId"
        @click="handleButtonClick(element.actionId)"
      >
        {{ element.text.text }}
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    action: {
      type: Object,
      required: true,
    },
  },
  methods: {
    handleButtonClick(actionId) {
      this.$emit('button-click', actionId);
    },
  },
};
</script>

<style scoped>
.slack-action {
  display: flex;
  margin-top: 16px;
  float: left;
  gap: 5%;
}

.slack-button {
  padding: 8px 16px;
  background-color: #34a853;
  border: none;
  border-radius: 4px;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
}

.danger {
  background-color: #ff0000;
}
</style>
