module UuidGenerator
  extend ActiveSupport::Concern

  def generate_and_append_uuid(record)
    record.id = case record.class.name
                when 'Workspace'
                  "W0#{SecureRandom.alphanumeric(12).upcase}"
                when 'User'
                  "U0#{SecureRandom.alphanumeric(12).upcase}"
                when 'Profile'
                  "D0#{SecureRandom.alphanumeric(12).upcase}"
                when 'BenchChannel'
                  if record.is_private?
                    "CPR0#{SecureRandom.alphanumeric(8).upcase}"
                  else
                    "CPU0#{SecureRandom.alphanumeric(8).upcase}"
                  end
                when 'Group'
                  "G0#{SecureRandom.alphanumeric(12).upcase}"
                else
                  "M0#{SecureRandom.alphanumeric(12).upcase}"
                end
  end
end
