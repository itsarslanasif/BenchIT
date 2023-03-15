<template>
  <transition name="fade" appear>
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div
        class="modal rounded-md w-2/5 h-2/5 shadow-md bg-white"
        role="dialog"
      >
        <div class="p-8">
          <header id="modalTitle" class="flex w-full justify-between">
            <div class="w-5/6 text-lg text-black-900">
              <h1>{{ title }}</h1>
            </div>

            <font-awesome-icon
              @click="closeModal"
              class="hover:text-primary text-black-500 px-3 py-1 w-5 h-5"
              icon="fa-solid fa-xmark"
            />
          </header>
          <div class="m-0 relative mt-5">
            <div class="mb-6 text-black-500">
              <p>
                {{ $t('groups.add_group_note') }}
              </p>
            </div>
            <n-select
              vertical
              v-model:value="selectedValues"
              multiple
              filterable
              :placeholder="$t('placeholder.add_people_to_channel')"
              :options="options"
              :loading="loading"
              clearable
              :max-tag-count="maxCount"
              remote
              :clear-filter-after-select="true"
              :show-arrow="false"
              size="large"
            />
            <n-button
              @click="onSubmit"
              class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded"
              :disabled="isDisabled"
              type="success"
            >
              {{ createNewGroup ? $t('actions.create') : $t('actions.add') }}
            </n-button>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import {
  NForm,
  NFormItem,
  NButton,
  NInput,
  NSwitch,
  NSpace,
  NSelect,
} from 'naive-ui';
import { useChannelStore } from '../../../stores/useChannelStore';
import vClickOutside from 'click-outside-vue3';
import GraphemeSplitter from 'grapheme-splitter';
import { useMessage } from 'naive-ui';
import { useProfileStore } from '../../../stores/useProfileStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { ref } from 'vue';
import { createGroup } from '../../../api/groups/groups';
import { useGroupStore } from '../../../stores/useGroupStore';
import { addGroupMembers } from '../../../api/groups/groups';
import { errorHandler } from '../../widgets/messageProvider';
export default {
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
    NSwitch,
    NSpace,
    NSelect,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  props: ['closeModal', 'title', 'createNewGroup', 'groupId'],

  computed: {
    isDisabled() {
      if (!this.createNewGroup)
        return this.selectedValues === null || this.selectedValues.length === 0;
      else {
        return this.selectedValues === null || this.selectedValues.length < 2;
      }
    },
  },
  data() {
    return {
      options: ref([]),
      selectedValues: ref(null),
      maxCount: 6,
    };
  },

  mounted() {
    const { profilesStore, currentProfile } = this;
    const filteredProfiles = profilesStore.profiles.filter(
      ({ id }) => id !== currentProfile.id
    );
    this.options = filteredProfiles.map(({ id, username }) => ({
      value: id,
      label: username,
    }));
  },
  setup() {
    const channelStore = useChannelStore();
    const splitter = new GraphemeSplitter();
    const messageStore = useMessage();
    const profilesStore = useProfileStore();
    const groupStore = useGroupStore();
    const { currentProfile } = useCurrentProfileStore();

    return {
      channelStore,
      profilesStore,
      messageStore,
      currentProfile,
      groupStore,
      countGraphemes: value => splitter.countGraphemes(value),
    };
  },
  methods: {
    onSubmit() {
      if (this.createNewGroup) {
        createGroup([...this.selectedValues, this.currentProfile.id])
          .then(res => {
            const { group, name } = res;
            const updatedGroup = { ...group, name };
            this.groupStore.isNewGroup(updatedGroup);
            this.$router.push(`/groups/${group.id}`);
            this.closeModal();
          })
          .catch(e => {
            errorHandler(e.response.data.message);
          });
      } else {
        addGroupMembers(this.selectedValues, this.groupId)
          .then(res => {
            const { group, name } = res;
            const updatedGroup = { ...group, name };
            this.$router.push(`/groups/${updatedGroup.id}`);
            this.closeModal();
          })
          .catch(e => {
            errorHandler(e.response.data.message);
          });
      }
    },
  },
};
</script>
