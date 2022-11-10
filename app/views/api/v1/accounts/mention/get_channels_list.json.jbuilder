json.public_channels do
  json.partial! 'api/v1/accounts/mention/partials/channel.json.jbuilder', channels: @public_channels
end

json.private_channels do
  json.partial! 'api/v1/accounts/mention/partials/channel.json.jbuilder', channels: @private_channels
end
