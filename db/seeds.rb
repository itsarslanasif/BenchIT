password = ENV.fetch('PASSWORD', nil)
user_first = User.create!(email: 'admin@domain.com', password: password, jti: SecureRandom.uuid)

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

admin = workspace.profiles.create!(username: 'admin', description: 'Admin of workspace', user_id: user_first.id,
                                   display_name: 'Admin', phone: '1234567890', skype: '1234567890', text_status: 'Happy',
                                   time_zone: 'UTC', emoji_status: '😍', role: :workspace_owner)
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images admin.png]).open,
                                  filename: 'admin.png', content_type: 'image/png')

user_second = User.create!(name: 'Alva', email: 'alva@gmail.com', password: password, jti: SecureRandom.uuid)

alva = workspace.profiles.create!(username: 'Alva', description: 'ASE', user_id: user_second.id, display_name: 'alva',
                                  phone: '1234567890', skype: '1234567890', text_status: 'Laughing', time_zone: 'Karachi',
                                  emoji_status: '😂', role: :workspace_admin)
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images alva.png]).open,
                                  filename: 'alva.png', content_type: 'image/png')

user_third = User.create!(name: 'Arnold', email: 'arnold@gmail.com', password: password, jti: SecureRandom.uuid)
arnold = workspace.profiles.create!(username: 'Arnold', description: 'ASQE', user_id: user_third.id, display_name: 'arnold',
                                    phone: '1234567890', skype: '1234567890', text_status: 'Angry', time_zone: 'UTC', emoji_status: '😡')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arnold.png]).open,
                                  filename: 'arnold.png', content_type: 'image/png')
user_fourth = User.create!(name: 'Arthur', email: 'arthur@gmail.com', password: password, jti: SecureRandom.uuid)
arthur = workspace.profiles.create!(username: 'Arthur', description: 'SE', user_id: user_fourth.id, display_name: 'arthur',
                                    phone: '1234567890', skype: '1234567890', text_status: 'Lunch', time_zone: 'Samoa', emoji_status: '🍕')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images arthur.png]).open,
                                  filename: 'arthur.png', content_type: 'image/png')
user_fifth = User.create!(name: 'Austin', email: 'austin@gmail.com', password: password, jti: SecureRandom.uuid)
austin = workspace.profiles.create!(username: 'Austin', description: 'SSE', user_id: user_fifth.id, display_name: 'austin',
                                    phone: '1234567890', skype: '1234567890', text_status: 'AFK', time_zone: 'Auckland', emoji_status: '💬')
Profile.last.profile_image.attach(io: Rails.root.join(*%w[app assets images austin.png]).open,
                                  filename: 'austin.png', content_type: 'image/png')

Current.user = user_first
Current.profile = admin

channel_first = BenchChannel.create!(name: 'general', description: 'general')
channel_second = BenchChannel.create!(name: 'dev', description: 'dev')
channel_third = BenchChannel.create!(name: 'devsinc', description: 'IT company', is_private: true)

channel_conversation_first = BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel_first.id, topic: 'general')
channel_conversation_second = BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel_second.id,
                                                        topic: 'developers')
channel_conversation_third = BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel_third.id,
                                                       topic: 'bench-it')

channel_first.channel_participants.create!(permission: true, profile_id: admin.id)
channel_first.channel_participants.create!(permission: true, profile_id: alva.id)
channel_first.channel_participants.create!(permission: true, profile_id: arnold.id)
channel_first.channel_participants.create!(permission: true, profile_id: arthur.id)
channel_first.channel_participants.create!(permission: true, profile_id: austin.id)

channel_second.channel_participants.create!(permission: true, profile_id: admin.id)

channel_third.channel_participants.create!(permission: true, profile_id: admin.id)
channel_third.channel_participants.create!(permission: true, profile_id: alva.id)
channel_third.channel_participants.create!(permission: true, profile_id: arnold.id)
channel_third.channel_participants.create!(permission: true, profile_id: arthur.id)
channel_third.channel_participants.create!(permission: true, profile_id: austin.id)

admin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **General** from _Admin_"}}]}',
                                    is_threaded: false, bench_conversation_id: channel_conversation_first.id)
alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **General** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: channel_conversation_first.id)
arnold.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi General from Arnold"}}]}',
                                     is_threaded: false, bench_conversation_id: channel_conversation_first.id)
arthur.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi General from Arthur"}}]}',
                                     is_threaded: false, bench_conversation_id: channel_conversation_first.id)
austin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi General from Austin"}}]}',
                                     is_threaded: false, bench_conversation_id: channel_conversation_first.id)

admin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Dev** from _Admin_"}}]}',
                                    is_threaded: false, bench_conversation_id: channel_conversation_second.id)

admin.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Devsinc** from _Admin_"}}]}',
                                    is_threaded: false, bench_conversation_id: channel_conversation_third.id)

group_first = Group.create!(profile_ids: [alva.id, arnold.id, arthur.id])
group_second = Group.create!(profile_ids: [alva.id, arnold.id, austin.id])
group_third = Group.create!(profile_ids: [alva.id, arthur.id, austin.id])

group_conversation_first = BenchConversation.create!(conversationable_type: 'Group', conversationable_id: group_first.id, topic: 'group-1')
group_conversation_second = BenchConversation.create!(conversationable_type: 'Group', conversationable_id: group_second.id, topic: 'group-2')
group_conversation_third = BenchConversation.create!(conversationable_type: 'Group', conversationable_id: group_third.id, topic: 'group-3')

alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Group#1** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: group_conversation_first.id)

alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Group#2** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: group_conversation_second.id)

alva.conversation_messages.create!(content: '{"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Hi **Group#3** from _Alva_"}}]}',
                                   is_threaded: false, bench_conversation_id: group_conversation_third.id)

profile_conversation_first = BenchConversation.create!(conversationable_type: 'Profile', conversationable_id: arthur.id, sender_id: alva.id,
                                                       topic: 'arthur-alva')

sms_first = ConversationMessage.first
sms_second = ConversationMessage.second

Pin.create!(bench_conversation_id: channel_conversation_first.id, conversation_message_id: sms_first.id, profile_id: alva.id)
Pin.create!(bench_conversation_id: channel_conversation_first.id, conversation_message_id: sms_second.id, profile_id: alva.id)

alva.reactions.create!(emoji: '😍', conversation_message_id: sms_first.id)
arnold.reactions.create!(emoji: '😍', conversation_message_id: sms_first.id)
arthur.reactions.create!(emoji: '😍', conversation_message_id: sms_second.id)
austin.reactions.create!(emoji: '😍', conversation_message_id: sms_second.id)

alva.saved_items.create!(conversation_message_id: sms_first.id)
arnold.saved_items.create!(conversation_message_id: sms_first.id)
arthur.saved_items.create!(conversation_message_id: sms_first.id)
austin.saved_items.create!(conversation_message_id: sms_first.id)

Favourite.create!(profile_id: alva.id, favourable_type: 'BenchChannel', favourable_id: channel_first.id)
Favourite.create!(profile_id: arnold.id, favourable_type: 'BenchChannel', favourable_id: channel_first.id)
Favourite.create!(profile_id: arthur.id, favourable_type: 'BenchChannel', favourable_id: channel_first.id)
Favourite.create!(profile_id: austin.id, favourable_type: 'BenchChannel', favourable_id: channel_first.id)

alva.schedule_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message in channel"}}]}),
                               scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: channel_conversation_first.id)
alva.schedule_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message in group"}}]}),
                               scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: group_conversation_first.id)
alva.schedule_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"I am schedule message in profile"}}]}),
                               scheduled_at: Time.zone.now.tomorrow, bench_conversation_id: profile_conversation_first.id)

alva.draft_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Haha message in channel"}}]}),
                            bench_conversation_id: channel_conversation_first.id)
alva.draft_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Haha message in group"}}]}),
                            bench_conversation_id: group_conversation_first.id)
alva.draft_messages.create!(content: %({"blocks":[{"type":"section","text":{"type":"mrkdwn","text":"Haha message in profile"}}]}),
                            bench_conversation_id: profile_conversation_first.id)

workspace = Workspace.create!(company_name: 'TechHub',
                              workspace_type: :work,
                              bench_it_url: 'https://www.techhub.com',
                              capacity: 2000,
                              organization_type: :financial_services)
alvi = user_second.profiles.create!(username: 'Alvi', description: 'ASE', workspace_id: workspace.id, display_name: 'alvi', phone: '1234567890',
                                    skype: '1234567890', text_status: 'Not working', time_zone: 'Karachi', emoji_status: '🤡', role: 0)
Current.profile = alvi
Current.workspace = workspace

channel_first = BenchChannel.create!(name: 'general', description: 'general')
BenchConversation.create!(conversationable_type: 'BenchChannel', conversationable_id: channel_first.id, topic: 'general')
channel_first.channel_participants.create!(permission: true, profile_id: alvi.id)
