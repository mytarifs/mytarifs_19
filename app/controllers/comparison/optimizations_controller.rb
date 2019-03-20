class Comparison::OptimizationsController < ApplicationController
  @new_actions = [:call_stat, :show_by_operator]
  include Crudable
  crudable_actions :all
  include Comparison::OptimizationsHelper, Customer::HistoryParsersBackgroundHelper
  helper Comparison::OptimizationsHelper, Customer::HistoryParsersBackgroundHelper, Comparison::OptimizationPresenter

  before_filter :check_before_friendly_url, only: [:show]

  before_action :check_calculate_ratings_options, only: [:set_calculate_ratings_options, :calculate_ratings]
  before_action :check_current_id_exists, only: [:show]
  before_action :set_back_path, only: [:show]

  after_action :set_run_id, only: [:show]
  
  add_breadcrumb "Рейтинги операторов и тарифов", 
    -> context {context.comparison_optimizations_path(context.hash_with_context_region_and_privacy(context)) }, except: [:index]
      
  def set_calculate_ratings_options
    
  end
  
  def calculate_ratings
  #Calculations order
  #RatingsDataLoader.load_rating_types if changed
  #RatingsDataLoader.load_ratings
  #RatingsDataLoader.load_calls (change true to false if wants reload old calls)
  #RatingsDataLoader.calculate_optimizations (select in arrays rating_keys if you want calculate only some ratings)
  #RatingsDataLoader.check_optimizations
    options = params['calculate_ratings_options_filtr']
    if ['calculate_optimizations', 'check_optimizations'].include?(options['calculate_optimization_method'])
      RatingsDataLoader.calculate_optimizations(options)
    else
      RatingsDataLoader.calculate_optimizations
    end    
    redirect_to comparison_optimizations_path(hash_with_region_and_privacy)
  end
  
  def index
    add_breadcrumb "Рейтинги операторов и тарифов"
  end
  
  def by_operator
    @operator = Category::Operator.friendly.find(params[:operator_id])

    optimization_ids = RatingsDataLoader.ids_from_original_ids([1, 2, 3, 5], m_privacy, m_region)
    @group_result_description = Comparison::OptimizationPresenter.top_results_by_comparison_and_operator(optimization_ids, @operator.id, [m_privacy], [m_region])

    add_breadcrumb "#{@operator.try(:name)}"
  end
  
  def choose_your_tarif_from_ratings
    add_breadcrumb "Свод рейтингов"#, comparison_choose_your_tarif_from_ratings_path
    original_group_ids = [15, 16, 17, 21, 23, 27, 50, 52, 54]    
    group_ids = RatingsDataLoader.group_ids_from_original_ids(original_group_ids, m_privacy, m_region)
#    start = Time.now    
    @group_result_description = Comparison::OptimizationPresenter.best_results_by_group_by_operator(group_ids, [m_privacy], [m_region])
#    duration = Time.now - start
#    puts "duration of @group_result_description calculations: #{duration}"
  end
  
  def unlimited_rating
    optimization_ids = RatingsDataLoader.ids_from_original_ids([2], m_privacy, m_region)
    @group_result_description = Comparison::OptimizationPresenter.best_service_set_results_for_unlimited_tarifs_by_operator_for_comparisons(optimization_ids, [m_privacy], [m_region])
    add_breadcrumb "Рейтинг безлимитных тарифов"
  end
  
  def unlimited_rating_for_internet
    optimization_ids = RatingsDataLoader.ids_from_original_ids([3], m_privacy, m_region)
    @group_result_description = Comparison::OptimizationPresenter.best_service_set_results_for_unlimited_tarifs_by_operator_for_comparisons(optimization_ids, [m_privacy], [m_region])
    add_breadcrumb "Рейтинг безлимитных тарифов и опций для интернета"
  end
  
  def show
    group_ids = comparison_optimization_form.model.groups.map(&:id)
    @group_result_description = Comparison::OptimizationPresenter.best_results_by_group_by_operator(group_ids, [m_privacy], [m_region])

    add_breadcrumb comparison_optimization_form.model.name
  end
  
  def show_by_operator
    @operator = Category::Operator.friendly.find(params[:operator_id])

    group_ids = comparison_optimization_form.model.groups.map(&:id)
    @group_result_description = Comparison::OptimizationPresenter.best_results_by_group_for_one_operator(group_ids, @operator.id, 4, [m_privacy], [m_region])

    add_breadcrumb "#{@operator.try(:name)}", comparison_optimizations_by_operator_path(hash_with_region_and_privacy({:operator_id => params[:operator_id]}))
    add_breadcrumb comparison_optimization_form.model.name
  end
  
  def call_stat
    comparison = Comparison::Optimization.where(:id => session[:current_id]['comparison_optimization_id']).first
    comparison_group_name = Comparison::Group.where(:id => session[:current_id]['comparison_group_id']).first.try(:name)
    add_breadcrumb "#{comparison.try(:name)}, #{comparison_group_name}", comparison_optimization_path(hash_with_region_and_privacy({:id => params[:id]}))
    add_breadcrumb "Статистика звонков"
  end
  
  def check_before_friendly_url
    @rating = Comparison::Optimization.friendly.find(params[:id])
    
    if @rating
      if RatingsDataLoader.original_ids.include?(@rating.id)
        correct_rating_id = RatingsDataLoader.optimization_id(@rating.id, m_privacy, m_region)
      else
        rating_m_privacy, rating_m_region = RatingsDataLoader.privacy_region_from_id(@rating.id)
        if rating_m_privacy and rating_m_region
          if rating_m_privacy != m_privacy or rating_m_region != m_region
            original_rating_id = RatingsDataLoader.original_optimization_id(@rating.id, rating_m_privacy, rating_m_region)
            correct_rating_id = RatingsDataLoader.optimization_id(original_rating_id, m_privacy, m_region)
          end
        else
          correct_rating_id = @rating.id
        end
      end

      if correct_rating_id != @rating.id
        @rating = Comparison::Optimization.where(:id => correct_rating_id).first || @rating
      end
    end
    
    if @rating and request.path != comparison_optimization_path(hash_with_region_and_privacy({:id => @rating.slug, trailing_slash: false}))
      redirect_to comparison_optimization_path(hash_with_region_and_privacy({:id => @rating.slug})), :status => :moved_permanently
    end if params[:id]
  end
  
end
