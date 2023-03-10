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
                is_private? ? generate_id('CPR0', 8) : generate_id('CPU0', 8)
              when 'Group'
                generate_id('G0', 12)
              else
                generate_id('M0', 12)
              end
  end

  def generate_id(text, number)
    "#{text}#{SecureRandom.alphanumeric(number).upcase}"
  end
end
