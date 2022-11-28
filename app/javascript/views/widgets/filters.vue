<template>
  <div>
    <div class="button-container justify-end flex items-center">
      <IconElement
        class="button text-sm text-center "
        @click="toggleSort = !toggleSort"
        icon="&#8661;"
        space="&nbsp;"
        name="Sort"
        v-bind:class="{ selected: toggleSort == true }"
      />
      <IconElement
        class="button text-sm text-center  "
        @click="toggleFilters = !toggleFilters"
        icon="&#8860;"
        space="&nbsp;"
        name="Filter"
        v-bind:class="{ selected: toggleFilters == true }"
      />
    </div>
    <div class="content-container justify-end flex items-center py-2 px-2">
      <div v-show="toggleSort">
        <label class="w-40">{{CONSTANTS.SORT}}</label>
        <select
          v-model="sort_filter"
          class="w-40"
          @change="emitSortFilter(sort_filter)"
        >
          <option value="">{{CONSTANTS.MOST_RECOMMENDED}}</option>
          <option value="asc">{{CONSTANTS.A_TO_Z}}</option>
          <option value="desc">{{CONSTANTS.Z_TO_A}}</option>
        </select>
      </div>
      <div v-show="toggleFilters">
        <label class="w-40">{{CONSTANTS.ACCOUNT_TYPE}}</label>
        <select
          v-model="account_type"
          class="w-40 "
          @change="emitAccountType(account_type)"
        >
          <option value="all_types">{{CONSTANTS.ALL_TYPES}}</option>
          <option value="owners">{{CONSTANTS.OWNERS}}</option>
          <option value="admins">{{CONSTANTS.ADMINS}}</option>
          <option value="full_members">{{CONSTANTS.FULL_MEMBERS}}</option>
          <option value="guests">{{CONSTANTS.GUESTS}}</option>
          <option value="deactivated_accounts">{{CONSTANTS.DEACTIVATED_ACCOUNTS}}</option>
          <option value="not_on_slack">{{CONSTANTS.NOT_ON_SLACK}}</option>
        </select>
      </div>
    </div>
  </div>
</template>

<script>
import IconElement from './IconElement.vue';
import { CONSTANTS } from '../../assets/constants';
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
      CONSTANTS: CONSTANTS,
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
