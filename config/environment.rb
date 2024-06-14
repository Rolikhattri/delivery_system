# Load the Rails application.
require_relative 'application'
ENV["webhook_secret"] = "webhook"
# Initialize the Rails application.
Rails.application.initialize!

