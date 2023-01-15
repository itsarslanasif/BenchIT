json.array! @pins do |pin|
  json.partial! 'api/v1/pins/partials/pin', pin: pin
end
