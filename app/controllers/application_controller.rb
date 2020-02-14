class ApplicationController < ActionController::Base
  include ApplicationHelper::DefaultRenderer, ApplicationHelper::Authorization, ApplicationHelper::DeviseSettings, 
          ApplicationHelper::SetCurrentSession, ApplicationHelper::CustomerUsedServicesCheck, 
          ApplicationHelper::GuestUser, ApplicationHelper::MiniProfiler,
          ApplicationHelper::LocaleSettings, ApplicationHelper::MetaTag,
          ApplicationHelper::UserWorkflow, ApplicationHelper::Seo, ApplicationHelper::PaginationPage, ApplicationHelper::MobileRegionSetting,
          ApplicationHelper::Cpanet, ApplicationHelper::CustomerInfoHelper
          
  helper ApplicationHelper::CustomerInfoHelper

  helper_method :current_user_admin?, :customer_has_free_trials?, :current_or_guest_user, :guest_user?, :user_type, :current_user_id,
                :current_or_guest_user_id, :default_meta_tags, :set_target, :pagination_page_name, :set_pagination_page_canonical

  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::Tableable, SavableInSession::ProgressBarable,
          SavableInSession::Formable, SavableInSession::SessionInitializers
  
  helper_method :session_filtr_params, :session_model_params, :breadcrumb_name, 
    :m_region, :m_region_name, :m_region_id,
    :m_privacy, :m_privacy_id, :m_privacy_name, :root_with_region_and_privacy, :hash_with_region_and_privacy, :hash_with_context_region_and_privacy,
    :region_and_privacy_tag,
    :use_local_m_region_and_m_privacy, :show_local_m_region_and_m_privacy_select_views,
    :cpanet_program_items_to_show_by_places, :show_cpanet_program_item_only_source, :show_cpanet_program_item_with_html, :show_cpanet_adv

  
  before_action :current_or_guest_user
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :allowed_request_origin
  before_action :set_current_session
  before_action :set_locale
  before_action :authenticate_and_authorise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_make_payment_invitation_page_if_no_free_trials_left  
#  before_action :check_rack_mini_profiler

  add_breadcrumb "Главная", 
    -> context {context.root_with_region_and_privacy(context.m_privacy, context.m_region) }#, except: [:index1]

  protected
  
end
