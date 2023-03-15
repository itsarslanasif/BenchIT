module UuidGenerator
  extend ActiveSupport::Concern

  included do
    before_create :set_id
  end

  private

  def set_id
    self.id = case self.class.name
              when 'Workspace'
                generate_id('W0', 12)
              when 'User'
                generate_id('U0', 12)
              when 'Profile'
                generate_id('D0', 12)
              when 'BenchChannel'
                generate_id_for_channel
              when 'Group'
                generate_id('G0', 12)
              when 'ChannelParticipant'
                self.id = bench_channel_id + profile_id
              else
                generate_id('M0', 18)
              end
  end

  def generate_id(text, number)
    "#{text}#{SecureRandom.alphanumeric(number).upcase}"
  end

  def generate_id_for_channel
    is_private? ? generate_id('CPR0', 10) : generate_id('CPU0', 10)
  end
end
