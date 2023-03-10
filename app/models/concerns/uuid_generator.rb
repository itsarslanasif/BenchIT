module UuidGenerator
  extend ActiveSupport::Concern

  included do
    before_create :set_id
  end

  private

  def set_id
    self.id = case self.class.name
              when 'Workspace'
                generate_id('W0')
              when 'User'
                generate_id('U0')
              when 'Profile'
                generate_id('D0')
              when 'BenchChannel'
                is_private? ? generate_id('CPR0', 8) : generate_id('CPU0', 8)
              when 'Group'
                generate_id('G0')
              else
                generate_id('M0')
              end
  end

  def generate_id(text, number = 12)
    "#{text}#{SecureRandom.alphanumeric(number).upcase}"
  end
end
