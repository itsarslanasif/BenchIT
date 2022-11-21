class Token
  def generate
    Digest::SHA1.hexdigest([Time.zone.now, rand].join)
  end
end
