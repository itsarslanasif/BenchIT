<template>
  <right-pane-header :paneTitle="$t('rightpane.profile')" />
  <div class="flex flex-col overflow-auto paneBody">
    <div class="flex items-center justify-center mt-2">
      <img
        :src="userProfileStore.userProfile?.image_url"
        alt="user avatar"
        class="rounded-lg w-90 h-90"
      />
    </div>
    <div class="flex flex-col mt-2">
      <span class="grid grid-cols-12 mx-4">
        <p class="col-span-11 font-bold text-xl break-words">
          {{ userProfileStore.userProfile?.username }}
        </p>
        <p
          v-if="ownProfile"
          class="col-span-1 self-center text-info cursor-pointer hover:underline"
        >
          {{ $t('actions.edit') }}
        </p>
      </span>
      <p
        v-if="userProfileStore.userProfile?.description"
        class="float-left text-md ml-4 break-words text-black-800 hover:underline cursor-pointer"
      >
        {{ userProfileStore.userProfile?.description }}
      </p>
      <p
        v-if="ownProfile && !userProfileStore.userProfile?.description"
        class="text-sm ml-4 text-info cursor-pointer hover:underline"
      >
        {{ $t('rightpane.add_description') }}
      </p>
      <p
        v-if="userProfileStore.userProfile?.pronounce_name"
        class="float-left text-md ml-4 break-words text-black-800 hover:underline cursor-pointer"
      >
        {{ userProfileStore.userProfile?.pronounce_name }}
      </p>
      <p
        v-if="ownProfile && !userProfileStore.userProfile?.pronounce_name"
        class="text-sm ml-4 text-info cursor-pointer hover:underline"
      >
        {{ $t('rightpane.add_name_pronounciation') }}
      </p>
      <span
        v-if="userProfileStore.userProfile?.status"
        class="flex float-left text-md mx-4 mt-2 break-words text-black-800"
      >
        <font-awesome-icon
          v-if="userProfileStore.userProfile?.isActive"
          icon="fa-circle"
          class="self-center text-success text-sm mr-2 px-1"
        />
        <font-awesome-icon
          v-else
          icon="fa-circle"
          class="self-center text-sm mr-2 px-1"
        />
        <p>
          {{
            userProfileStore.userProfile?.isActive
              ? $t('rightpane.active')
              : $t('rightpane.away')
          }}
        </p>
      </span>
      <span
        v-if="userProfileStore.userProfile?.status"
        class="flex float-left text-md mx-4 break-words text-black-800"
      >
        <p class="mr-3 text-lg">
          {{ userProfileStore.userProfile?.status.emoji }}
        </p>
        <p class="self-center">
          {{ userProfileStore.userProfile?.status.text }}
        </p>
      </span>
      <span class="flex float-left mx-4 text-md break-words text-black-800">
        <font-awesome-icon icon="fa-clock" class="self-center text-lg mr-3" />
        <p class="float-left text-md break-words text-black-800">
          {{ userProfileStore.userProfile?.local_time }}
          {{ $t('rightpane.local_time') }}
        </p>
      </span>
      <span class="flex float-left mt-2">
        <button
          class="flex border border-black-800 rounded h-10 px-10 ml-4 hover:bg-transparent focus:outline-none"
        >
          <font-awesome-icon
            v-if="!ownProfile"
            icon="fa-comment-dots"
            class="self-center text-lg pr-1"
          />
          <p class="self-center text-md">
            {{
              ownProfile ? $t('actions.set_a_status') : $t('actions.message')
            }}
          </p>
        </button>
        <button
          class="flex border border-black-800 rounded h-10 ml-2 hover:bg-transparent focus:outline-none"
        >
          <font-awesome-icon
            v-if="!ownProfile"
            icon="fa-headphones"
            class="self-center text-lg pr-1 pl-8"
          />
          <p class="pr-6 self-center text-md" :class="{ 'pl-8': ownProfile }">
            {{ ownProfile ? $t('actions.view_as') : $t('actions.huddle') }}
          </p>
          <font-awesome-icon
            icon="fa-chevron-down"
            class="self-center text-xs pr-2"
          />
        </button>
        <button
          class="flex border border-black-800 rounded h-10 px-4 ml-2 hover:bg-transparent focus:outline-none"
        >
          <font-awesome-icon
            icon="fa-ellipsis-vertical"
            class="self-center text-lg"
          />
        </button>
      </span>
    </div>
    <n-divider v-if="userProfileStore.userProfile?.contact_info" />
    <span
      v-if="userProfileStore.userProfile?.contact_info"
      class="flex flex-col float-left mx-4 mb-2 text-black-800"
    >
      <span class="grid grid-cols-12">
        <p class="col-span-11 font-bold text-md break-words">
          {{ $t('rightpane.contact_information') }}
        </p>
        <p
          v-if="ownProfile"
          @click="toggleEditContactInfoModal"
          class="col-span-1 self-center text-info cursor-pointer hover:underline"
        >
          {{ $t('actions.edit') }}
        </p>
      </span>
      <span
        class="hover-trigger grid grid-cols-8 float-left mt-2 text-black-800"
      >
        <font-awesome-icon
          icon="fa-envelope"
          class="col-span-1 self-center text-lg p-3 bg-transparent rounded-md"
        />
        <span class="col-span-2 -ml-4 float-left text-lg text-black-800">
          <p class="text-sm">{{ $t('rightpane.email_address') }}</p>
          <p
            v-if="userProfileStore.userProfile?.contact_info?.email"
            id="email_address"
            class="text-sm text-info cursor-pointer hover:underline"
          >
            {{ userProfileStore.userProfile?.contact_info?.email }}
          </p>
          <p
            v-if="
              ownProfile && !userProfileStore.userProfile?.contact_info?.email
            "
            class="text-sm text-info cursor-pointer hover:underline"
          >
            {{ $t('rightpane.add_email') }}
          </p>
        </span>
        <span class="col-span-4" />
        <n-tooltip placement="top" trigger="click">
          <template #trigger>
            <font-awesome-icon
              v-if="userProfileStore.userProfile?.contact_info?.email"
              @click="copyEmailAddress"
              icon="fa-copy"
              class="hover-target col-span-1 self-center text-lg p-2 mr-2 float-right cursor-pointer bg-transparent rounded-md focus:outline-none"
            />
          </template>
          <span> {{ $t('actions.copied') }} </span>
        </n-tooltip>
      </span>
      <span
        class="hover-trigger grid grid-cols-8 float-left text-lg mt-2 text-black-800"
      >
        <font-awesome-icon
          icon="fa-phone"
          class="col-span-1 self-center text-lg p-3 bg-transparent rounded-md"
        />
        <span class="col-span-2 -ml-4 float-left text-lg text-black-800">
          <p class="text-sm">{{ $t('rightpane.phone') }}</p>
          <p
            v-if="userProfileStore.userProfile?.contact_info?.phone"
            id="phone_number"
            class="text-sm text-info cursor-pointer hover:underline"
          >
            {{ userProfileStore.userProfile?.contact_info?.phone }}
          </p>
          <p
            v-if="
              ownProfile && !userProfileStore.userProfile?.contact_info?.phone
            "
            class="text-sm text-info cursor-pointer hover:underline"
          >
            {{ $t('rightpane.add_phone') }}
          </p>
        </span>
        <span class="col-span-4" />
        <n-tooltip placement="top" trigger="click">
          <template #trigger>
            <font-awesome-icon
              v-if="userProfileStore.userProfile?.contact_info?.phone"
              @click="copyPhoneNumber"
              icon="fa-copy"
              class="hover-target col-span-1 self-center text-lg p-2 mr-2 float-right cursor-pointer bg-transparent rounded-md focus:outline-none"
            />
          </template>
          <span> {{ $t('actions.copied') }} </span>
        </n-tooltip>
      </span>
    </span>
    <n-divider v-if="userProfileStore.userProfile?.about_me" />
    <span
      v-if="userProfileStore.userProfile?.about_me"
      class="flex flex-col float-left mx-4 mb-2 text-black-800"
    >
      <span class="grid grid-cols-12">
        <p class="col-span-11 font-bold text-md break-words">
          {{ $t('rightpane.about_me') }}
        </p>
        <p
          v-if="ownProfile"
          class="col-span-1 self-center text-info cursor-pointer hover:underline"
        >
          {{ $t('actions.edit') }}
        </p>
      </span>
      <span class="grid grid-cols-8 float-left mt-2 text-black-800">
        <span class="col-span-2 float-left text-md text-black-800">
          <p class="text-sm">{{ $t('rightpane.skype') }}</p>
          <p
            v-if="userProfileStore.userProfile?.about_me?.skype"
            class="text-sm text-info cursor-pointer hover:underline"
          >
            {{ userProfileStore.userProfile?.about_me?.skype }}
          </p>
          <p
            v-if="ownProfile && !userProfileStore.userProfile?.about_me?.skype"
            class="text-sm text-info cursor-pointer hover:underline"
          >
            {{ $t('rightpane.add_skype') }}
          </p>
        </span>
      </span>
    </span>
    <EditContactInfoModal
      v-if="showContactInfoModal"
      v-model:show="showContactInfoModal"
      :toggleModal="toggleEditContactInfoModal"
      :userContactInfo="userProfileStore.userProfile.contact_info"
    />
  </div>
</template>

<script>
import { NDivider, NTooltip } from 'naive-ui';
import RightPaneHeader from './RightPaneHeader.vue';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import EditContactInfoModal from '../../widgets/EditContactInfoModal.vue';

export default {
  components: { RightPaneHeader, NDivider, NTooltip, EditContactInfoModal },
  data() {
    return {
      showContactInfoModal: false,
    };
  },
  setup() {
    const userProfileStore = useUserProfileStore();
    const currentProfileStore = useCurrentProfileStore();
    return { userProfileStore, currentProfileStore };
  },
  computed: {
    ownProfile() {
      return (
        this.currentProfileStore.currentProfile.id ===
        this.userProfileStore.userProfile.id
      );
    },
  },
  methods: {
    copyEmailAddress() {
      let element = document.getElementById('email_address');
      this.copyTextClipBoard(element.textContent);
    },
    copyPhoneNumber() {
      let element = document.getElementById('phone_number');
      this.copyTextClipBoard(element.textContent);
    },
    copyTextClipBoard(text) {
      navigator.clipboard.writeText(text);
    },
    toggleEditContactInfoModal() {
      this.showContactInfoModal = !this.showContactInfoModal;
    },
  },
};
</script>

<style scoped>
.paneBody {
  height: 89vh;
}
.hover-trigger .hover-target {
  display: none;
}
.hover-trigger:hover .hover-target {
  display: block;
}
</style>
