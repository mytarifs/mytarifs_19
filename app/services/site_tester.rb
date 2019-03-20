#require 'builder'
#require 'nokogiri'
require 'open-uri'

class SiteTester
  include Rails.application.routes.url_helpers, ApplicationHelper::MobileRegionSetting
  attr_accessor :host, :links
  
  def initialize()
    @host = "http://localhost:3000" #"http://mt-site.us.to"
    @links = load_links
  end
  
  def test
    open_page(links[0])
  end
  
  #SiteTester.new.open_all_pages
  def open_all_pages
    error_links = []
    links.each do |link|
      result = open_page(link)
      error_links << link if (result.try(:[], 0).try(:to_i) || 1000) > 399
    end

    second_trial_error_links = []
    error_links.each do |link|
      result = open_page(link)
      second_trial_error_links << link if (result.try(:[], 0).try(:to_i) || 1000) > 399
    end
    second_trial_error_links
  end
  
  def open_page(link)
    start = Time.now
    result = open(link).status 
    duration = Time.now - start
    puts "duration: #{duration}   openned #{link}"
    if result[0].try(:to_i) > 399
      raise(StandardError, result)
    end 
    result   
  rescue => e
    puts ["error while opening #{link}", e]
    result
  end
  
  def load_links
    local_links.map do |local_link|
      host + local_link#.to_s
    end
  end
  
  def local_links
    result = []
 
    Category::Privacies.each do |m_privacy, privacy_desc|
      Category.mobile_regions_with_scope(['ratings']).slice('moskva_i_oblast', 'nizhnii_novgorod_i_oblast').each do |m_region, region_desc|

        result << root_with_region_and_privacy(m_privacy, m_region)

        result << comparison_choose_your_tarif_from_ratings_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << comparison_optimizations_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << comparison_choose_your_tarif_from_ratings_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << customer_calls_choose_your_tarif_with_our_help_path(hash_with_region_and_privacy({}, m_privacy, m_region) )  
        
        Comparison::Optimization.published.limit(1).each do |comparison|
          result << comparison_optimization_path(hash_with_region_and_privacy({:id => comparison.slug}, m_privacy, m_region) )
          comparison.groups.limit(1).each do |group|
            result << result_service_sets_result_path(hash_with_region_and_privacy({:result_run_id => group.result_run.slug}, m_privacy, m_region) )
            Result::ServiceSet.where(:run_id => group.result_run).limit(1).each do |detailed_result|
              result << result_service_sets_detailed_results_path(
                hash_with_region_and_privacy({:result_run_id => group.result_run.slug, :service_set_id => detailed_result.service_set_id}, m_privacy, m_region) )
            end
            result << result_compare_path(hash_with_region_and_privacy({:result_run_id => group.result_run.slug}, m_privacy, m_region) )
            result << comparison_call_stat_path(hash_with_region_and_privacy({:id => comparison.slug}, m_privacy, m_region))
          end
        end
        
        Category::Operator.operators_with_tarifs.limit(2).each do |operator|
          result << comparison_optimizations_by_operator_path(hash_with_region_and_privacy({:operator_id => operator}, m_privacy, m_region))
          Comparison::Optimization.published.limit(2).each do |comparison|
            result << comparison_optimization_by_operator_path(hash_with_region_and_privacy({:id => comparison.slug, :operator_id => operator}, m_privacy, m_region) )
          end
        end
        result << comparison_unlimited_rating_path(hash_with_region_and_privacy({:name => 'reiting_bezlimitnyh_tarifov'}, m_privacy, m_region) )
        result << comparison_unlimited_rating_for_internet_path(hash_with_region_and_privacy({:name => 'reiting_bezlimitnyh_tarifov_i_optsii_dlya_interneta'}, m_privacy, m_region) )
        
        result << comparison_fast_optimizations_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << comparison_fast_optimizations_by_operator_path(hash_with_region_and_privacy({:operator_id => 'tele2'}, m_privacy, m_region) )
        result << comparison_fast_optimizations_for_planshet_path(hash_with_region_and_privacy({:name => 'dlya_plansheta'}, m_privacy, m_region) )
    
        result << result_detailed_calculations_new_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
          
        result << customer_call_runs_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << customer_calls_set_calls_generation_params_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << customer_history_parsers_prepare_for_upload_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << customer_calls_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << result_runs_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << result_service_sets_results_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
      
    
        result << tarif_classes_path
        Category::Operator.operators_with_tarifs.limit(20).each do |operator|
          result << tarif_classes_by_operator_path(hash_with_region_and_privacy({:operator_id => operator}, m_privacy, m_region) )
          TarifClass.where(:operator_id => operator.id).
            where("(features->>'publication_status')::integer = #{Content::Article::PublishStatus[:published]}").limit(2).each do |tarif_class|
            result << tarif_class_by_operator_path(hash_with_region_and_privacy({:id => tarif_class.slug, :operator_id => operator}, m_privacy, m_region) )
          end
        end
      
        TarifClass.where("features is not null").limit(2000).each do |tarif_class|
          result << tarif_class_path(hash_with_region_and_privacy({:id => tarif_class.slug}, m_privacy, m_region) )
        end
        
        result << unlimited_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        TarifClass.unlimited_tarifs.where("tarif_classes.features is not null").limit(2).each do |tarif_class|
          result << unlimited_tarif_class_path(hash_with_region_and_privacy({:id => tarif_class.slug}, m_privacy, m_region) )
        end
      
        result <<  pay_as_go_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result <<  planshet_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result <<  international_rouming_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result <<  country_rouming_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result <<  international_calls_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result <<  country_calls_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result <<  business_tarif_classes_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
      
        result << estimate_cost_tarif_class_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << compare_tarifs_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << compare_tarifs_by_operator_path(hash_with_region_and_privacy({:operator_id => 'tele2'}, m_privacy, m_region) ) 
        result << compare_tarifs_for_planshet_path(hash_with_region_and_privacy({:name => 'dlya_plansheta'}, m_privacy, m_region) )

        result << home_sitemap_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << content_mobile_articles_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << content_questions_and_answers_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        
        result << introduction_after_first_calculations_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << home_detailed_description_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << home_news_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << home_contacts_path(hash_with_region_and_privacy({}, m_privacy, m_region) )
        result << new_customer_demand_path(hash_with_region_and_privacy({}, m_privacy, m_region) )

      end
    end





    
    result
  end

end
