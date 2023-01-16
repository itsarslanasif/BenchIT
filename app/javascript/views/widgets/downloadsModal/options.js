import { CONSTANTS } from '../../../assets/constants';

const generateKey = label => {
  return label.toLowerCase().replace(/ /g, '-');
};

export default [
  {
    label: CONSTANTS.OPEN,
    key: generateKey(CONSTANTS.OPEN),
    children: [
      {
        label: CONSTANTS.OPEN_IN_BROWAER,
        key: generateKey(CONSTANTS.OPEN_IN_BROWAER),
      },
      {
        label: CONSTANTS.OPEN_IN_NEW_WINDOW,
        key: generateKey(CONSTANTS.OPEN_IN_NEW_WINDOW),
      },
    ],
  },
  {
    label: CONSTANTS.VIEW_FILE_DETAILS,
    key: generateKey(CONSTANTS.VIEW_FILE_DETAILS),
  },
  {
    label: CONSTANTS.COPY_LINK_TO_FILE,
    key: generateKey(CONSTANTS.COPY_LINK_TO_FILE),
  },
  {
    label: CONSTANTS.ADD_TO_SAVED_ITEMS,
    key: generateKey(CONSTANTS.ADD_TO_SAVED_ITEMS),
  },
  {
    type: 'divider',
    key: 'divider-1',
  },
  {
    label: CONSTANTS.EDIT_FILE_DETAILS,
    key: generateKey(CONSTANTS.EDIT_FILE_DETAILS),
  },
  {
    type: 'divider',
    key: 'divider-2',
  },
  {
    label: CONSTANTS.DELETE_FILE,
    key: generateKey(CONSTANTS.DELETE_FILE),
  },
];
