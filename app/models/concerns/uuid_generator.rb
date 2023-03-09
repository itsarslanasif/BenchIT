module UuidGenerator
  extend ActiveSupport::Concern

  def generate_and_append_uuid(record)
    record.id = case record.class.name
                when 'Workspace'
                  "W#{SecureRandom.alphanumeric(12).upcase}"
                when 'User'
                  "U#{SecureRandom.alphanumeric(12).upcase}"
                when 'Profile'
                  "D#{SecureRandom.alphanumeric(12).upcase}"
                when 'BenchChannel'
                  if record.is_private?
                    "CPR#{SecureRandom.alphanumeric(10).upcase}"
                  else
                    "CPU#{SecureRandom.alphanumeric(10).upcase}"
                  end
                when 'Group'
                  "G#{SecureRandom.alphanumeric(12).upcase}"
                else
                  "M#{SecureRandom.alphanumeric(12).upcase}"
                end
  end
end
