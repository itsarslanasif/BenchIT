module UuidGenerator
  extend ActiveSupport::Concern

  def generate_and_append_uuid(record)
    record.id = case record.class.name
                when 'Workspace'
                  "W#{SecureRandom.alphanumeric(10).upcase}"
                when 'User'
                  "U#{SecureRandom.alphanumeric(10).upcase}"
                when 'Profile'
                  "D#{SecureRandom.alphanumeric(10).upcase}"
                when 'BenchChannel'
                  if record.is_private?
                    "CPR#{SecureRandom.alphanumeric(8).upcase}"
                  else
                    "CPU#{SecureRandom.alphanumeric(8).upcase}"
                  end
                when 'Group'
                  "G#{SecureRandom.alphanumeric(10).upcase}"
                else
                  "M#{SecureRandom.alphanumeric(10).upcase}"
                end
  end
end
