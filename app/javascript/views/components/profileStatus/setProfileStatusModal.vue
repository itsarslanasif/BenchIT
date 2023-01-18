<template>
  <transition name="modal-fade">
    <n-modal
      :on-after-leave="profileStatusStore.toggleProfileStatusPopUp"
      class="modal-width"
      v-model:show="showModal"
      preset="card"
      :title="$t('profilestatus.set_a_status')"
      :content="$t('profilestatus.are_you_sure')"
    >
      <div class="m-0 relative mt-5">
        <div class="mb-6">
          <n-input
            maxlength="23"
            v-model:value="formValue.text_status"
            @keyup="toggleSteps()"
            :on-change="clearInputFields"
            clearable
            :placeholder="$t('profilestatus.what_is_your_status')"
          >
            <template #prefix>
              <n-icon class="px-1">
                <span @click="setEmojiModal" class="cursor-pointer">
                  {{ formValue.emoji_status }}
                </span>
              </n-icon>
            </template>
          </n-input>
        </div>
      </div>
      <div v-if="showEmojiModal" class="absolute z-50">
        <EmojiPicker :toggleModal="toggleEmojiModal" :addReaction="pickEmoji" />
      </div>

      <div v-if="secondStep" class="m-0 relative mt-5">
        <div class="mb-6">
          <n-dropdown
            size="small"
            class="w-48"
            trigger="click"
            :options="clearAfterOptions"
            :show-arrow="true"
            @select="onSelectClearAfterOption"
          >
            <n-input
              class="w-full btn-primary text-left rounded-sm"
              :value="this.formValue.dateTimeString"
              :allow-input="false"
            >
              {{ formValue.dateTimeString }}
            </n-input>
          </n-dropdown>

          <div v-if="showDateTimeInputFields" class="flex mt-6 justify-between">
            <n-date-picker
              class="w-6/12"
              v-model:value="formValue.clear_status_after"
              type="date"
            />
            <n-time-picker
              class="w-2/5"
              v-model:value="formValue.clear_status_after"
              size="medium"
            />
          </div>
        </div>
        <div class="p-2">
          <n-button
            v-if="!profile.status"
            @click="onClickSave"
            class="bg-success text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('actions.save') }}
          </n-button>
          <n-button
            v-if="!profile.status"
            @click="onClickCancel"
            class="bg-slate-600 text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('actions.cancel') }}
          </n-button>

          <n-button
            v-if="profile.status"
            @click="onClickClearStatus"
            class="bg-slate-600 text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
          >
            {{ $t('profilestatus.clear_status') }}
          </n-button>
        </div>
      </div>

      <div v-if="!secondStep">
        <div class="m-0 relative mt-5">
          <div v-if="profileStatusStore.recent_statuses.length" class="mb-6">
            <p class="font-bold text-black-500">
              {{ $t('profilestatus.recent') }}
            </p>
            <div
              v-for="status in profileStatusStore.recent_statuses"
              :key="status.id"
            >
              <statusRow
                :status="status"
                :onSelect="onSelectRecentStatus"
                :isRecent="true"
                :deleteRecentStatus="deleteRecentStatus"
              />
            </div>
          </div>
        </div>

        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">
              {{ $t('profilestatus.for_workspace') }}
            </p>
            <div
              v-for="status in profileStatusStore.workspace_statuses"
              :key="status.id"
            >
              <statusRow
                :status="status"
                :onSelect="this.onSelectRecentStatus"
                :isRecent="false"
              />
            </div>
          </div>
        </div>

        <div class="m-0 relative mt-5">
          <div class="mb-6">
            <p class="font-bold text-black-500">
              {{ $t('profilestatus.automatically_updates') }}
            </p>
            <statusRow
              :status="automaticallyUpdates"
              :onSelect="onSelectRecentStatus"
            />
          </div>
        </div>
      </div>
    </n-modal>
  </transition>
</template>
<script>
import {
  NForm,
  NFormItem,
  NButton,
  NInput,
  NDatePicker,
  NDropdown,
  NModal,
  NTimePicker,
} from 'naive-ui';
import statusRow from './statusRow.vue';
import EmojiPicker from '../../widgets/emojipicker.vue';
import { useProfileStatusStore } from '../../../stores/useProfileStatusStore';
import { ref } from 'vue';
import { handleDateTime } from '../../../handleDateTime.js';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { setProfileStatus } from '../../../api/profiles/profileStatus';
import { clearStatus } from '../../../api/profiles/profileStatus';
import { useDirectMessagesStore } from '../../../stores/useDirectMessagesStore';
import { CONSTANTS } from '../../../assets/constants';

export default {
  name: 'CreateChannel',
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
    statusRow,
    EmojiPicker,
    NDatePicker,
    NDropdown,
    NModal,
    NTimePicker,
  },
  setup() {
    const profileStatusStore = useProfileStatusStore();
    const currentProfile = useCurrentProfileStore();
    const currentWorkspace = useCurrentWorkspaceStore();
    const directMessagesStore = useDirectMessagesStore();
    return {
      currentProfileStore: currentProfile,
      profile: currentProfile.getCurrentProfile,
      workspace: currentWorkspace.getCurrentWorkspace,
      profileStatusStore,
      directMessagesStore,
    };
  },
  data() {
    return {
      handleDateTime: new handleDateTime(),
      showDateTimeInputFields: false,
      showEmojiModal: false,
      showModal: true,
      secondStep: false,
      formValue: {
        text_status: '',
        emoji_status: '🙂',
        clear_status_after: ref(new Date(new Date().setHours(23, 59, 59, 999))),
        dateTimeString: CONSTANTS.TODAY,
      },
      clearAfterOptions: [
        {
          label: CONSTANTS.DONT_CLEAR,
          key: CONSTANTS.DONT_CLEAR,
        },
        {
          label: CONSTANTS.THIRTY_MINUTES,
          key: CONSTANTS.THIRTY_MINUTES,
        },
        {
          label: CONSTANTS.ONE_HOUR_,
          key: CONSTANTS.ONE_HOUR_,
        },
        {
          label: CONSTANTS.FOUR_HOURS,
          key: CONSTANTS.FOUR_HOURS,
        },
        {
          label: CONSTANTS.TODAY,
          key: CONSTANTS.TODAY,
        },
        {
          label: CONSTANTS.THIS_WEEK,
          key: CONSTANTS.THIS_WEEK,
        },
        {
          label: CONSTANTS.CHOOSE_DATE_TIME,
          key: CONSTANTS.CHOOSE_DATE_TIME,
        },
      ],
      automaticallyUpdates: {
        id: 1,
        emoji: '📆',
        text: CONSTANTS.IN_MEETING,
        clear_after: 1740,
      },
    };
  },

  mounted() {
    this.profileStatusStore.setRecentAndWorkspaceStatus();
  },

  beforeMount() {
    if (this.profile.status) {
      this.secondStep = true;
      this.formValue.text_status = this.profile?.status?.text;
      this.formValue.emoji_status = this.profile?.status?.emoji;
      if (this.profile?.status?.clear_after) {
        this.showDateTimeInputFields = true;
        this.formValue.dateTimeString = CONSTANTS.CHOOSE_DATE_TIME;
        this.formValue.clear_status_after = ref(
          new Date(this.profile?.status?.clear_after)
        );
      } else {
        this.showDateTimeInputFields = false;
        this.formValue.dateTimeString = CONSTANTS.DONT_CLEAR;
      }
    }
  },

  methods: {
    pickEmoji(emoji) {
      this.formValue.emoji_status = emoji.i;
      this.setEmojiModal();
    },

    setEmojiModal() {
      this.toggleSteps();
      this.toggleEmojiModal();
    },

    onSelectClearAfterOption(key) {
      this.formValue.dateTimeString = String(key);
      this.formValue.clear_status_after =
        this.handleDateTime.convertStringToTimeStamp(String(key));
      if (String(key) == CONSTANTS.CHOOSE_DATE_TIME)
        this.showDateTimeInputFields = true;
      else this.showDateTimeInputFields = false;
    },

    deleteRecentStatus(id) {
      this.profileStatusStore.deleteRecentStatus(id);
    },

    onClickSave() {
      let obj = {
        text_status: this.formValue.text_status,
        emoji_status: this.formValue.emoji_status,
        clear_status_after: this.isDontCLear(),
      };
      setProfileStatus(this.workspace.id, this.profile.id, obj).then(
        response => {
          this.currentProfileStore.setProfileStatus(response.status);
          this.directMessagesStore.updateProfileStatus(response);
        }
      );
      this.profileStatusStore.toggleProfileStatusPopUp();
    },

    onClickCancel() {
      this.profileStatusStore.toggleProfileStatusPopUp();
    },

    onClickClearStatus() {
      clearStatus(this.workspace.id, this.profile.id)
        .then(response => {
          this.currentProfileStore.setProfileStatus(null);
          this.directMessagesStore.clearMyStatus(this.profile);
        })
        .catch(err => {
          console.log(err);
        });
      this.profileStatusStore.toggleProfileStatusPopUp();
    },

    isDontCLear() {
      if (this.formValue.dateTimeString == CONSTANTS.DONT_CLEAR) {
        return CONSTANTS.DONT_CLEAR;
      }
      
      return new Date(this.formValue.clear_status_after);
    },

    onSelectRecentStatus(selectedOption) {
      this.formValue.text_status = selectedOption.text;
      this.formValue.emoji_status = selectedOption.emoji;
      this.formValue.dateTimeString = CONSTANTS.CHOOSE_DATE_TIME;
      this.formValue.clear_status_after = ref(
        this.handleDateTime.incremntTimeStampBySeconds(
          selectedOption.clear_after
        )
      );
      this.formValue.clear_status_after = ref(
        this.handleDateTime.incremntTimeStampBySeconds(
          selectedOption.clear_after
        )
      );
      this.secondStep = true;
      this.showDateTimeInputFields = true;
      let convertedClearAterTime = this.handleDateTime.secondsToHoursAndMinutes(
        selectedOption.clear_after
      );
      if (
        convertedClearAterTime  == '30 minutes' ||
        convertedClearAterTime == '4 hours' ||
        convertedClearAterTime == 'This Week' ||
        convertedClearAterTime == '1 hours'
      ) {
        this.showDateTimeInputFields = false;
        this.formValue.clear_status_after = ref(
          this.handleDateTime.incremntTimeStampBySeconds(
            selectedOption.clear_after
          )
        );
        this.formValue.dateTimeString =
          this.handleDateTime.secondsToHoursAndMinutes(
            selectedOption.clear_after
          );
      } else if (selectedOption.clear_after == CONSTANTS.DONT_CLEAR) {
        this.showDateTimeInputFields = false;
        this.formValue.dateTimeString = CONSTANTS.DONT_CLEAR;
        this.formValue.clear_status_after = ref(null);
      } else if (selectedOption.clear_after == CONSTANTS.TODAY) {
        this.showDateTimeInputFields = false;
        this.formValue.dateTimeString = CONSTANTS.TODAY;
        this.formValue.clear_status_after = ref(
          this.handleDateTime.getEndOfDayTime()
        );
      }
    },

    toggleEmojiModal() {
      this.showEmojiModal = !this.showEmojiModal;
    },

    toggleSteps() {
      if (
        this.formValue.text_status != '' ||
        this.formValue.emoji_status != '🙂'
      ) {
        console.log(this.formValue);
        this.secondStep = true;
      } else {
        this.secondStep = false;
      }
    },

    closeProfileStatusModal() {
      this.showModal = false;
    },

    clearInputFields() {
      this.formValue.dateTimeString = CONSTANTS.TODAY;
      if (this.formValue.text_status == '') {
        this.formValue.emoji_status = '🙂';
      }
      this.showDateTimeInputFields = false;
      this.formValue.clear_status_after = ref(
        new Date(new Date().setHours(23, 59, 59, 999))
      );
      this.toggleSteps();
    },
  },
};
</script>
<style>
.modal-width {
  width: 400px;
}
</style>
