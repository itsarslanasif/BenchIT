export const channel = (chat_id, channelStore) => {
  let selectedChannel =
    channelStore.joinedChannels.find(
      channel => channel.id === chat_id
    ) ||
    channelStore.starChannels.find(channel => channel.id === chat_id);
  return selectedChannel;
};
