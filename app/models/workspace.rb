# == Schema Information
#
# Table name: workspaces
#
#  id                :bigint           not null, primary key
#  admin_role        :integer          not null
#  capacity          :integer          not null
#  company_name      :string           not null
#  organization_type :integer          default("consumer_goods"), not null
#  slack_URL         :string           not null
#  workspace_type    :integer          default("work"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Workspace < ApplicationRecord
  has_one_attached :workspace_avatar


  enum workspace_type: {
    work: 0,
    school: 1,
    shared_interest: 2,
    other: 3
  }

  enum organization_type: {
    consumer_goods: 0,
    financial_services: 1,
    government: 2,
    healthCare_pharmacutical: 3,
    media: 4,
    non_profit: 5

  }

  enum admin_role: {
    administrative: 0,
    accounting: 1,
    business_development: 2,
    business_owner: 3,
    customer_support: 4
  }

  validates :company_name, presence: true
  validates :slack_URL , presence: true
  validates :capacity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5000 }


end
