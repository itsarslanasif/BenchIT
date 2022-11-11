json.public_channels do
  json.partial! 'api/v1/mentions/partials/channel', channels: @public_channels
end

json.private_channels do
  json.partial! 'api/v1/mentions/partials/channel', channels: @private_channels
end
