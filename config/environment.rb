# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 465,
  domain: 'gmail.com',
  user_name: ENV.fetch('GMAIL_USERNAME', nil),
  password: ENV.fetch('GMAIL_PASSWORD', nil),
  authentication: 'plain',
  ssl: true,
  tsl: true,
  enable_starttls_auto: true
}
