<template>
  <div class="px-5 py-2">
    <n-space vertical>
      <n-input
        type="text"
        size="large"
        v-model:value="searchMemberInput"
        @keyup="handleSubmit(searchMemberInput, sortValue)"
        :placeholder="$t('members.search_by_name')"
      >
        <template #prefix>
          <n-icon :component="SearchOutline" />
        </template>
      </n-input>
    </n-space>
    <div class="flex items-center py-1 justify-between">
      <div class="text-small text-gray-900 font-thin">
        {{ members.length }} {{ $t('channels.result') }}
      </div>
      <div class="flex gap-2">
        <n-dropdown
          trigger="hover"
          :options="sortOptions"
          @select="handleSortSelect"
        >
          <n-button>{{ $t('filters.sort_label') }} {{ sortValue }}</n-button>
        </n-dropdown>

        <n-dropdown
          trigger="hover"
          :options="filterOptions"
          @select="handleFilterSelect"
        >
          <n-button
            >{{ $t('filters.filter_label') }} {{ filterValue }}</n-button
          >
        </n-dropdown>
      </div>
    </div>
  </div>
</template>

<script>
import { NInput, NButton, NPopselect, NDropdown } from 'naive-ui';
import { SearchOutline } from '@vicons/ionicons5';
import { ref } from 'vue';
import { CONSTANTS } from '../../assets/constants';

export default {
  props: ['handleSubmit', 'members'],
  components: {
    NInput,
    NDropdown,
    NButton,
    NPopselect,
  },
  data() {
    return {
      searchMemberInput: '',
      sortOptions: [
        {
          label: CONSTANTS.MOST_RECOMMENDED,
          key: this.generateKey(CONSTANTS.MOST_RECOMMENDED),
        },
        {
          label: CONSTANTS.A_TO_Z,
          key: this.generateKey(CONSTANTS.A_TO_Z),
        },
        {
          label: CONSTANTS.Z_TO_A,
          key: this.generateKey(CONSTANTS.Z_TO_A),
        },
      ],

      filterOptions: [
        {
          label: CONSTANTS.ADMINS,
          key: this.generateKey(CONSTANTS.ADMINS),
          disabled: true,
        },
        {
          label: CONSTANTS.FULL_MEMBERS,
          key: this.generateKey(CONSTANTS.FULL_MEMBERS),
          disabled: true,
        },
        {
          label: CONSTANTS.GUESTS,
          key: this.generateKey(CONSTANTS.GUESTS),
          disabled: true,
        },
        {
          label: CONSTANTS.DEACTIVATED_ACCOUNTS,
          key: this.generateKey(CONSTANTS.DEACTIVATED_ACCOUNTS),
          disabled: true,
        },
        {
          label: CONSTANTS.NOT_ON_SLACK,
          key: this.generateKey(CONSTANTS.NOT_ON_SLACK),
          disabled: true,
        },
      ],
    };
  },
  setup() {
    return {
      SearchOutline,
      sortValue: ref(CONSTANTS.MOST_RECOMMENDED),
      filterValue: ref(CONSTANTS.FULL_MEMBERS),
      searchMemberInput: ref(''),
    };
  },

  methods: {
    handleSortSelect(key) {
      console.log(key);
      switch (key) {
        case 'most-recommended':
          this.sortValue = CONSTANTS.MOST_RECOMMENDED;
          this.handleSubmit(this.searchMemberInput, '');
          break;
        case 'a-to-z':
          this.sortValue = CONSTANTS.A_TO_Z;
          this.handleSubmit(this.searchMemberInput, CONSTANTS.ASCENDING);
          break;
        case 'z-to-a':
          this.sortValue = CONSTANTS.Z_TO_A;
          this.handleSubmit(this.searchMemberInput, CONSTANTS.DESCENDING);
          break;
      }
    },
    handleFilterSelect(key) {
      console.log(key);
      switch (key) {
        case 'admins':
          this.filterValue = CONSTANTS.ADMINS;
          break;
        case 'full-members':
          this.filterValue = CONSTANTS.FULL_MEMBERS;
          break;
        case 'guests':
          this.filterValue = CONSTANTS.GUESTS;
          break;
        case 'deactivated-accounts':
          this.filterValue = CONSTANTS.DEACTIVATED_ACCOUNTS;
          break;
        case 'not-on-slack':
          this.filterValue = CONSTANTS.NOT_ON_SLACK;
          break;
      }
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>

<style scoped></style>
