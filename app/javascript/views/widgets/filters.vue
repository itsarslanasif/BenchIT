<template>
  <div>
    <div class="button-container justify-end flex items-center">
      <IconElement
        class="button text-sm text-center"
        @click="toggleSort = !toggleSort"
        icon="&#8661;"
        space="&nbsp;"
        name="Sort"
        v-bind:class="{ selected: toggleSort == true }"
      />
      <IconElement
        class="button text-sm text-center"
        @click="toggleFilters = !toggleFilters"
        icon="&#8860;"
        space="&nbsp;"
        name="Filter"
        v-bind:class="{ selected: toggleFilters == true }"
      />
    </div>
    <div class="content-container justify-end flex items-center py-2 px-2">
      <div v-if="toggleSort">
        <label class="w-40">{{ $t('filters.sort') }}</label>
        <select
          v-model="sort_filter"
          class="w-40"
          @change="emitSortFilter(sort_filter)"
        >
          <option value="">{{ $t('filters.most_recommended') }}</option>
          <option value="asc">{{ $t('filters.a_to_z') }}</option>
          <option value="desc">{{ $t('filters.z_to_a') }}</option>
        </select>
      </div>
      <div v-if="toggleFilters">
        <label class="w-40">{{ $t('filters.account_type') }}</label>
        <select
          v-model="account_type"
          class="w-40"
          @change="emitAccountType(account_type)"
        >
          <option value="all_types">{{ $t('filters.all_types') }}</option>
          <option value="owners">{{ $t('filters.owner') }}</option>
          <option value="admins">{{ $t('filters.admin') }}</option>
          <option value="full_members">{{ $t('filters.full_members') }}</option>
          <option value="guests">{{ $t('filters.guests') }}</option>
          <option value="deactivated_accounts">
            {{ $t('filters.deactivated_accounts') }}
          </option>
          <option value="not_on_slack">{{ $t('filters.not_on_slack') }}</option>
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
  beforeUnmount() {
    this.sort_filter = null;
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
}

.selected {
  background-color: #475569;
  color: white;
}

.content-container {
  width: 100%;
  height: auto;
}

.button {
  width: 95px;
  margin-right: 20px;
  color: black;
  border-radius: 5px;
  height: auto;
}

.button:hover {
  background-color: #475569;
  color: white;
}
</style>
