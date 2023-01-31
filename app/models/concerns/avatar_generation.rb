module AvatarGeneration
  extend ActiveSupport::Concern

  def generate_avatar(name, image)
    params = {
      name: name,
      background: 'random',
      length: 1,
      bold: true,
      id: id,
      color: 'ffffff',
      'font-size': 0.6
    }
    url = "#{ENV['UI_AVATAR_URL']}/?#{params.to_query}"
    uri = URI(url)
    avatar = Net::HTTP.get(uri)
    image.attach(io: StringIO.new(avatar), filename: "#{name}.png", content_type: 'image/png')
  end
end
