export default [
  {
    label: 'Turn off notifications for replies',
    key: 'turn-off-notifications-for-replies',
  },
  {
    type: 'divider',
    key: 'd1',
  },
  {
    label: 'Mark unread',
    key: 'mark-unread',
  },
  {
    label: 'Remind me about this',
    key: 'remind-me-about-this',
    children: [
      {
        label: 'In 20 minutes',
        key: 'in-20-minutes',
      },
      {
        label: 'In 1 hour',
        key: 'in-1-hour',
      },
      {
        label: 'In 3 hours',
        key: 'in-3-hours',
      },
      {
        label: 'Tommorow',
        key: '8',
      },
      {
        label: 'Next week',
        key: 'tommorow',
      },
      {
        label: 'Custom',
        key: 'custom',
      },
    ],
  },
  {
    type: 'divider',
    key: 'd2',
  },
  {
    label: 'Copy link',
    key: 'copy-link',
  },
  {
    type: 'divider',
    key: 'd3',
  },
  {
    label: 'Pin to this conversation',
    key: 'pin-to-this-conversation',
  },
  {
    type: 'divider',
    key: 'd4',
  },
  {
    label: 'Edit message',
    key: 'edit-message',
  },
  {
    label: 'Delete message',
    key: 'delete-message',
  },
];
