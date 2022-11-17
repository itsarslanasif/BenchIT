
  user1 = User.new(name: 'Alva', email: 'alva@gmail.com', password: 'Password1!')

  user1.save!
  user2 = User.new(name: 'Arnold', email: 'arnold@gmail.com', password: 'Password1!')

  user2.save!
  user3 = User.new(name: 'Arthur', email: 'arthur@gmail.com', password: 'Password1!')

  user3.save!
  user = User.new(name: 'Austin', email: 'austin@gmail.com', password: 'Password1!')

  user.save!
  BenchChannel.create(name: 'dev', description: 'dev', creator_id: 1)
  BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 1)
  ChannelParticipant.create(permission: true,user_id: 1 , bench_channel_id: 1)
  ChannelParticipant.create(permission: true,user_id: 2 , bench_channel_id: 1)
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
  BenchChannel.create(name: 'dev-2', description: 'dev-2', creator_id: 1)
  BenchConversation.create(conversationable_type: 'BenchChannel', conversationable_id: 2)
  ChannelParticipant.create(permission: true,user_id: 1 , bench_channel_id: 2)
  ChannelParticipant.create(permission: true,user_id: 2 , bench_channel_id: 3)
  ConversationMessage.create(content: 'Hi Dev-2 Channel from Alva', is_threaded: false, bench_conversation_id: 4, sender_id: 1)
  ConversationMessage.create(content: 'Hi Dev-2 Channel from Arthor', is_threaded: false, bench_conversation_id: 4, sender_id: 3)
  BenchConversation.create(conversationable_type: 'User', conversationable_id: 2, sender_id: 1)
  ConversationMessage.create(content: 'Hi User from Alva', is_threaded: false, bench_conversation_id: 5, sender_id: 1)
  ConversationMessage.create(content: 'Hi User from Arnold', is_threaded: false, bench_conversation_id: 5, sender_id: 2)
