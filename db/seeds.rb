workspace = Workspace.create!(company_name: 'BenchIT',
                              workspace_type: :work,
                              bench_it_url: 'https://www.benchit.com',
                              capacity: 2000,
                              organization_type: :financial_services)

user1 = User.new(name: 'Alva', email: 'alva@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user1.save!
user1.profiles.create!(username: 'Alva', description: 'ASE', workspace_id: workspace.id)
user2 = User.new(name: 'Arnold', email: 'arnold@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user2.save!
user2.profiles.create!(username: 'Arnold', description: 'ASQE', workspace_id: workspace.id)
user3 = User.new(name: 'Arthur', email: 'arthur@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user3.save!
user3.profiles.create!(username: 'Arthur', description: 'SE', workspace_id: workspace.id)
user = User.new(name: 'Austin', email: 'austin@gmail.com', password: 'Password1!', jti: SecureRandom.uuid)
user.save!
user.profiles.create!(username: 'Austin', description: 'SSE', workspace_id: workspace.id)
admin = User.create!(email: 'admin@domain.com', password: 'password', password_confirmation: 'password', jti: SecureRandom.uuid)
admin.profiles.create!(username: 'admin', description: 'Admin of workspace', workspace_id: workspace.id)
Current.user = admin
Current.workspace = workspace
BenchChannel.create(name: 'dev', description: 'dev', creator_id: 1, workspace_id: workspace.id)
BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 1)
ChannelParticipant.create(permission: true, user_id: 1, bench_channel_id: 1)
ChannelParticipant.create(permission: true, user_id: 2, bench_channel_id: 1)
ChannelParticipant.create(permission: true, user_id: 4, bench_channel_id: 1)
ConversationMessage.create(content: 'Hi Dev Channel from Alva', is_threaded: false, bench_conversation_id: 1, sender_id: 1)
ConversationMessage.create(content: 'Hi Dev Channel from Arnold', is_threaded: false, bench_conversation_id: 1, sender_id: 2)
Group.create(id: 1)
BenchConversation.create(conversationable_type: 'Group', conversationable_id: 1)
UserGroup.create(user_id: 1, group_id: 1)
UserGroup.create(user_id: 2, group_id: 1)
UserGroup.create(user_id: 3, group_id: 1)
ConversationMessage.create(content: 'Hi Group from Alva', is_threaded: false, bench_conversation_id: 2, sender_id: 1)
ConversationMessage.create(content: 'Hi Group from Arnold', is_threaded: false, bench_conversation_id: 2, sender_id: 2)
ConversationMessage.create(content: 'Hi Group from Arthur', is_threaded: false, bench_conversation_id: 2, sender_id: 3)
BenchConversation.create(conversationable_type: 'User', conversationable_id: 1, sender_id: 4)
ConversationMessage.create(content: 'Hi User from Austin', is_threaded: false, bench_conversation_id: 3, sender_id: 4)
ConversationMessage.create(content: 'Hi User from Alva', is_threaded: false, bench_conversation_id: 3, sender_id: 1)
