class WebhooksController < ApplicationController
  protect_from_forgery with: :null_session  # Skip CSRF protection for this controller
  skip_before_action :verify_authenticity_token, only: [:receive]


  def receive
    payload = request.body.read
    Rails.logger.info("Received webhook payload: #{payload}")
    head :ok
  end

end