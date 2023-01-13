import { star } from '../../api/starunstar/star.js'
import { unstar } from '../../api/starunstar/unstar.js';

export const markStar = (currentChannel, channelStore) => {
  try {
    if (!currentChannel.favourite_id) {
      channelStore.addStarredChannel(currentChannel);
      channelStore.removeJoinChannel(currentChannel);
      star({
        favourable_type: 'BenchChannel',
        favourable_id: currentChannel.id,
      }).then(response => {
        currentChannel.favourite_id = response.data.favourite.id;
      });
    }
    else {
      unstar(currentChannel.favourite_id);
      channelStore.removeStarredChannel(currentChannel);
      channelStore.addJoinChannel(currentChannel);
      currentChannel.favourite_id = null;
    }
  } catch (e) {
    console.error(e);
  }
};
