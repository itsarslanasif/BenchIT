class Status < ApplicationRecord
  enum type: { ProfileStatus: 0, RecentStatus: 1, WorkspaceStatus: 2 }
end
