workspace = Workspace.create!(company_name: 'BenchIT',
                              workspace_type: :work,
                              bench_it_url: 'https://www.benchit.com',
                              capacity: 2000,
                              organization_type: :financial_services)
Current.workspace = workspace
workspace.statuses.create!(text: 'In a meeting', emoji: '🗓️', clear_after: '3600')
workspace.statuses.create!(text: 'Commuting', emoji: '🚌', clear_after: '1740')
workspace.statuses.create!(text: 'Out sick', emoji: '🤒', clear_after: 'Today')
workspace.statuses.create!(text: 'Vacationing', emoji: '🌴', clear_after: "don't clear")
workspace.statuses.create!(text: 'Working remotely', emoji: '🏡', clear_after: 'Today')

user1 = User.new(name: 'Alva', email: 'alva@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user1.save!

workspace.profiles.create!(username: 'Alva', description: 'ASE', user_id: user1.id, display_name: 'alva', phone: '1234567890', skype: '1234567890',
                           text_status: 'Laughing', time_zone: 'Karachi', emoji_status: '😂')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images alva.png]).open,
                                  filename: 'alva.png', content_type: 'image/png')
user2 = User.new(name: 'Arnold', email: 'arnold@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user2.save!
workspace.profiles.create!(username: 'Arnold', description: 'ASQE', user_id: user2.id, display_name: 'arnold', phone: '1234567890', skype: '1234567890',
                           text_status: 'Angry', time_zone: 'UTC', emoji_status: '😡')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arnold.png]).open,
                                  filename: 'arnold.png', content_type: 'image/png')
user3 = User.new(name: 'Arthur', email: 'arthur@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user3.save!
workspace.profiles.create!(username: 'Arthur', description: 'SE', user_id: user3.id, display_name: 'arthur', phone: '1234567890', skype: '1234567890',
                           text_status: 'Lunch', time_zone: 'Samoa', emoji_status: '🍕')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arthur.png]).open,
                                  filename: 'arthur.png', content_type: 'image/png')
user = User.new(name: 'Austin', email: 'austin@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user.save!
workspace.profiles.create!(username: 'Austin', description: 'SSE', user_id: user.id, display_name: 'austin', phone: '1234567890', skype: '1234567890',
                           text_status: 'AFK', time_zone: 'Auckland', emoji_status: '💬')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images austin.png]).open,
                                  filename: 'austin.png', content_type: 'image/png')
admin = User.create!(email: 'admin@domain.com', password: 'password', password_confirmation: 'password', jti: SecureRandom.uuid)
workspace.profiles.create!(username: 'admin', description: 'Admin of workspace', user_id: admin.id, display_name: 'admin', phone: '1234567890',
                           skype: '1234567890', text_status: 'Happy', time_zone: 'UTC', emoji_status: '😍')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images admin.png]).open,
                                  filename: 'admin.png', content_type: 'image/png')
Current.user = user1
Current.profile = user1.profiles.first

bench_channel = BenchChannel.create!(name: 'dev', description: 'dev')

BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: bench_channel.id)
ChannelParticipant.create!(permission: true, profile_id: Profile.first.id, bench_channel_id: bench_channel.id)
ChannelParticipant.create!(permission: true, profile_id: Profile.second.id, bench_channel_id: bench_channel.id)
ChannelParticipant.create!(permission: true, profile_id: Profile.fourth.id, bench_channel_id: bench_channel.id)

ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Dev Channel** from _Alva_"}}]}',
                            is_threaded: false, bench_conversation_id: 1, sender_id: Profile.first.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi Dev Channel from Arnold"}}]}',
                            is_threaded: false, bench_conversation_id: 1, sender_id: Profile.second.id)
Group.create!(profile_ids: [Profile.first.id, Profile.second.id])
Group.create!(profile_ids: [Profile.first.id, Profile.second.id, Profile.third.id])
BenchConversation.create!(conversationable_type: 'Group', conversationable_id: Group.first.id)

ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Alva"}}]}',
                            is_threaded: false, bench_conversation_id: 2, sender_id: Profile.first.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Arnold"}}]}',
                            is_threaded: false, bench_conversation_id: 2, sender_id: Profile.second.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Arthur"}}]}',
                            is_threaded: false, bench_conversation_id: 2, sender_id: Profile.third.id)
BenchConversation.create!(conversationable_type: 'Profile', conversationable_id: Profile.first.id, sender_id: Profile.fourth.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from Austin"}}]}',
                            is_threaded: false, bench_conversation_id: 3, sender_id: Profile.fourth.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from Alva"}}]}',
                            is_threaded: false, bench_conversation_id: 3, sender_id: Profile.first.id)

bench_channel1 = BenchChannel.create!(name: 'watercooler', description: 'memes')
BenchChannel.create!(name: 'Benchit-devs', description: 'developers', is_private: true)
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: bench_channel1.id)
ChannelParticipant.create(permission: true, profile_id: Profile.first.id, bench_channel_id: bench_channel1.id)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from watercooler"}}]}',
                           is_threaded: false, bench_conversation_id: 4, sender_id: Profile.first.id)

bench_channel4 = BenchChannel.create!(name: 'general', description: 'general')
BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: bench_channel4.id)
ChannelParticipant.create!(permission: true, profile_id: Profile.first.id, bench_channel_id: bench_channel4.id)
ChannelParticipant.create!(permission: true, profile_id: Profile.second.id, bench_channel_id: bench_channel4.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from general"}}]}',
                            is_threaded: false, bench_conversation_id: 5, sender_id: Profile.second.id)
Favourite.create!(profile_id: Profile.first.id, favourable_type: 'Profile', favourable_id: Profile.fourth.id)
# Favourite.create!(profile_id: Profile.first.id, favourable_type: 'Group', favourable_id: Group.first.id)
Favourite.create!(profile_id: Profile.first.id, favourable_type: 'BenchChannel', favourable_id: BenchChannel.second.id)
Favourite.create!(profile_id: Profile.second.id, favourable_type: 'BenchChannel', favourable_id: BenchChannel.first.id)
Favourite.create!(profile_id: Profile.second.id, favourable_type: 'BenchChannel', favourable_id: BenchChannel.second.id)
# Favourite.create!(profile_id: Profile.second.id, favourable_type: 'Group', favourable_id: Group.second.id)
ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"1st reply"}}]}',
                            is_threaded: false, bench_conversation_id: 1, sender_id: Profile.first.id, parent_message_id: 1)
# BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: BenchChannel.third.id)
# ChannelParticipant.create!(permission: true, profile_id: Profile.first.id, bench_channel_id: BenchChannel.third.id)
# ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from developer"}}]}',
#                             is_threaded: false, bench_conversation_id: 6, sender_id: Profile.first.id)

# (1..5).each do |i|
#   ScheduleMessage.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message #{i}"}}]}),
#                           profile_id: Profile.first.id, scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: i)
#   DraftMessage.create!(content: i.to_s, profile_id: Profile.first.id, bench_conversation_id: i)
# end

w = Workspace.create!(company_name: 'TechHub',
                      workspace_type: :work,
                      bench_it_url: 'https://www.techhub.com',
                      capacity: 2000,
                      organization_type: :financial_services)
user1.profiles.create!(username: 'Alvi', description: 'ASE', workspace_id: w.id, display_name: 'alvi', phone: '1234567890', skype: '1234567890',
                       text_status: 'Not working', time_zone: 'Karachi', emoji_status: '🤡')
Current.profile = user1.profiles.second
Current.workspace = Workspace.second
b = BenchChannel.create!(name: 'DevsChannel1', description: 'fdsfsdf')
BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: b.id)
# ChannelParticipant.create!(permission: true, profile_id: Profile., bench_channel_id: b.id)
# ConversationMessage.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Alvi"}}]}',
#                             is_threaded: false, bench_conversation_id: 7, sender_id: Profile.sixth)

# Bookmark.create!(name: 'Google', profile_id: 1, bookmarkable_type: 'BenchChannel', bookmarkable_id: 1, bookmark_URL: 'www.google.com')
# Bookmark.create!(name: 'Facebook', profile_id: 1, bookmarkable_type: 'Group', bookmarkable_id: 1, bookmark_URL: 'www.facebook.com')

Pin.create!(profile_id: Profile.first.id, bench_conversation_id: 1, conversation_message_id: 1)
Pin.create!(profile_id: Profile.first.id, bench_conversation_id: 1, conversation_message_id: 2)
User.create!(name: 'Michael', email: 'michael@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
BenchConversation.create!(conversationable_type: 'Group', conversationable_id: Group.second.id)
