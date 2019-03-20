module ApplicationHelper::DeviseSettings

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_up)  << :name #{ |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update)  << :name #{ |u| u.permit(:name, :password, :password_confirmation, :current_password) }
  end  

  def after_sign_in_path_for(resource)
    if session[:work_flow].try(:[], :tarif_optimization).try(:[], :status) == "ready_to_calculate"
      session[:work_flow][:tarif_optimization][:status] = "sent_to_calculate"
      result_detailed_calculations_new_path(hash_with_region_and_privacy)
    else
      root_with_region_and_privacy(m_privacy, m_region)
    end    
  end
    
  private
    
end
