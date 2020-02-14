class HomeController < ApplicationController
  include HomeHelper, Comparison::OptimizationsHelper
  helper Comparison::OptimizationsHelper, Comparison::OptimizationPresenter, Comparison::FastOptimizationsHelper
#  layout 'landing', only: :index
#  after_action :track_demo_results, only: :demo_results
#  after_action :track_index, only: :index

  def index
    original_group_ids = [17]    
    group_ids = RatingsDataLoader.group_ids_from_original_ids(original_group_ids, m_privacy, m_region)
    @group_result_description = Comparison::OptimizationPresenter.best_results_by_group_by_operator(group_ids, [m_privacy], [m_region])    
  end
  
  def set_mobile_region
    if params['mobile_region']
      session['mobile_region'] = params['mobile_region']['key']
      redirect_to root_with_region_and_privacy(m_privacy, m_region), notice: "Вы выбрали #{Category::MobileRegions[params['mobile_region']['key']].try(:[], 'name')} регионом для просмотра тарифов"
    else
      redirect_to :back, notice: "Вы не выбрали регион регистрации тарифа."
    end
  end
  
  def send_service_introduction
    ServiceInformationMailer.service_introduction.deliver_now
    redirect_to root_with_region_and_privacy(m_privacy, m_region)
  end
  
  def tarif_description
#    price_standard_formulas.formula AS standard_formula_params,  \
    s="SELECT tarif_classes.id AS tarif_id,  tarif_classes.name AS tarif_name,  tarif_classes.dependency->>'is_archived' as is_archived, categories.name AS operator_name,  cat_1.name AS service_type,  onetime.name AS onetime_fee,  periodic.name AS periodic_fee, price_formulas.calculation_order,  price_formulas.formula->>'window_over' AS price_period,  price_formulas.formula->>'params' AS price_params,  price_standard_formulas.name AS formula_name,  \
    service_category_tarif_classes.conditions AS service_category FROM  tarif_classes,  service_category_groups,  price_lists,  price_formulas,  price_standard_formulas,  categories,  categories cat_1,  service_category_tarif_classes  left join service_categories onetime on onetime.id = service_category_tarif_classes.service_category_one_time_id  left join service_categories periodic on periodic.id = service_category_tarif_classes.service_category_periodic_id WHERE  tarif_classes.id = service_category_groups.tarif_class_id AND  tarif_classes.operator_id = categories.id AND  tarif_classes.standard_service_id = 40 and  tarif_classes.standard_service_id = cat_1.id AND  service_category_groups.id = service_category_tarif_classes.as_standard_category_group_id AND  service_category_groups.id = price_lists.service_category_group_id AND  price_lists.id = price_formulas.price_list_id AND  price_standard_formulas.id = price_formulas.standard_formula_id order by  categories.name,  cat_1.name,  tarif_classes.name,  onetime.id,  periodic.id,  price_formulas.calculation_order"
    ttt= [100, 101, 103, 104, 105, 106, 107, 109, 113, 114, 200, 201, 202, 203, 204, 205, 207, 208, 212, 213, 214, 215, 800, 801, 802, 805, 806, 807, 
      622, 623, 624, 628, 629, 630, 631, 632, 633, 634, 635, 636]
    t={};Customer::Call.find_by_sql(s).each{|hh| next if !ttt.include?(hh.tarif_id); t[hh.tarif_id.to_s] ||= []; t[hh.tarif_id.to_s] << hh.attributes.merge({"price_params"=> eval(hh.price_params)}) }; t.deep_stringify_keys!    
    render json: t.to_json
  end
  
  def check_phone
    save_user_phone_from_params(params[:id])
    redirect_to home_welcome_path(0)
  end
  
  def welcome
    add_breadcrumb "Вводная страница для новых посетителей"#, home_welcome_path(params[:id])
  end
  
  def detailed_description
    add_breadcrumb "Подробное описание шагов по подбору тарифа"#, home_detailed_description_path
  end
  
  def news
    add_breadcrumb "Новости"#, home_news_path
  end
  
  def contacts
    add_breadcrumb "Контакты"#, home_contacts_path
  end
  
  def sitemap
    add_breadcrumb "Карта сайта"#, home_sitemap_path
  end
  
  def update_tabs
    render :nothing => true
  end
  
  def change_locale
    redirect_to root_with_region_and_privacy(m_privacy, m_region), notice: t(:change_locale)
  end

  def resource_name
    :user
  end
  helper_method :resource_name

  def resource
    @resource ||= User.new
  end
  helper_method :resource

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :devise_mapping
  
  def resource_class
    User
  end
  helper_method :resource_class
  
  def devise_error_messages!
    []
  end
  helper_method :devise_error_messages!
  
  private
  
end
