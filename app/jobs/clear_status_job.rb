class ClearStatusJob < ApplicationJob
  queue_as :default

  def perform(status_id)
    status = Status.find(status_id)
    status.destroy
  end
end
