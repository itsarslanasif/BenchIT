export const sidebarSettings = {
  alwaysShowOnSidebar: {
    title: 'Always show in the sidebar',
    settings: [
      {
        field: 'unreads',
        label: 'Unreads',
      },
      {
        field: 'direct-messages',
        label: 'Direct messages',
      },
      {
        field: 'mentions-and-reactions',
        label: 'Mentions & reactions',
      },
      {
        field: 'draft-and-sent',
        label: 'Draft & sent',
      },
      {
        field: 'saved-items',
        label: 'Saved items',
      },
      {
        field: 'connect',
        label: 'Connect',
      },
      {
        field: 'all-channels',
        label: 'All channels',
      },
      {
        field: 'files',
        label: 'Files',
      },
      {
        field: 'people-and-user-group',
        label: 'People & user group',
      },
      {
        field: 'apps',
        label: 'Apps',
      },
    ],
  },
  show: {
    title: 'Show...',
    settings: [
      {
        field: 'all-your-conversation',
        label: 'All your conversation',
      },
      {
        field: 'unreads-only',
        label: 'Unreads only',
      },
      {
        field: 'mentions-only',
        label: 'Mentions only',
      },
      {
        field: 'unread-conversations',
        label: 'Unread conversations, plus your Starred section',
      },
    ],
  },
  sort: {
    title: 'Sort...',
    settings: [
      {
        field: 'alphabetically',
        label: 'Alphabetically',
      },
      {
        field: 'by-most-recent',
        label: 'By most recent',
      },
      {
        field: 'channels-alphabetically-dms-recent-activity',
        label: 'Channels alphabetically and DMs by recent activity',
      },
    ],
  },
  other: {
    settings: [
      {
        label: 'Show profile photos next to DMs',
      },
      {
        label: 'Separate private channels from public ones in sidebar',
      },
      {
        label: 'Separate direct messages and apps from channels in sidebar',
      },
      {
        label: 'Move items with unread Mentions (1) to top of sections',
      },
      {
        label: 'Organize external conversations into the Connections section',
      },
      {
        label: 'Automatically close sidebar based on window size',
      },
    ],
  },
};
