<template lang="">
  <div>
    <div>
      <p>
        <strong>{{ accessibility.zoom.title }}</strong>
      </p>
      <div v-for="item in accessibility.zoom.settings">
        <input type="radio" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
      <p>{{ accessibility.zoom.tagline }}</p>
    </div>

    <hr class="my-5" />

    <div>
      <p>
        <strong>{{ accessibility.links.title }}</strong>
      </p>
      <div v-for="item in accessibility.links.settings">
        <input type="checkbox" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
    </div>

    <hr class="my-5" />

    <div class="mb-3">
      <p>
        <strong>{{ accessibility.animation.title }}</strong>
      </p>
      <div v-for="item in accessibility.animation.settings">
        <input type="checkbox" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
    </div>

    <div class="mb-3">
      <p>
        <strong>{{ accessibility.screenReader.title }}</strong>
      </p>
      <p>{{ accessibility.screenReader.tagline }}</p>
    </div>

    <div class="mb-3">
      <p>
        <strong>{{ accessibility.messageFormat.title }}</strong>
      </p>
      <div v-for="item in accessibility.messageFormat.settings">
        <input type="checkbox" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
    </div>

    <div class="mb-3">
      <p>
        <strong>{{ accessibility.directMessageAnnouncement.title }}</strong>
      </p>
      <p>{{ accessibility.directMessageAnnouncement.tagline }}</p>
      <div v-for="item in accessibility.directMessageAnnouncement.settings">
        <input type="checkbox" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
      <p>
        {{ accessibility.directMessageAnnouncement.goTo }}
        <span class="text-info">
          {{ accessibility.directMessageAnnouncement.notification }}
        </span>
      </p>
    </div>

    <div>
      <p>
        <strong>{{ accessibility.huddleAnnouncement.title }}</strong>
      </p>
      <p>{{ accessibility.huddleAnnouncement.tagline }}</p>
      <div v-for="item in accessibility.huddleAnnouncement.settings">
        <input type="checkbox" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
    </div>

    <hr class="my-5" />

    <div>
      <p>
        <strong>{{ accessibility.keyboard.title }}</strong>
      </p>
      <p>
        {{ accessibility.keyboard.tagline }}
        <span class="text-info">
          {{ accessibility.keyboard.handyKeyboard }}
        </span>
      </p>
      <p>
        {{ accessibility.keyboard.press }}
      </p>
      <div v-for="item in accessibility.keyboard.settings">
        <input type="radio" />
        <labeL class="pl-3">{{ item.label }}</labeL>
      </div>
      <p>
        {{ accessibility.keyboard.note }}
      </p>
    </div>
  </div>
</template>
<script>
import { accessibility } from '../../../assets/settings/accessibility';
export default {
  data() {
    return {
      accessibility,
    };
  },
};
</script>
