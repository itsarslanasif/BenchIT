<template>
  <div class="">
    <div class="my-3">
      <strong>{{ notificationSettings.notifyMeAbout.title }}</strong>
      <div class="mt-2">
        <div v-for="item in notificationSettings.notifyMeAbout.settings">
          <input
            type="radio"
            :id="item.field"
            :value="item.field"
            v-model="notifyMeAbout"
          />
          <label :for="item.field" class="pl-3"> {{ item.label }} </label><br />
        </div>
      </div>
    </div>
    <div>
      <div v-for="item in notificationSettings.settingForPhone.settings">
        <input type="checkbox" :id="item.field" />
        <label :for="item.field" class="pl-3">
          {{ item.label }}
        </label>
      </div>
    </div>
    <hr class="my-3" />
    <div>
      <div v-for="item in notificationSettings.huddleAndReplies.settings">
        <input type="checkbox" :id="item.field" />
        <label :for="item.field" class="pl-3"> {{ item.label }} </label><br />
      </div>
      <p class="py-2">
        You have set special notification rules for
        <span class="text-info">2 channels.</span>
      </p>
    </div>
    <hr class="my-3" />
    <div class="my-3">
      <div v-for="item in notificationSettings.huddleAndReplies.badgeSetting">
        <input type="checkbox" :id="item.field" />
        <label :for="item.field" class="pl-3"> {{ item.label }} </label><br />
      </div>
    </div>
    <div>
      <strong>My keywords</strong>
      <p class="py-3">
        Show a badge (1) in my channel list when someone uses one of my
        keywords:
      </p>
      <textarea
        class="w-full rounded border border-black-600"
        rows="4"
      ></textarea>
      <p class="text-xs text-black-600 -mt-1">
        Use commas to separate each keyword. Keywords are not case sensitive.
      </p>
    </div>
    <hr class="my-3" />
    <div>
      <strong>Notification schedule</strong>
      <p class="py-3">
        {{ notificationSettings.notificationSchedule.tagline }}
        <span class="text-info">Learn more</span>
      </p>
      <strong>{{
        notificationSettings.notificationSchedule.sectionHeading
      }}</strong
      ><br />
      <select
        v-for="item in notificationSettings.notificationSchedule.notifyMeEvery"
        class="py-3 px-5 mr-8 mt-2 rounded"
      >
        <option v-for="option in item.options" class="bg-gray-50">
          {{ option.label }}
        </option>
      </select>
      <select
        v-for="item in notificationSettings.notificationSchedule.from"
        class="py-3 px-5 mr-3 rounded"
      >
        <option v-for="option in item.options" class="bg-gray-50">
          {{ option.label }}
        </option>
      </select>
      to
      <select
        v-for="item in notificationSettings.notificationSchedule.to"
        class="py-3 px-5 mr-3 rounded"
      >
        <option v-for="option in item.options" class="bg-gray-50">
          {{ option.label }}
        </option></select
      ><br /><br />
      <strong>Set a default time for reminder notifications:</strong><br />
      <select
        v-for="item in notificationSettings.notificationSchedule.defaultTime"
        class="py-3 px-5 mr-3 rounded"
      >
        <option v-for="option in item.options" class="bg-gray-50">
          {{ option.label }}
        </option>
      </select>
      <br />
      <p class="text-xs text-black-600 -mt-1">
        <span class="text-info">Reminders you set</span> for a specific day
        (like “tomorrow”) will be sent at the time you select.
      </p>
    </div>
    <hr class="my-3" />
    <div>
      <strong>{{ notificationSettings.soundAndAppearance.title }}</strong>
      <p class="pt-3">{{ notificationSettings.soundAndAppearance.tagline }}</p>
      <button
        class="border border-primary px-3 py-1 rounded font-semibold my-3"
      >
        Show an example</button
      ><br />
      <input type="checkbox" id="show-badge-in-sidebar" />
      <label for="show-badge-in-sidebar" class="pl-3">
        Include a preview of the message in each notification (disable this for
        extra privacy) </label
      ><br />
      <input type="checkbox" id="show-badge-in-sidebar" />
      <label for="show-badge-in-sidebar" class="pl-3">
        Mute all sounds from Slack </label
      ><br />
      <div class="my-3">
        <div v-for="item in notificationSettings.soundAndAppearance.settings">
          <label>{{ item.label }}</label>
          <br />
          <select class="py-3 px-20 mr-3 rounded">
            <option v-for="option in item.options">
              {{ option.label }}
            </option>
          </select>
          <br />
        </div>
      </div>
    </div>
    <hr class="my-3" />
    <div>
      <strong>{{ notificationSettings.notActiveOnDesktop.title }}</strong>
      <br />
      <label>
        {{ notificationSettings.notActiveOnDesktop.sectionHeading }}
      </label>
      <br />
      <select
        v-for="item in notificationSettings.notActiveOnDesktop.settings"
        class="py-3 px-10 mr-3 rounded mb-5"
      >
        <option v-for="option in item.options" class="bg-gray-50">
          {{ option.label }}
        </option></select
      ><br />
      <input type="checkbox" id="notify-me-about-replies" />
      <label for="notify-me-about-replies" class="pl-3">
        Send me email notifications for mentions and direct messages
      </label>
    </div>
    <hr class="my-3" />
    <div>
      <strong>Channel-specific notifications</strong>
    </div>
  </div>
</template>
<script>
import { notificationSettings } from '../../../assets/settings/notification';
export default {
  data() {
    return {
      notifyMeAbout: '',
      differentSettingForMobile: '',
      notificationSettings,
    };
  },
};
</script>
