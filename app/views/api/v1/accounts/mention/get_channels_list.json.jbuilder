json.array! @private_channels do |private_channel|
  json.id = private_channel.id
  json.name = private_channel.name
end

json.array! @public_channels do |public_channel|
  json.id = public_channel.id
  json.name = public_channel.name
end
