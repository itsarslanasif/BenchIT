import { star } from '../../api/starunstar/star.js';
import { unstar } from '../../api/starunstar/unstar.js';

export const markStar = (currentChannel, channelStore) => {
  try {
    if (!currentChannel.favourite_id) {
      star({
        favourable_type: 'BenchChannel',
        favourable_id: currentChannel.id,
      }).then(response => {
        if (response.status === 200) {
          channelStore.addStarredChannel(currentChannel);
          channelStore.removeJoinChannel(currentChannel);
          currentChannel.favourite_id = response.data.favourite.id;
        }
      });
    } else {
      unstar(currentChannel.favourite_id).then(response => {
        if (response.status === 200) {
          channelStore.removeStarredChannel(currentChannel);
          channelStore.addJoinChannel(currentChannel);
          currentChannel.favourite_id = null;
        }
      });
    }
  } catch (e) {
    console.error(e);
  }
};
