Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
           :scope => 'email', :info_fields => 'email,name'
           
#  provider :vk, ENV['VK_APP_ID'], ENV['VK_APP_SECRET'],
#           :redirect_uri => '/auth/vk/callback', 
#           :display => 'popup',
#           :scope => 'email', 
#           :fields => 'email,name'
#           :v => 5.45,
#           :https => 1, :test_mode => 1

  provider :vkontakte, ENV['VK_APP_ID'], ENV['VK_APP_SECRET'],
#           :redirect_uri => '/auth/vk/callback', 
#           :display => 'popup',
           :scope => 'email', 
           :fields => 'email,name'
#           :v => 5.45,
#           :https => 1, :test_mode => 1
  
  on_failure { |env| Users::AuthenticationsController.action(:failure).call(env) }
end