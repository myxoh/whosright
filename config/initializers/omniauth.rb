OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['OMNIAUTH_FACEBOOK_API'], ENV['OMNIAUTH_FACEBOOK_SECRET'], info_fields: 'email, name, first_name, last_name'
end