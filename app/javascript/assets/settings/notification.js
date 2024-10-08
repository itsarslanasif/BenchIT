export const notificationSettings = {
  notifyMeAbout: {
    title: 'Notify me about...',
    settings: [
      {
        field: 'all-new-messages',
        label: 'All new messages',
      },
      {
        field: 'dm-mentions-keywords',
        label: 'Direct messages, mentions & keywords',
      },
      {
        field: 'nothing',
        label: 'Nothing',
      },
    ],
  },
  settingForPhone: {
    settings: [
      {
        field: 'different-setting-for-phone',
        label: 'Different Setting for Phone',
      },
    ],
  },
  huddleAndReplies: {
    settings: [
      {
        field: 'notify-me-when-huddle-starts',
        label: 'Notify me when a huddle starts in one of my channels',
      },
      {
        field: 'notify-me-about-replies',
        label: "Notify me about replies to threads I'm following",
      },
    ],
  },
  badgeSetting: {
    settings: [
      {
        field: 'show-badge-in-sidebar',
        label:
          'Show a badge in my sidebar when I have a new Slack Connect invitation',
      },
    ],
  },
  notificationSchedule: {
    title: 'Notification schedule:',
    sectionHeading: 'Allow motification',
    tagline:
      "You'll only receive notifications in the hours you choose. Outside of those times, notifications will be paused.",
    notifyMeEvery: [
      {
        id: 'notify-me-every',
        options: [
          {
            id: 'everyday',
            label: 'Everyday',
          },
          {
            id: 'weekdays',
            label: 'Weekdays',
          },
          {
            id: 'custom',
            label: 'Custom',
          },
        ],
      },
    ],
    from: [
      {
        id: 'from',
        options: [
          {
            label: '10 AM',
          },
          {
            label: '10:30 AM',
          },
        ],
      },
    ],
    to: [
      {
        id: 'from',
        options: [
          {
            label: '10 PM',
          },
          {
            label: '10:30 PM',
          },
        ],
      },
    ],
    defaultTime: [
      {
        id: 'from',
        options: [
          {
            label: '9 M',
          },
          {
            label: '9:30 AM',
          },
        ],
      },
    ],
  },
  soundAndAppearance: {
    title: 'Sound & appearance',
    tagline: 'Choose how notifications look, sound, and behave.',
    settings: [
      {
        label: 'Notification sound (messages)',
        field: 'notification-sound-messages',
        options: [
          {
            field: 'knock-knock',
            label: 'Knock Knock',
          },
          {
            field: 'ding-dong',
            label: 'Ding dong',
          },
        ],
      },
      {
        label: 'Notification sound (huddles)',
        field: 'notification-sound-huddles',
        options: [
          {
            field: 'knock-knock',
            label: 'Knock Knock',
          },
          {
            field: 'ding-dong',
            label: 'Ding dong',
          },
        ],
      },
      {
        label: 'Notification sound (sending a direct messages)',
        field: 'notification-sound-direct-messages',
        options: [
          {
            field: 'knock-knock',
            label: 'Knock Knock',
          },
          {
            field: 'ding-dong',
            label: 'Ding dong',
          },
        ],
      },
      {
        label: 'Notification sound (receiving a DM while in the conversation)',
        field: 'notification-sound-receiving-messages',
        options: [
          {
            field: 'knock-knock',
            label: 'Knock Knock',
          },
          {
            field: 'ding-dong',
            label: 'Ding dong',
          },
        ],
      },
    ],
  },
  notActiveOnDesktop: {
    title: "When I'm not active on desktop ...",
    tagline: 'Choose how notifications look, sound, and behave.',
    sectionHeading: 'Send notifications to my mobile devices:',
    settings: [
      {
        label: 'Notification sound (messages)',
        field: 'notification-sound-messages',
        options: [
          {
            field: 'knock-knock',
            label: 'Immediately, even if I am active',
          },
          {
            field: 'ding-dong',
            label: 'Ding dong',
          },
        ],
      },
    ],
  },
};
