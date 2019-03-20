class Result::ServiceSetsController < ApplicationController
  include Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter
  helper Result::ServiceSetsHelper, Result::ServiceSets::ServiceCategoriesPresenter

  before_filter :check_before_friendly_url, only: [:result, :detailed_results]

  before_action :set_service_set_id_for_report, only: [:report]
  before_action :set_back_path, only: [:results, :result]
  before_action :set_initial_breadcrumb_for_service_sets_result, only: [:result, :compare, :detailed_results]
  before_action :set_initial_breadcrumb_for_service_sets_detailed_result, only: [:detailed_results]
  
  def report
    add_breadcrumb "Рекомендация по выбору тарифа"
  end
  
  def compare
    add_breadcrumb "Сравнение тарифов"
  end
  
  def results
    add_breadcrumb "Сохраненные результаты подбора", result_service_sets_results_path(hash_with_region_and_privacy)
    add_breadcrumb result_service_sets_model.first.try(:run).try(:name)
  end
  
  def result
    add_breadcrumb "Результаты подбора"
  end
  
  def detailed_results
    add_breadcrumb results_service_set.try(:full_name)
  end
  
  def set_service_set_id_for_report
    run_id
    session[:current_id]['service_set_id'] = params[:service_set_id] if params[:service_set_id]
  end

  def check_before_friendly_url
    @runn = Result::Run.friendly.find(params[:result_run_id])
    if @runn and request.path != path_from_action(action_name.to_sym, @runn, false)
      redirect_to path_from_action(action_name.to_sym, @runn, true), :status => :moved_permanently
    end if params[:result_run_id]
  end
  
  def path_from_action(action, object, trailing_slash)
    case action
    when :result; result_service_sets_result_path(hash_with_region_and_privacy({:result_run_id => object.slug, trailing_slash: trailing_slash}))
    when :detailed_results; result_service_sets_detailed_results_path(hash_with_region_and_privacy({:result_run_id => object.slug, trailing_slash: trailing_slash}))
    end
  end
  
end
