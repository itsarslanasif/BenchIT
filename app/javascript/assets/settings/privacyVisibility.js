export const privacyVisibilitySettings = {
  title: 'Slack Connect discoverability',
  tagline:
    'Choose who can find you via Slack search. They’ll only be able to see that you’re on Slack - no personal or workspace details will be shared.',
  canFind: {
    settings: [
      {
        label: 'Anyone with your email address',
      },
      {
        label: 'No one',
      },
    ],
  },
  preferences: {
    title: 'Preferences only apply to this workspace',
    description:
      'To make sure no one can search for you, you’ll need to change this preference across all your workspaces.',
    findMyWorkspace: 'Find my workspace',
  },
  contactSharing: {
    title: 'Contact sharing',
    tagline:
      'Choose who’s allowed to share your contact info — so they can introduce you to people outside Devsinc.',
    settings: [
      {
        label:
          'People outside your company. Includes people from outside your company who can see you in Slack.',
      },
      {
        label: 'No one',
      },
    ],
  },
  invitation: {
    title: 'Invitations you’ve blocked',
    tagline:
      'You’ve stopped receiving Slack Connect invitations from these people.',
    zeroBlocked: 'You haven’t blocked any invitations from anyone yet.',
  },
};
