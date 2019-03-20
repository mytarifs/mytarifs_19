class Users::AuthenticationsController < ApplicationController #DeviseController #Devise::OmniauthCallbacksController #
  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/auth/facebook/?auth_type=rerequest&scope=email&info_fields=email,name"
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
  
      sign_in(:user, @user)#_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      redirect_to root_with_region_and_privacy(m_privacy, m_region)
    end       
  end
  
#  def vk
#    if request.env["omniauth.auth"].info.email.blank?
#      redirect_to "/auth/vk?auth_type=rerequest&scope=email"
#    else
#      @user = User.from_omniauth(request.env["omniauth.auth"])
#  
#      sign_in(:user, @user)#_and_redirect @user, :event => :authentication #this will throw if @user is not activated
#      set_flash_message(:notice, :success, :kind => "VK") if is_navigational_format?
#      redirect_to root_with_region_and_privacy(m_privacy, m_region)
#    end       
#  end
  
  def vkontakte
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/auth/vkontakte/?auth_type=rerequest&scope=email"
    else
      @user = User.from_omniauth(request.env["omniauth.auth"])
  
      sign_in(:user, @user)#_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "VK") if is_navigational_format?
      redirect_to root_with_region_and_privacy(m_privacy, m_region)
    end       
  end
  
  def failure
    set_flash_message :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)    
  end

  protected

  def failed_strategy
    request.respond_to?(:get_header) ? request.get_header("omniauth.error.strategy") : env["omniauth.error.strategy"]
  end

  def failure_message
    exception = request.respond_to?(:get_header) ? request.get_header("omniauth.error") : env["omniauth.error"]
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error        if exception.respond_to?(:error)
    error ||= (request.respond_to?(:get_header) ? request.get_header("omniauth.error.type") : env["omniauth.error.type"]).to_s
    error.to_s.humanize if error
  end

  def after_omniauth_failure_path_for(scope)
    new_session_path(scope)
  end

  def translation_scope
    'devise.omniauth_callbacks'
  end


  def set_flash_message(key, kind, options = {})
    message = find_message(kind, options)
    if options[:now]
      flash.now[key] = message if message.present?
    else
      flash[key] = message if message.present?
    end
  end

  def find_message(kind, options = {})
    options[:scope] ||= translation_scope
    options[:default] = Array(options[:default]).unshift(kind.to_sym)
    options[:resource_name] = resource_name
    options = devise_i18n_options(options)
    I18n.t("#{options[:resource_name]}.#{kind}", options)
  end

  def devise_i18n_options(options)
    options
  end

  def resource_name
    :user
  end

end
