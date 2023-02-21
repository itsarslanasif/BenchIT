export const markAsReadSetting = {
  title: 'Slack marks a channel read as soon as you view it. You can change this if you’d like.',
  viewChannel: {
    title: 'When I view a channel:',
    settings: [
      {
        label: 'Start me where I left off, and mark the channel read',
      },
      {
        label: 'Start me at the newest message, and mark the channel read',
      },
      {
        label: 'Start me at the newest message, but leave unseen messages unread',
      },
    ]
  },
  markEverythingAsRead: {
    title: 'When I mark everything as read:',
    settings: [
      {
        label: 'Prompt to confirm'
      }
    ]
  },
  keyboardShortcuts: {
    title: 'Keyboard Shortcuts',
    markMessagesOfCurrentChannel: 'Mark all messages in current channel as read',
    markMessagesAsRead: 'Mark all messages as read',
    markAsUnread: 'Mark a message as unread',
    clickMessage: 'and click message',
  },
  viewFullShortcuts: 'And that’s just the beginning. To view the full list of keyboard shortcuts, just press'
}