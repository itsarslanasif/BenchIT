module MutedChannelHelper
  def muted?(channel_id)
    Current.profile.channel_participants.find_by(bench_channel_id: channel_id).muted
  end
end
