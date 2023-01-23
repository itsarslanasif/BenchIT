<template>
  <right-pane-header :paneTitle="$t('rightpane.profile')" />
  <div
    v-if="userProfileStore.userProfile"
    class="flex flex-col overflow-auto paneBody"
  >
    <div class="flex items-center justify-center p-2">
      <img
        :src="userProfileStore.userProfile.image_url"
        alt="user avatar"
        class="rounded w-90 h-90"
      />
    </div>
    <div class="flex flex-col mt-2">
      <span class="grid grid-cols-12 mx-4">
        <p class="col-span-11 font-bold text-xl truncate">
          {{ userProfileStore.userProfile.username }}
        </p>
        <p
          v-if="ownProfile"
          class="col-span-1 self-center text-info cursor-pointer hover:underline"
        >
          {{ $t('actions.edit') }}
        </p>
      </span>
      <p
        v-if="userProfileStore.userProfile.description"
        class="float-left text-md ml-4 truncate text-black-800 hover:underline cursor-pointer"
      >
        {{ userProfileStore.userProfile.description }}
      </p>
      <p
        v-if="ownProfile && !userProfileStore.userProfile.description"
        class="text-sm ml-4 text-info cursor-pointer hover:underline truncate"
      >
        {{ $t('rightpane.add_description') }}
      </p>
      <p
        v-if="userProfileStore.userProfile.pronounce_name"
        class="float-left text-md ml-4 break-words text-black-800 hover:underline cursor-pointer truncate"
      >
        {{ userProfileStore.userProfile.pronounce_name }}
      </p>
      <p
        v-if="ownProfile && !userProfileStore.userProfile.pronounce_name"
        class="text-sm ml-4 text-info cursor-pointer hover:underline truncate"
      >
        {{ $t('rightpane.add_name_pronounciation') }}
      </p>
      <span
        v-if="userProfileStore.userProfile.status"
        class="flex float-left text-md mx-4 mt-2 break-words text-black-800"
      >
        <font-awesome-icon
          v-if="userProfileStore.userProfile.isActive"
          icon="fa-circle"
          class="self-center text-success text-sm mr-2 px-1"
        />
        <font-awesome-icon
          v-else
          icon="fa-circle"
          class="self-center text-sm mr-2 px-1"
        />
        <p class="truncate">
          {{
            userProfileStore.userProfile.isActive
              ? $t('rightpane.active')
              : $t('rightpane.away')
          }}
        </p>
      </span>
      <span
        v-if="userProfileStore.userProfile.status"
        class="flex float-left text-md mx-4 break-words text-black-800"
      >
        <p class="mr-3 text-lg">
          {{ userProfileStore.userProfile.status.emoji }}
        </p>
        <p class="self-center truncate">
          {{ userProfileStore.userProfile.status.text }}
        </p>
      </span>
      <span class="flex float-left mx-4 text-md break-words text-black-800">
        <font-awesome-icon icon="fa-clock" class="self-center text-lg mr-3" />
        <p class="float-left text-md break-words text-black-800 truncate">
          {{ userProfileStore.userProfile.local_time }}
          {{ $t('rightpane.local_time') }}
        </p>
      </span>
      <span class="flex float-left mt-2">
        <button
          @click="
            goToChat(
              `/profiles/${userProfileStore.userProfile.id}`,
              userProfileStore.userProfile
            )
          "
          class="flex border border-black-800 rounded h-10 px-flexible-xs truncate ml-4 hover:bg-transparent focus:outline-none"
        >
          <p class="w-24 self-center text-md truncate">
            <font-awesome-icon
              v-if="!ownProfile"
              icon="fa-regular fa-comment"
              class="self-center text-lg"
            />
            {{
              ownProfile ? $t('actions.set_a_status') : $t('actions.message')
            }}
          </p>
        </button>
        <button
          class="flex border px-flexible-xs truncate border-black-800 rounded h-10 ml-2 hover:bg-transparent focus:outline-none"
        >
          <p
            class="w-24 self-center text-md truncate"
            :class="{ 'pl-flexible-xs': ownProfile }"
          >
            <font-awesome-icon
              v-if="!ownProfile"
              icon="fa-headphones"
              class="self-center text-lg"
            />
            {{ ownProfile ? $t('actions.view_as') : $t('actions.huddle') }}
          </p>
          <font-awesome-icon
            icon="fa-chevron-down"
            class="self-center text-xs pr-2"
          />
        </button>
        <button
          class="flex border px-flexible-xs truncate border-black-800 rounded h-10 mx-2 hover:bg-transparent focus:outline-none"
        >
          <font-awesome-icon
            icon="fa-ellipsis-vertical"
            class="self-center text-lg"
          />
        </button>
      </span>
    </div>
    <n-divider v-if="userProfileStore.userProfile.contact_info" />
    <span
      v-if="userProfileStore.userProfile.contact_info"
      class="flex flex-col float-left mx-4 mb-2 text-black-800"
    >
      <span class="grid grid-cols-12">
        <p class="col-span-11 font-bold text-md truncate">
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
        class="hover-trigger grid grid-cols-12 justify-between float-left mt-2 text-black-800"
      >
        <span class="col-span-10">
          <font-awesome-icon
            icon="fa-envelope"
            class="self-center float-left text-sm p-3 mr-2 bg-transparent rounded-md"
          />
          <span
            class="float-left w-flexible-lg text-lg text-black-800 truncate"
          >
            <p class="text-sm truncate">{{ $t('rightpane.email_address') }}</p>
            <p
              v-if="userProfileStore.userProfile.contact_info.email"
              id="email_address"
              class="text-sm text-info cursor-pointer hover:underline break-words truncate"
            >
              {{ userProfileStore.userProfile.contact_info.email }}
            </p>
            <p
              v-if="
                ownProfile && !userProfileStore.userProfile.contact_info.email
              "
              @click="toggleEditContactInfoModal"
              class="text-sm text-info cursor-pointer hover:underline truncate"
            >
              {{ $t('rightpane.add_email') }}
            </p>
          </span>
        </span>
        <span class="col-span-2">
          <n-tooltip placement="top" trigger="click">
            <template #trigger>
              <font-awesome-icon
                v-if="userProfileStore.userProfile.contact_info.email"
                @click="copyEmailAddress"
                icon="fa-copy"
                class="hover-target self-center text-sm p-2 float-right cursor-pointer bg-transparent rounded-md focus:outline-none"
              />
            </template>
            <span class="truncate"> {{ $t('actions.copied') }} </span>
          </n-tooltip>
        </span>
      </span>
      <span
        class="hover-trigger grid grid-cols-12 justify-between float-left mt-2 text-black-800"
      >
        <span class="col-span-10">
          <font-awesome-icon
            icon="fa-phone"
            class="self-center float-left text-sm p-3 mr-2 bg-transparent rounded-md"
          />
          <span
            class="float-left w-flexible-lg text-lg text-black-800 truncate"
          >
            <p class="text-sm truncate">{{ $t('rightpane.phone') }}</p>
            <p
              v-if="userProfileStore.userProfile.contact_info.phone"
              id="phone_number"
              class="text-sm text-info cursor-pointer hover:underline break-words truncate"
            >
              {{ userProfileStore.userProfile.contact_info.phone }}
            </p>
            <p
              v-if="
                ownProfile && !userProfileStore.userProfile.contact_info.phone
              "
              @click="toggleEditContactInfoModal"
              class="text-sm text-info cursor-pointer hover:underline truncate"
            >
              {{ $t('rightpane.add_phone') }}
            </p>
          </span>
        </span>
        <span class="col-span-2">
          <n-tooltip placement="top" trigger="click">
            <template #trigger>
              <font-awesome-icon
                v-if="userProfileStore.userProfile.contact_info.phone"
                @click="copyPhoneNumber"
                icon="fa-copy"
                class="hover-target self-center text-sm p-2 float-right cursor-pointer bg-transparent rounded-md focus:outline-none"
              />
            </template>
            <span class="truncate"> {{ $t('actions.copied') }} </span>
          </n-tooltip>
        </span>
      </span>
    </span>
    <n-divider v-if="userProfileStore.userProfile.about_me" />
    <span
      v-if="userProfileStore.userProfile.about_me"
      class="flex flex-col float-left mx-4 mb-2 text-black-800"
    >
      <span class="grid grid-cols-12">
        <p class="col-span-11 font-bold text-md break-words truncate">
          {{ $t('rightpane.about_me') }}
        </p>
        <p
          v-if="ownProfile"
          @click="toggleEditAboutMeModal"
          class="col-span-1 self-center text-info cursor-pointer hover:underline"
        >
          {{ $t('actions.edit') }}
        </p>
      </span>
      <span
        v-if="userProfileStore.userProfile.about_me"
        class="grid grid-cols-8 float-left mt-2 text-black-800"
      >
        <span class="col-span-2 float-left text-md text-black-800">
          <p class="text-sm truncate">{{ $t('rightpane.skype') }}</p>
          <p
            v-if="userProfileStore.userProfile.about_me.skype"
            class="text-sm text-info cursor-pointer hover:underline w-48 truncate"
          >
            {{ userProfileStore.userProfile.about_me.skype }}
          </p>
          <p
            v-if="ownProfile && !userProfileStore.userProfile.about_me.skype"
            @click="toggleEditAboutMeModal"
            class="text-sm text-info cursor-pointer hover:underline truncate"
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
    <EditAboutMeModal
      v-if="showAboutMeModal"
      v-model:show="showAboutMeModal"
      :toggleModal="toggleEditAboutMeModal"
      :userAboutMe="userProfileStore.userProfile.about_me"
    />
  </div>
</template>

<script>
import { NDivider, NTooltip } from 'naive-ui';
import RightPaneHeader from './RightPaneHeader.vue';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import EditContactInfoModal from '../../widgets/EditContactInfoModal.vue';
import EditAboutMeModal from '../../widgets/EditAboutMeModal.vue';
import { useMessageStore } from '../../../stores/useMessagesStore';

export default {
  components: {
    RightPaneHeader,
    NDivider,
    NTooltip,
    EditContactInfoModal,
    EditAboutMeModal,
  },
  data() {
    return {
      showContactInfoModal: false,
      showAboutMeModal: false,
    };
  },
  setup() {
    const userProfileStore = useUserProfileStore();
    const currentProfileStore = useCurrentProfileStore();
    const messagesStore = useMessageStore();
    return { userProfileStore, currentProfileStore, messagesStore };
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
    toggleEditAboutMeModal() {
      this.showAboutMeModal = !this.showAboutMeModal;
    },
    toggleEditAboutMeModal() {
      this.showAboutMeModal = !this.showAboutMeModal;
    },
    goToChat(chatURL, user) {
      this.messagesStore.setSelectedChat(user);
      this.$router.push(chatURL);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
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
