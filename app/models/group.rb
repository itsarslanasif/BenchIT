class Group < ApplicationRecord
  has_one :bench_conversation, as: :conversationable, dependent: :destroy

  validates :members, presence: true, length: { minimum: 2 }
  validates :members, inclusion: { in: Profile.ids }

  private

  def name
    Profile.where(id: members).pluck(:username).join(',')
  end
end
