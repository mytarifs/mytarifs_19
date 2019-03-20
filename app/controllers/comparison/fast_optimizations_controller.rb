class Comparison::FastOptimizationsController < ApplicationController
  include Comparison::FastOptimizationsHelper

  add_breadcrumb "Калькулятор тарифов мобильной связи",  
    -> context {context.comparison_fast_optimizations_path(context.hash_with_context_region_and_privacy(context)) }, :except => [:index]

  
  def calculate
    check_calculation_options
#    @test_results = FastOptimization::DataLoader.new(params[:input_key].try(:to_sym), params[:m_privacy_keys], params[:region_txt]).calculate(params[:method]) if params[:method]
    @test_results = FastOptimization::DataLoader.calculate(params.slice(:input_key, :m_privacy_keys, :region_txt_keys, :method, :operators_to_calculate)) if params[:method]
    @test_results = nil if !['test'].include?(params[:method])
    redirect_to comparison_fast_optimizations_calculation_start_path, :alert => @test_results
  end
  
  def index
    add_breadcrumb "Калькулятор тарифов мобильной связи"
  end

  def index_by_operator
    @operator = Category::Operator.where(:slug => params[:operator_id]).first
    add_breadcrumb operator.try(:name)
  end

  def index_for_planshet
    add_breadcrumb "Для планшета"
  end
  
  def check_calculation_options
    params[:m_privacy_keys] = params[:m_privacy_keys] - [''] if !params[:m_privacy_keys].blank?
    params[:region_txt_keys] = params[:region_txt_keys] - [''] if !params[:region_txt_keys].blank?
    params[:operators_to_calculate] = (params[:operators_to_calculate] - ['']).map(&:to_i) if !params[:operators_to_calculate].blank?
  end
end
