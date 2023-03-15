class Workspace < ApplicationRecord
  include AvatarGeneration

  has_one_attached :workspace_avatar, dependent: :destroy

  has_many :profiles, dependent: :destroy
  has_many :users, through: :profiles, dependent: :destroy
  has_many :statuses
  has_many :bench_channels, dependent: :destroy

  validates :company_name, presence: true
  validates :bench_it_url, uniqueness: true, presence: true
  validates :capacity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5000 }

  # before_create :create_database
  # after_create :establish_connection

  # establish_connection(:techhub)
  after_commit :attach_avatar, on: %i[create]

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

  def attach_avatar
    generate_avatar(company_name, workspace_avatar)
  end

  # def establish_connection
  #   ActiveRecord::Base.establish_connection(
  #     adapter: 'postgresql',
  #     encoding: 'unicode',
  #     pool: ENV.fetch('RAILS_MAX_THREADS', 5),
  #     username: ENV.fetch('POSTGRES_USERNAME', 'postgres'),
  #     password: ENV.fetch('POSTGRES_PASSWORD', 'postgres'),
  #     host: ENV.fetch('POSTGRES_HOST', 'localhost'),
  #     database: company_name.downcase
  #   )
  # end

  def create_database
    ActiveRecord::Base.connection.execute('COMMIT')
    ActiveRecord::Base.connection.execute("CREATE DATABASE #{company_name}")
    ActiveRecord::Base.connection.execute('BEGIN')
  end
end
