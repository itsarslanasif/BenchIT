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
user1.profiles.create!(username: 'Alva', description: 'ASE', workspace_id: 1, display_name: 'alva', phone: '1234567890', skype: '1234567890',
                       text_status: 'Laughing', time_zone: 'Karachi', emoji_status: '😂')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images alva.png]).open,
                                  filename: 'alva.png', content_type: 'image/png')
user2 = User.new(name: 'Arnold', email: 'arnold@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user2.save!
user2.profiles.create!(username: 'Arnold', description: 'ASQE', workspace_id: 1, display_name: 'arnold', phone: '1234567890', skype: '1234567890',
                       text_status: 'Angry', time_zone: 'UTC', emoji_status: '😡')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arnold.png]).open,
                                  filename: 'arnold.png', content_type: 'image/png')
user3 = User.new(name: 'Arthur', email: 'arthur@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user3.save!
user3.profiles.create!(username: 'Arthur', description: 'SE', workspace_id: 1, display_name: 'arthur', phone: '1234567890', skype: '1234567890',
                       text_status: 'Lunch', time_zone: 'Samoa', emoji_status: '🍕')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arthur.png]).open,
                                  filename: 'arthur.png', content_type: 'image/png')
user = User.new(name: 'Austin', email: 'austin@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user.save!
user.profiles.create!(username: 'Austin', description: 'SSE', workspace_id: 1, display_name: 'austin', phone: '1234567890', skype: '1234567890',
                      text_status: 'AFK', time_zone: 'Auckland', emoji_status: '💬')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images austin.png]).open,
                                  filename: 'austin.png', content_type: 'image/png')
admin = User.create!(email: 'admin@domain.com', password: 'password', password_confirmation: 'password', jti: SecureRandom.uuid)
admin.profiles.create!(username: 'admin', description: 'Admin of workspace', workspace_id: 1, display_name: 'admin', phone: '1234567890',
                       skype: '1234567890', text_status: 'Happy', time_zone: 'UTC', emoji_status: '😍')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images admin.png]).open,
                                  filename: 'admin.png', content_type: 'image/png')
Current.user = user1
Current.profile = user1.profiles.first

BenchChannel.create(name: 'dev', description: 'dev')
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 1)
ChannelParticipant.create(permission: true, profile_id: 1, bench_channel_id: 1)
ChannelParticipant.create(permission: true, profile_id: 2, bench_channel_id: 1)
ChannelParticipant.create(permission: true, profile_id: 4, bench_channel_id: 1)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Dev Channel** from _Alva_"}}]}',
                           is_threaded: false, bench_conversation_id: 1, sender_id: 1)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi Dev Channel from Arnold"}}]}',
                           is_threaded: false, bench_conversation_id: 1, sender_id: 2)
Group.create(id: 1, profile_ids: [1, 2])
Group.create(id: 2, profile_ids: [1, 2, 3])
BenchConversation.create(conversationable_type: 'Group', conversationable_id: 1)

ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Alva"}}]}',
                           is_threaded: false, bench_conversation_id: 2, sender_id: 1)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Arnold"}}]}',
                           is_threaded: false, bench_conversation_id: 2, sender_id: 2)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Arthur"}}]}',
                           is_threaded: false, bench_conversation_id: 2, sender_id: 3)
BenchConversation.create(conversationable_type: 'Profile', conversationable_id: 1, sender_id: 4)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from Austin"}}]}',
                           is_threaded: false, bench_conversation_id: 3, sender_id: 4)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from Alva"}}]}',
                           is_threaded: false, bench_conversation_id: 3, sender_id: 1)

BenchChannel.create(name: 'watercooler', description: 'memes')
BenchChannel.create(name: 'Benchit-devs', description: 'developers', is_private: true)
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 2)
ChannelParticipant.create(permission: true, profile_id: 1, bench_channel_id: 2)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from watercooler"}}]}',
                           is_threaded: false, bench_conversation_id: 4, sender_id: 1)

BenchChannel.create(name: 'general', description: 'general')
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 4)
ChannelParticipant.create(permission: true, profile_id: 2, bench_channel_id: 4)
ChannelParticipant.create(permission: true, profile_id: 1, bench_channel_id: 4)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from general"}}]}',
                           is_threaded: false, bench_conversation_id: 5, sender_id: 2)
Favourite.create(profile_id: 1, favourable_type: 'Profile', favourable_id: 4)
Favourite.create(profile_id: 1, favourable_type: 'Group', favourable_id: 1)
Favourite.create(profile_id: 1, favourable_type: 'BenchChannel', favourable_id: 2)
Favourite.create(profile_id: 2, favourable_type: 'BenchChannel', favourable_id: 1)
Favourite.create(profile_id: 2, favourable_type: 'BenchChannel', favourable_id: 2)
Favourite.create(profile_id: 2, favourable_type: 'Group', favourable_id: 2)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"1st reply"}}]}',
                           is_threaded: false, bench_conversation_id: 1, sender_id: 1, parent_message_id: 1)
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 3)
ChannelParticipant.create(permission: true, profile_id: 1, bench_channel_id: 3)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi User from developer"}}]}',
                           is_threaded: false, bench_conversation_id: 6, sender_id: 1)

(1..6).each do |i|
  ScheduleMessage.create!(content: i.to_s, profile_id: 1, scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: i)
  DraftMessage.create!(content: i.to_s, profile_id: 1, bench_conversation_id: i)
end

Workspace.create!(company_name: 'TechHub',
                  workspace_type: :work,
                  bench_it_url: 'https://www.techhub.com',
                  capacity: 2000,
                  organization_type: :financial_services)
user1.profiles.create!(username: 'Alvi', description: 'ASE', workspace_id: 2, display_name: 'alvi', phone: '1234567890', skype: '1234567890',
                       text_status: 'Not working', time_zone: 'Karachi', emoji_status: '🤡')
Current.profile = user1.profiles.second
Current.workspace = Workspace.second
BenchChannel.create(name: 'DevsChannel1', description: 'fdsfsdf')
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 5)
ChannelParticipant.create(permission: true, profile_id: 6, bench_channel_id: 5)
ConversationMessage.create(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi group from Alvi"}}]}',
                           is_threaded: false, bench_conversation_id: 7, sender_id: 6)

Bookmark.create!(name: 'Google', profile_id: 1, bookmarkable_type: 'BenchChannel', bookmarkable_id: 1, bookmark_URL: 'www.google.com')
Bookmark.create!(name: 'Facebook', profile_id: 1, bookmarkable_type: 'Group', bookmarkable_id: 1, bookmark_URL: 'www.facebook.com')

Pin.create!(profile_id: 1, bench_conversation_id: 1, conversation_message_id: 1)
Pin.create!(profile_id: 1, bench_conversation_id: 1, conversation_message_id: 2)
User.create(name: 'Michael', email: 'michael@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
