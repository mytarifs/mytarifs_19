module Comparison::OptimizationPresenter
#  extend Service::CategoryGroupPresenter
  
  def show_as_popover(title, content)
    html = {
      :tabindex => "0", 
      :role => "button", 
      :'data-toggle' => "popover1", 
      :'data-trigger' => "focus", 
      :'data-placement' => "top",
      :title => "Потребление мобильной связи", 
      :'data-content' => content,
      :'data-html' => true,
      :class => "btn-primary"
    }
    
    content_tag(:div, html) do
      simple_format("#{title} \n (#{content})", {:style => "font-size: 15px;"}) # + content_tag(:span, " ") + content_tag(:span, "", {:class => "fa fa-info-circle fa-1x", :'aria-hidden' =>false})
    end
  end
  
  def self.best_results_by_group_for_one_operator(group_ids, operator_id, max_results = 4, privacy_keys = [], region_txts = [])
    result = {}
    privacy_keys_to_use = privacy_keys.blank? ? RatingsData::RatingPrivacyRegionData.keys : privacy_keys
    privacy_keys_to_use.each do |privacy_key|
      rating_by_privacy = RatingsData::RatingPrivacyRegionData

      result[privacy_key] ||= {}
      region_txts_to_use = region_txts.blank? ? rating_by_privacy.keys : region_txts
      region_txts_to_use.each do |region_txt|
        rating_by_region = rating_by_privacy[region_txt]
        result[privacy_key][region_txt] ||= {}
          
        tarif_ids = TarifClass.where(:operator_id => operator_id).privacy_and_region_where(privacy_key, region_txt).pluck(:id)
        best_result_by_groups = best_results_by_groups_and_tarifs(group_ids, tarif_ids, max_results, false, privacy_key, region_txt)
        best_result_by_groups.each do |group_id, best_result_by_group|
          result[privacy_key][region_txt][group_id] ||= []
          result[privacy_key][region_txt][group_id] << best_result_by_group
        end
      end
    end
    result
  end
  
  def self.best_results_by_group_by_operator(group_ids, privacy_keys = [], region_txts = [])
    result = {}
    privacy_keys_to_use = privacy_keys.blank? ? RatingsData::RatingPrivacyRegionData.keys : privacy_keys
    privacy_keys_to_use.each do |privacy_key|
      rating_by_privacy = RatingsData::RatingPrivacyRegionData
      
      result[privacy_key] ||= {}

      region_txts_to_use = region_txts.blank? ? rating_by_privacy.keys : region_txts
      region_txts_to_use.each do |region_txt|
        rating_by_region = rating_by_privacy[region_txt]
        
        result[privacy_key][region_txt] ||= {}
        RatingsData::RatingOperators.each do |operator_id|
          
          tarif_ids = TarifClass.where(:operator_id => operator_id).privacy_and_region_where(privacy_key, region_txt).pluck(:id)
          best_result_by_groups = best_results_by_groups_and_tarifs(group_ids, tarif_ids, 1, false, privacy_key, region_txt)
          best_result_by_groups.each do |group_id, best_result_by_group|
            result[privacy_key][region_txt][group_id] ||= []
            result[privacy_key][region_txt][group_id] << best_result_by_group
          end
        end
        
        result[privacy_key][region_txt].each do |group_id, results_by_group|
          results_by_group.sort_by!{|r| r[:group][0][:price]}
        end
      end
    end
    result
  end
  
  def self.top_results_by_comparison_and_operator(optimization_ids, operator_id, privacy_keys = [], region_txts = [])
    group_ids = Comparison::Group.where(:optimization_id => optimization_ids).pluck(:id)
    result = {}
    privacy_keys_to_use = privacy_keys.blank? ? RatingsData::RatingPrivacyRegionData.keys : privacy_keys
    privacy_keys_to_use.each do |privacy_key|
      rating_by_privacy = RatingsData::RatingPrivacyRegionData

      result[privacy_key] ||= {}

      region_txts_to_use = region_txts.blank? ? rating_by_privacy.keys : region_txts
      region_txts_to_use.each do |region_txt|
        rating_by_region = rating_by_privacy[region_txt]

        result[privacy_key][region_txt] ||= {}
        tarif_ids = TarifClass.where(:operator_id => operator_id).privacy_and_region_where(privacy_key, region_txt).pluck(:id)
        best_result_by_groups = best_results_by_groups_and_tarifs(group_ids, tarif_ids, 1, false, privacy_key, region_txt)
        best_result_by_groups.each do |group_id, best_result_by_group|
          comparison_optimization_id = best_result_by_group[:comparison_optimization_id]
          result[privacy_key][region_txt][comparison_optimization_id] ||= []
          result[privacy_key][region_txt][comparison_optimization_id] << best_result_by_group
        end

        result[privacy_key][region_txt].each do |comparison_optimization_id, results_by_comparison|
          result[privacy_key][region_txt][comparison_optimization_id] = results_by_comparison.sort_by!{|r| r[:group][0][:price]}
        end
      end
    end
    result
  end
  
  def self.best_service_set_results_for_unlimited_tarifs_by_operator_for_comparisons(optimization_ids, privacy_keys = [], region_txts = [])
    group_ids = Comparison::Group.where(:optimization_id => optimization_ids).pluck(:id)
    result = {}
    privacy_keys_to_use = privacy_keys.blank? ? RatingsData::RatingPrivacyRegionData.keys : privacy_keys
    privacy_keys_to_use.each do |privacy_key|
      rating_by_privacy = RatingsData::RatingPrivacyRegionData

      result[privacy_key] ||= {}

      region_txts_to_use = region_txts.blank? ? rating_by_privacy.keys : region_txts
      region_txts_to_use.each do |region_txt|
        rating_by_region = rating_by_privacy[region_txt]

        result[privacy_key][region_txt] ||= {}
        RatingsData::RatingOperators.each do |operator_id|
          
          tarif_ids = TarifClass.where(:operator_id => operator_id).privacy_and_region_where(privacy_key, region_txt).unlimited_tarif_ids
          best_result_by_groups = best_results_by_groups_and_tarifs(group_ids, tarif_ids, 1, true, privacy_key, region_txt)
          best_result_by_groups.each do |group_id, best_result_by_group|
            result[privacy_key][region_txt][group_id] ||= []
            result[privacy_key][region_txt][group_id] << best_result_by_group
          end
        end
        
        result[privacy_key][region_txt].each do |group_id, results_by_group|
          results_by_group.sort_by!{|r| r[:group][0][:price]}
        end
      end
    end
    result
  end
  
  def self.best_results_by_groups_and_tarifs(group_ids, tarif_ids = [], max_results_by_group = 4, with_service_category_details = false, privacy_key = 'personal', region_txt = 'moskva_i_oblast')
    result = {}; service_ids = []
    Result::ServiceSet.joins(run: [comparison_group: :optimization]).joins(:operator).
      select("distinct on (comparison_groups.optimization_id, comparison_groups.id, result_service_sets.operator_id, result_service_sets.id) result_service_sets.*").
      select("comparison_groups.name as comparison_group_name, categories.name as operator_name, categories.slug as operator_slug").
      select("comparison_groups.optimization_id as comparison_optimizations_id").
      select("comparison_optimizations.name as comparison_optimization_name, comparison_optimizations.slug as comparison_optimization_slug").
      select("comparison_groups.id as comparison_group_id").
      where(:comparison_groups => {:id => group_ids}).
      where(:result_service_sets => {:tarif_id => tarif_ids}).
      order("comparison_groups.optimization_id, comparison_groups.id, result_service_sets.operator_id, result_service_sets.id, result_service_sets.price").each do |item|

      result[item.comparison_group_id] ||= {}
      result[item.comparison_group_id][:comparison_optimization_id] = item.comparison_optimizations_id
      result[item.comparison_group_id][:comparison_optimization_name] = item.comparison_optimization_name
      result[item.comparison_group_id][:comparison_optimization_slug] = item.comparison_optimization_slug
      result[item.comparison_group_id][:comparison_group_name] = item.comparison_group_name
      result[item.comparison_group_id][:id_ref] = "comparison_group_#{item.comparison_group_id}"
      result[item.comparison_group_id][:result_run_id] = item.run_id
      result[item.comparison_group_id][:group] ||= []
      result[item.comparison_group_id][:group] << item.attributes.symbolize_keys      
      service_ids << item.tarif_options 
    end

    service_ids += tarif_ids
    service_ids = service_ids.flatten.uniq.compact
      
    tarifs_desc = {}
    temp_region_txt = "true"
    TarifClass.where(:id => service_ids).where(temp_region_txt).each{|tarif| tarifs_desc[tarif.id] = tarif}
    if with_service_category_details
      included_services_in_tarif = Service::CategoryGroupPresenter.included_services_in_tarif(tarif_ids, region_txt)
      free_calls_in_tarif = Service::CategoryGroupPresenter.free_calls_in_tarif(service_ids, region_txt)
    end
    
      
    result.each do |comparison_group_id, result_by_group|      
              
      result_by_group[:group].sort_by!{|ar| ar[:price]}
      
      result_by_group[:group] = result_by_group[:group][0..(max_results_by_group - 1)]
      
      result_by_group[:group].each do |set_result|
        option_names = []; option_slugs = []
        set_result[:tarif_options].map{|option_id| option_names << tarifs_desc[option_id].name; option_slugs << tarifs_desc[option_id].slug}

        if with_service_category_details
          all_free_call_directions = free_calls_in_tarif[set_result[:tarif_id]] || []
          set_result[:tarif_options].map{|option_id| all_free_call_directions += (free_calls_in_tarif[option_id] || [])}
          all_free_call_directions.uniq!
        end 
        
        set_result.merge!({
          :option_names => option_names, 
          :option_slugs => option_slugs,
          :tarif_name => tarifs_desc[set_result[:tarif_id]].name, 
          :tarif_slug => tarifs_desc[set_result[:tarif_id]].slug,
          })
        set_result.merge!(included_services_in_tarif[set_result[:tarif_id]] || {}).merge!({:free_call_directions => all_free_call_directions}) if with_service_category_details
      end
    end
    raise(StandardError, [
      result[10][:group].map{|r| r[:price]}
    ]) if false
    
    result

  end  

end
