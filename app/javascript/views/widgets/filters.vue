<template>
  <div>
    <div class="button-container">
      <IconElement
        class="button"
        @click="toggleSort = !toggleSort"
        icon="&#8661;"
        space="&nbsp;"
        name="Sort"
        v-bind:class="{ selected: toggleSort == true }"
      />
      <IconElement
        class="button"
        @click="toggleFilters = !toggleFilters"
        icon="&#8860;"
        space="&nbsp;"
        name="Filter"
        v-bind:class="{ selected: toggleFilters == true }"
      />
    </div>
    <div class="content-container py-2 px-2">
      <div v-show="toggleSort">
        <label class="w-40">Sort</label>
        <select
          v-model="sort_filter"
          class="w-40"
          @change="emitSortFilter(sort_filter)"
        >
          <option value="">Most recommended</option>
          <option value="asc">A to Z</option>
          <option value="desc">Z to A</option>
        </select>
      </div>
      <div v-show="toggleFilters">
        <label class="w-40">Account Type</label>
        <select
          v-model="account_type"
          class="w-40"
          @change="emitAccountType(account_type)"
        >
          <option value="all_types">All types</option>
          <option value="owners">Owners</option>
          <option value="admins">Admins</option>
          <option value="full_members">Full Members</option>
          <option value="guests">Guests</option>
          <option value="deactivated_accounts">Deactivated accounts</option>
          <option value="not_on_slack">Not on slack</option>
        </select>
      </div>
    </div>
  </div>
</template>

<script>
import IconElement from './IconElement.vue';

export default {
  components: {
    IconElement,
  },
  data() {
    return {
      account_type: 'all_types',
      sort_filter: '',
      toggleSort: false,
      toggleFilters: false,
    };
  },
  methods: {
    emitAccountType() {
      this.$emit('account_type', this.account_type);
    },
    emitSortFilter() {
      this.$emit('sort_filter', this.sort_filter);
    },
  },
};
</script>

<style scoped>
.button-container {
  width: 100%;
  height: auto;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}
.selected {
  background-color: #475569;
}
.content-container {
  width: 100%;
  height: auto;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}
.button {
  width: 95px;
  margin-right: 20px;
  text-align: center;
  font-size: 15px;
  border-radius: 5%;
  height: auto;
}
.button:hover {
  background-color: #475569;
}
</style>
