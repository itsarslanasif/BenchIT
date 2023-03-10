user0 = User.create!(email: 'admin@domain.com', password: 'password', password_confirmation: 'password', jti: SecureRandom.uuid)

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

admin = workspace.profiles.create!(username: 'admin', description: 'Admin of workspace', user_id: user0.id,
                                   display_name: 'Admin', phone: '1234567890', skype: '1234567890', text_status: 'Happy',
                                   time_zone: 'UTC', emoji_status: '😍', role: :workspace_owner)
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images admin.png]).open,
                                  filename: 'admin.png', content_type: 'image/png')

user1 = User.create!(name: 'Alva', email: 'alva@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)

alva = workspace.profiles.create!(username: 'Alva', description: 'ASE', user_id: user1.id, display_name: 'alva',
                                  phone: '1234567890', skype: '1234567890', text_status: 'Laughing', time_zone: 'Karachi',
                                  emoji_status: '😂', role: :workspace_admin)
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images alva.png]).open,
                                  filename: 'alva.png', content_type: 'image/png')

user2 = User.create!(name: 'Arnold', email: 'arnold@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
arnold = workspace.profiles.create!(username: 'Arnold', description: 'ASQE', user_id: user2.id, display_name: 'arnold',
                                    phone: '1234567890', skype: '1234567890', text_status: 'Angry', time_zone: 'UTC', emoji_status: '😡')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arnold.png]).open,
                                  filename: 'arnold.png', content_type: 'image/png')
user3 = User.create!(name: 'Arthur', email: 'arthur@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
arthur = workspace.profiles.create!(username: 'Arthur', description: 'SE', user_id: user3.id, display_name: 'arthur',
                                    phone: '1234567890', skype: '1234567890', text_status: 'Lunch', time_zone: 'Samoa', emoji_status: '🍕')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arthur.png]).open,
                                  filename: 'arthur.png', content_type: 'image/png')
user4 = User.create!(name: 'Austin', email: 'austin@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
austin = workspace.profiles.create!(username: 'Austin', description: 'SSE', user_id: user4.id, display_name: 'austin',
                                    phone: '1234567890', skype: '1234567890', text_status: 'AFK', time_zone: 'Auckland', emoji_status: '💬')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images austin.png]).open,
                                  filename: 'austin.png', content_type: 'image/png')

Current.user = user0
Current.profile = admin

channel1 = BenchChannel.create!(name: 'general', description: 'general')
channel2 = BenchChannel.create!(name: 'dev', description: 'dev')
channel3 = BenchChannel.create!(name: 'devsinc', description: 'IT company', is_private: true)

channel_conversation1 = BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel1.id)
channel_conversation2 = BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel2.id)
channel_conversation3 = BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel3.id)

channel1.channel_participants.create!(permission: true, profile_id: admin.id)
channel1.channel_participants.create!(permission: true, profile_id: alva.id)
channel1.channel_participants.create!(permission: true, profile_id: arnold.id)
channel1.channel_participants.create!(permission: true, profile_id: arthur.id)
channel1.channel_participants.create!(permission: true, profile_id: austin.id)

channel2.channel_participants.create!(permission: true, profile_id: admin.id)

channel3.channel_participants.create!(permission: true, profile_id: admin.id)
channel3.channel_participants.create!(permission: true, profile_id: alva.id)
channel3.channel_participants.create!(permission: true, profile_id: arnold.id)
channel3.channel_participants.create!(permission: true, profile_id: arthur.id)
channel3.channel_participants.create!(permission: true, profile_id: austin.id)

sms1 = admin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **General** from _Admin_"}}]}',
                                           is_threaded: false, bench_conversation_id: channel_conversation1.id)
sms2 = alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **General** from _Alva_"}}]}',
                                          is_threaded: false, bench_conversation_id: channel_conversation1.id)
arnold.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi General from Arnold"}}]}',
                                     is_threaded: false, bench_conversation_id: channel_conversation1.id)
arthur.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi General from Arthur"}}]}',
                                     is_threaded: false, bench_conversation_id: channel_conversation1.id)
austin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi General from Austin"}}]}',
                                     is_threaded: false, bench_conversation_id: channel_conversation1.id)

admin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Dev** from _Admin_"}}]}',
                                    is_threaded: false, bench_conversation_id: channel_conversation2.id)

admin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Devsinc** from _Admin_"}}]}',
                                    is_threaded: false, bench_conversation_id: channel_conversation3.id)

group1 = Group.create!(profile_ids: [alva.id, arnold.id, arthur.id])
group2 = Group.create!(profile_ids: [alva.id, arnold.id, austin.id])
group3 = Group.create!(profile_ids: [alva.id, arthur.id, austin.id])

group_conversation1 = BenchConversation.create!(conversationable_type: 'Group', conversationable_id: group1.id)
group_conversation2 = BenchConversation.create!(conversationable_type: 'Group', conversationable_id: group2.id)
group_conversation3 = BenchConversation.create!(conversationable_type: 'Group', conversationable_id: group3.id)

alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Group#1** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: group_conversation1.id)

alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Group#2** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: group_conversation2.id)

alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Group#3** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: group_conversation3.id)

profile_conversation1 = BenchConversation.create!(conversationable_type: 'Profile', conversationable_id: arthur.id, sender_id: alva.id)

Pin.create!(bench_conversation_id: channel_conversation1.id, conversation_message_id: sms1.id, profile_id: alva.id)
Pin.create!(bench_conversation_id: channel_conversation1.id, conversation_message_id: sms2.id, profile_id: alva.id)

alva.reactions.create!(emoji: '😍', conversation_message_id: sms1.id)
arnold.reactions.create!(emoji: '😍', conversation_message_id: sms1.id)
arthur.reactions.create!(emoji: '😍', conversation_message_id: sms2.id)
austin.reactions.create!(emoji: '😍', conversation_message_id: sms2.id)

alva.saved_items.create!(conversation_message_id: sms1.id)
arnold.saved_items.create!(conversation_message_id: sms1.id)
arthur.saved_items.create!(conversation_message_id: sms1.id)
austin.saved_items.create!(conversation_message_id: sms1.id)

Favourite.create!(profile_id: alva.id, favourable_type: 'BenchChannel', favourable_id: channel1.id)
Favourite.create!(profile_id: arnold.id, favourable_type: 'BenchChannel', favourable_id: channel1.id)
Favourite.create!(profile_id: arthur.id, favourable_type: 'BenchChannel', favourable_id: channel1.id)
Favourite.create!(profile_id: austin.id, favourable_type: 'BenchChannel', favourable_id: channel1.id)

alva.schedule_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message in channel"}}]}),
                               scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: channel_conversation1.id)
alva.schedule_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message in group"}}]}),
                               scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: group_conversation1.id)
alva.schedule_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message in profile"}}]}),
                               scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: profile_conversation1.id)

alva.draft_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Haha message in channel"}}]}),
                            bench_conversation_id: channel_conversation1.id)
alva.draft_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Haha message in group"}}]}),
                            bench_conversation_id: group_conversation1.id)
alva.draft_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Haha message in profile"}}]}),
                            bench_conversation_id: profile_conversation1.id)

workspace = Workspace.create!(company_name: 'TechHub',
                              workspace_type: :work,
                              bench_it_url: 'https://www.techhub.com',
                              capacity: 2000,
                              organization_type: :financial_services)
alvi = user1.profiles.create!(username: 'Alvi', description: 'ASE', workspace_id: workspace.id, display_name: 'alvi',
                              phone: '1234567890', skype: '1234567890', text_status: 'Not working', time_zone: 'Karachi', emoji_status: '🤡', role: 0)
Current.profile = alvi
Current.workspace = workspace

channel1 = BenchChannel.create!(name: 'general', description: 'general')
BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel1.id)
channel1.channel_participants.create!(permission: true, profile_id: alvi.id)
