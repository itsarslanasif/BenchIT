module AvatarGeneration
  extend ActiveSupport::Concern

  def generate_avatar(name, image)
    uri = URI("https://ui-avatars.com/api/?name=#{name[0]}&background=random&id=#{self.id}")
    avatar = Net::HTTP.get(uri)
    image.attach(io: StringIO.new(avatar), filename: "#{name}.png", content_type: "image/png")
  end
end
