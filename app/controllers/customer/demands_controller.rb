class Customer::DemandsController < ApplicationController

  before_action :check_if_user_spaming_site, only: [:new, :create, :application_for_tele2_nmp, :apply_for_tele2_nmp]
  before_action :build_demand, only: [:new, :create, :application_for_tele2_nmp, :apply_for_tele2_nmp]
  after_action :track_new, only: :new
  after_action :track_create, only: :create
  
  add_breadcrumb "Написать письмо администрации сайта", nil, only: ['new']
  add_breadcrumb "Подать заявку на переход в Теле2", nil, only: ['application_for_tele2_nmp']

  def apply_for_tele2_nmp    
    if @demand.save        
      UserMailer.send_mail_to_admin_about_new_customer_demand(@demand).deliver
      redirect_to root_with_region_and_privacy(m_privacy, m_region), {:alert => "Спасибо за заявку. Наши представители свяжутся с вами в ближайшее время"}
    else
      render 'application_for_tele2_nmp'
    end
  end
  
  def create    
    if @demand.save        
      UserMailer.send_mail_to_admin_about_new_customer_demand(@demand).deliver
      redirect_to root_with_region_and_privacy(m_privacy, m_region), {:alert => "Спасибо за обращение. Мы рассмотрим его и в случае необходимости сообщим вам о результатах"}
    else
      render 'new'
    end
  end
  
  private
  
    def build_demand      
      if params[:customer_demand]
        @demand = Customer::Demand.new({:customer_id => current_or_guest_user_id, :status_id => demand_is_received_from_customer}.merge(params[:customer_demand].permit!))
      else
        @demand = Customer::Demand.new()
      end
      
    end
    
    def check_if_user_spaming_site
      max_unprocessed_customer_demands = 3
      user_demand_count = Customer::Demand.where({:customer_id => current_or_guest_user_id, :status_id => demand_is_received_from_customer}).
        where("created_at >= :start_date", :start_date => (Time.now - 1.hour)).count
      if user_demand_count >= max_unprocessed_customer_demands
        redirect_to root_with_region_and_privacy(m_privacy, m_region), {:alert => "Вы слишком часто пишите нам сообщения. Наберитесь терпения - мы рассмотрим ваше обращение"}
      end
    end
    
    def demand_is_received_from_customer
      350
    end

  
end
