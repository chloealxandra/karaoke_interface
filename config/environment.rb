# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => 465,
  :authentication => :plain,
  :domain => 'gmail.com', 
  :user_name => 'nowthatiskaraoke@gmail.com', 
  :password => Rails.application.secrets[:smtp_password],
  :ssl => true,
  :openssl_verify_mode  => 'none' #Use this because ssl is activated but we have no certificate installed. So clients need to confirm to use the untrusted url.
}
