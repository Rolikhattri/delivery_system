class UsersController < ApplicationController
  protect_from_forgery with: :null_session
    require 'httparty'

  def create
    @user = User.new(user_params)
    if @user.save
      notify_third_parties(@user)
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      notify_third_parties(@user)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_no)
  end

  def notify_third_parties(user)
    endpoints = Rails.application.config.third_party_endpoints
    payload = {
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        phone_no: user.phone_no,
        updated_at: user.updated_at
      }
    }
    headers = {
      'Content-Type' => 'application/json',
      'X-Signature' => generate_signature(payload.to_json)
    }
    endpoints.each do |endpoint|
      begin
        HTTParty.post(endpoint, body: payload.to_json, headers: headers,timeout: 10)
      rescue
      end
    end
  end

  def generate_signature(payload)
    secret = ENV["webhook_secret"]
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, payload)
  end
end
