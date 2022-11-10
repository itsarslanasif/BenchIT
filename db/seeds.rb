User.create!(email: "admin@domain.com", password: "password", password_confirmation: "password")
  user1 = User.new(name: 'faisal', email: 'faisal@gmail.com', password: 'Password1!')

  user1.save!
  user2 = User.new(name: 'arshad', email: 'arshad@gmail.com', password: 'Password1!')

  user2.save!
  user3 = User.new(name: 'muaz', email: 'muaz@gmail.com', password: 'Password1!')

  user3.save!
  user = User.new(name: 'Arslan', email: 'arslan@gmail.com', password: 'Password1!')

  user.save!
  BenchChannel.create(name: 'dev', description: 'dev', creator_id: 1)
  BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 1)
  ChannelParticipant.create(permission: true,user_id: 1 , bench_channel_id: 1)
  ChannelParticipant.create(permission: true,user_id: 2 , bench_channel_id: 1)
  ConversationMessage.create(content: 'Hi Dev Channel from faisal', is_threaded: false, bench_conversation_id: 1, sender_id: 1)
  ConversationMessage.create(content: 'Hi Dev Channel from arshad', is_threaded: false, bench_conversation_id: 1, sender_id: 2)
  Group.create(id: 1)
  BenchConversation.create(conversationable_type: 'Group', conversationable_id: 1)
  UserGroup.create(user_id: 1, group_id: 1)
  UserGroup.create(user_id: 2, group_id: 1)
  UserGroup.create(user_id: 3, group_id: 1)
  ConversationMessage.create(content: 'Hi Group from faisal', is_threaded: false, bench_conversation_id: 2, sender_id: 1)
  ConversationMessage.create(content: 'Hi Group from arshad', is_threaded: false, bench_conversation_id: 2, sender_id: 2)
  ConversationMessage.create(content: 'Hi Group from muaz', is_threaded: false, bench_conversation_id: 2, sender_id: 3)
  BenchConversation.create(conversationable_type: 'User', conversationable_id: 1, sender_id: 4)
  ConversationMessage.create(content: 'Hi User from john', is_threaded: false, bench_conversation_id: 3, sender_id: 4)
  ConversationMessage.create(content: 'Hi User from faisal', is_threaded: false, bench_conversation_id: 3, sender_id: 1)
