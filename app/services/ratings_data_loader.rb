class RatingsDataLoader

#  attr_reader :base_params, :optimization_params, :m_privacy, :privacy_id, :region_txt
  
  def initialize(input_key = :only_own_home_region, m_privacy = 'personal', region_txt = 'moskva_i_oblast')
    @m_privacy = m_privacy
    @privacy_id = Category::Privacies[m_privacy]['id']
    @region_txt = region_txt
  end
  
  #Calculations order
  #RatingsDataLoader.load_rating_types if changed
  #RatingsDataLoader.load_ratings
  #RatingsDataLoader.load_calls (change true to false if wants reload old calls)
  #RatingsDataLoader.calculate_optimizations (select in arrays rating_keys if you want calculate only some ratings)
  #RatingsDataLoader.check_optimizations
  
  #RatingsDataLoader.check_optimizations
  def self.check_optimizations
    result = {}; result_tarifs = []
    original_group_ids = RatingsData::Rating.map{|r| r[1][:groups].map{|g| g[1][:id] }  }.flatten
    
    iterate_on_privacy_and_region_rating do |rating_key, privacy_key, region_key, rating_description|
      privacy_id = Category::Privacies[privacy_key]['id']
      region_id = Category::MobileRegions[region_key]['region_ids'][0]

      group_ids = group_ids_from_original_ids(original_group_ids, privacy_key, region_key)      
      call_counts = call_count_by_group_operator_privacy_region(group_ids)
            
      optimization_id = optimization_id(rating_description[:id], privacy_key, region_key)
      optimization_type = RatingsData::RatingsType[rating_description[:optimization_type_id]]
      
      rating_description[:groups].each do |group_key, group_description|
        group_id = group_id(group_description[:id], optimization_id)

        result_run = Result::Run.where(:comparison_group_id => group_id).first
        Result::ServiceSet.includes(:tarif).where(:run_id => result_run.id).each do |service_set|

          operator_id = service_set.tarif.operator_id
          tarif_id = service_set.tarif.id
          tarif_name = service_set.tarif.name
          call_count = call_counts.try(:[], group_id).try(:[], privacy_id).try(:[], region_id).try(:[], operator_id)
          
          call_difference = (service_set.call_id_count - call_count).abs
          if call_difference >= 2
            result[group_id] ||= {}
            result[group_id][privacy_id] ||= {}
            result[group_id][privacy_id][region_id] ||= {}
            result[group_id][privacy_id][region_id][operator_id] ||= {}            
            result[group_id][privacy_id][region_id][operator_id][tarif_id] = [tarif_name, call_count, service_set.call_id_count, rating_key, group_key, region_key]
            
            result_tarifs += ([tarif_name] - result_tarifs)
          end
        end

      end
      
    end

    puts
    puts
    puts result
    puts
    puts
    puts result_tarifs.to_s
    puts

    result
  end  
  
  #RatingsDataLoader.call_count_by_group_operator_privacy_region(group_ids)
  def self.call_count_by_group_operator_privacy_region(group_ids = [])
    result = {}
    Customer::CallRun.includes(:group_call_runs).joins(:group_call_runs).where(:comparison_group_call_runs => {:comparison_group_id => group_ids}).each do |call_run|
      begin
      call_run_stat = call_run.stat.blank? ? (call_run.calculate_call_stat; sleep 10) : call_run.stat
      raise(StandardError) if call_run_stat.blank?
      
      call_count = call_run_stat['1_2015'].map do |privacy_id, stat_by_privacy|
        stat_by_privacy.map do |region_key, stat_by_region|
          stat_by_region.map do |global_category|
            global_category['count']
          end.compact.sum
        end.compact.sum         
      end.compact.sum if call_run.stat['1_2015']
      rescue => e
        raise(StandardError, [
          e,          
        ]) if false
      end
      call_run.group_call_runs.each do |group_call_run|
        group_id = group_call_run.comparison_group_id
        privacy_id = call_run.init_params['general']['privacy_id']
        region_id = call_run.init_params['general']['region_id']
        operator_id = call_run.operator_id
        result[group_id] ||= {}
        result[group_id][privacy_id] ||= {}
        result[group_id][privacy_id][region_id] ||= {}
        
        next if result[group_id][privacy_id][region_id][operator_id]
        result[group_id][privacy_id][region_id][operator_id] = call_count
      end      
    end
    result
  end
  
  def self.iterate_on_privacy_and_region_rating(options = {})
    rating_keys_to_process = options['rating_keys_to_process']
    privacy_keys_to_process = options['privacy_keys_to_process']
    region_keys_to_process = options['region_keys_to_process'] 

    rating_keys = rating_keys_to_process.blank? ? RatingsData::Rating.keys : rating_keys_to_process
    privacy_keys = privacy_keys_to_process.blank? ? RatingsData::RatingPrivacyRegionData.keys : privacy_keys_to_process
    region_keys = region_keys_to_process.blank? ? Category.mobile_regions_with_scope(['ratings']).keys : region_keys_to_process
    
    rating_keys.each do |rating_key|
      rating_description = RatingsData::Rating[rating_key.try(:to_sym)]
      privacy_keys.each do |privacy_key|
        region_keys.each do |region_key|
          yield [rating_key, privacy_key, region_key, rating_description]
        end
      end
    end
  end
  
  #RatingsDataLoader.calculate_optimizations
  def self.calculate_optimizations(options = {})
    test_group_key = options['test_group_key']
    test_operator = options['test_operator'].is_a?(Array) ? options['test_operator'][0] : options['test_operator'] 
    services_by_operator_to_use = options['services_by_operator_to_use']
    
    raise(StandardError) if false
    
    result = []
    iterate_on_privacy_and_region_rating(options) do |rating_key, privacy_key, region_key, rating_description|
      privacy_id = Category::Privacies[privacy_key]['id']
      region_id = Category::MobileRegions[region_key]['region_ids'][0]
      
      optimization_id = optimization_id(rating_description[:id], privacy_key, region_key)
      
      optimization_type = RatingsData::RatingsType[rating_description[:optimization_type_id]]
      rating_description[:groups].each do |group_key, group_description|
        next if false and test_group_key and group_key != test_group_key
        
        group_id = group_id(group_description[:id], optimization_id)
        if_clean_output_results = true
        result_run = Result::Run.where(:comparison_group_id => group_id).first
        
        Customer::CallRun.joins(:group_call_runs).
          by_privacy_and_region(privacy_id, region_id).
          where(:comparison_group_call_runs => {:comparison_group_id => group_id}).each do |call_run|
            
          raise(StandardError) if false
          next if test_operator and call_run.operator_id != test_operator
          
          if test_operator
            tarif_ids_to_clean = TarifClass.where(:operator_id => test_operator).pluck(:id).uniq
          end
          
          raise(StandardError) if false

          local_options = {
            :call_run_id => call_run.id,
            :accounting_period => accounting_period_by_call_run_id(call_run.id),
            :result_run_id => result_run.id,
            :operators => [call_run.operator_id],
            :for_service_categories => optimization_type[:for_service_categories],
            :for_services_by_operator => optimization_type[:for_services_by_operator],
            :comparison_group_id => group_id,
            :result_run_name => "#{rating_description[:name]}, #{group_description[:name]}",
            :optimization_type_id => rating_description[:optimization_type_id],
            :if_clean_output_results => if_clean_output_results,
            :tarif_ids_to_clean => tarif_ids_to_clean,
            :background_job_type => 'comparison',
            :slug => (result_run.slug =~ /-/ ? nil : result_run.slug)
          }
          
          optimization_type_options = optimization_type.deep_merge(local_options)
  
          calculation_options = base_params(optimization_type_options, privacy_id, region_key, services_by_operator_to_use)

          if_clean_output_results = false
          
          raise(StandardError, [
            calculation_options,
            optimization_type_options[:if_clean_output_results],
          ]) if call_run.operator_id == Category::Operator::Const::Beeline and false
  
          result << calculate_one_optimization(calculation_options, false)
          result_run.update_columns(result_run_update_options(calculation_options.merge(local_options)))
          if result_run.slug.nil?
            result_run.slug = nil
            result_run.save
          end           
          raise(StandardError) if result_run.slug =~ /-/ or result_run.slug.nil?
        end
      end
    end

    result
  end  
  
  def self.calculate_one_optimization(options, test = false)    
    result = options[:calculation_choices].slice("result_run_id", "call_run_id")
    result.merge!(options[:services_by_operator].slice(:operators))
    
    return result if test
    raise(StandardError, [options[:selected_service_categories]].join("\n")) if false
    
    options_1 = options.merge({:selected_service_categories => []})
    optimizator = ::Optimizator::Runner.new(options_1)
    optimizator.calculate
          
    result
  end
  
  def self.base_params(options, privacy_id = 2, region_txt = 'moskva_i_oblast', services_by_operator_to_use = nil)
    services_by_operator = Customer::Info::ServiceChoices.services_for_comparison(options[:operators], options[:for_services_by_operator], privacy_id , region_txt)
    services_by_operator[:tarifs] = services_by_operator_to_use if services_by_operator_to_use
      
    selected_service_categories = nil
    
    raise(StandardError, services_by_operator)  if false and options[:operators][0] == Category::Operator::Const::Beeline
    
    calculate_on_background = services_by_operator_to_use.blank? ? "true" : "false"
    result = {
      :optimization_params => Customer::Info::TarifOptimizationParams.default_values.merge({
        "calculate_on_background"=>calculate_on_background,        
      }),
      :calculation_choices => {
        "calculate_only_chosen_services"=>"false", 
        "calculate_with_limited_scope"=>"true", 
        "calculate_with_fixed_services"=>"false", 
        "call_run_id"=>options[:call_run_id], 
        "accounting_period"=>options[:accounting_period], 
        "result_run_id"=>options[:result_run_id]
      },
      :selected_service_categories => selected_service_categories,
      :services_by_operator => services_by_operator,
      :temp_value => {
        :user_id => nil,
        :user_region_id => nil,         
        :user_priority => 100,   
        :region_txt => region_txt,             
        :privacy_id => privacy_id,             
      },
      :if_clean_output_results => options[:if_clean_output_results],
      :tarif_ids_to_clean => options[:tarif_ids_to_clean],
    }
    result
  end

  def self.result_run_update_options(options)
    {
      :name => options[:result_run_name],
      :user_id => nil,
      :run => 1,
      
      :call_run_id => nil, 
      :accounting_period => options[:accounting_period],
      :optimization_type_id => options[:optimization_type_id],
      :optimization_params => options[:optimization_params],
      :calculation_choices => options[:calculation_choices],
      :selected_service_categories => options[:selected_service_categories],
      :services_by_operator =>  {}, #options[:services_by_operator],
      :temp_value => options[:temp_value],
      :service_choices => {},
      :services_select => {},
      :services_for_calculation_select => {},
      :service_categories_select => {},
      :comparison_group_id => options[:comparison_group_id],
      :slug => options[:slug],
    }
  end
  
  #RatingsDataLoader.load_calls
  def self.load_calls
    iterate_on_privacy_and_region_rating do |rating_key, privacy_key, region_key, rating_description|
      privacy_id = Category::Privacies[privacy_key]['id']
      region_id = Category::MobileRegions[region_key]['region_ids'][0]
      
      optimization_id = optimization_id(rating_description[:id], privacy_key, region_key)
      
      rating_description[:groups].each do |group_key, group_description|
        group_id = group_id(group_description[:id], optimization_id)
        
        call_runs = Customer::CallRun.joins(:group_call_runs).
          by_privacy_and_region(privacy_id, region_id).
          where(:comparison_group_call_runs => {:comparison_group_id => group_id})
          
        call_runs.generate_group_calls(true, false)
      end
    end
  end  
  
  #RatingsDataLoader.load_ratings
  def self.load_ratings
    iterate_on_privacy_and_region_rating do |rating_key, privacy_key, region_key, rating_description|
      privacy_id = Category::Privacies[privacy_key]['id']
      region_id = Category::MobileRegions[region_key]['region_ids'][0]

      optimization_id = optimization_id(rating_description[:id], privacy_key, region_key)
      
      Comparison::Optimization.find_or_create_by(:id => optimization_id).update(rating_description.except(:id, :groups).merge({:slug => nil}))
      
      rating_description[:groups].each do |group_key, group_description|
        group_id = group_id(group_description[:id], optimization_id)

        Comparison::Group.find_or_create_by(:id => group_id).update(group_description.except(:id, :call_init_params).merge({:optimization_id => optimization_id}))
        
        Result::Run.find_or_create_by({:comparison_group_id => group_id}).update({
            :user_id => nil,
            :call_run_id => nil,
            :name => "#{rating_description[:name]}, #{group_description[:name]}",
            :description => rating_description[:description],
            :slug => nil
          })
        
        RatingsData::RatingOperators.each do |operator_id|
          
          call_run = Customer::CallRun.joins(:group_call_runs).
            where(:operator_id => operator_id).
            where(:comparison_group_call_runs => {:comparison_group_id => group_id}).
            where("init_params->'general'->>'privacy_id' = '#{privacy_id}'").
            where("init_params->'general'->>'region_id' = '#{region_id}'").find_or_create_by({})
          Comparison::GroupCallRun.find_or_create_by({:comparison_group_id => group_id, :call_run_id => call_run.id})
          
          home_regions = Category::MobileRegions[region_key].try(:[], 'region_ids')
          region_for_region_calls_ids = (region_key == 'moskva_i_oblast' ? Category::Region::Const::Sankt_peterburg : Category::Region::Const::Moskva)
          
          call_run_update_params = {
            :user_id => nil,
            :source => 2,
            :name => "#{rating_key.to_s}, #{group_key.to_s}, #{operator_id}, #{privacy_key}, #{region_key}",
            :operator_id => operator_id,
            :init_class => group_description[:call_init_params].to_s,
            :init_params => group_description[:call_init_params].deep_merge({
              :general => {
                "region_txt" => region_key, 
                "region_id" => region_id, 
                "privacy_id" => privacy_id,
              },
              :own_region=> {
                "rouming_region_id"=> home_regions.try(:[], 0),
                "region_for_region_calls_ids"=> region_for_region_calls_ids, 
              },  
              :home_region=> {
                "rouming_region_id"=> (home_regions.try(:[], 1) || home_regions.try(:[], 0)),
              }, 
              :own_country=>{
                "rouming_region_id"=> region_for_region_calls_ids,
              }, 
              :abroad=>{
              } 
            }),
            :stat => {},
          }
          call_run.update(call_run_update_params)
        end
      
      end
    end

  end
  
  #RatingsDataLoader.clean_wrong_call_runs_and_calls
  def self.clean_wrong_call_runs_and_calls
    group_ids = RatingsData::Rating.map{|r| r[1][:groups].map{|g| g[1][:id] }  }.flatten
    
    wrong_call_run_ids = Customer::CallRun.joins(:group_call_runs).
    select("comparison_group_id, operator_id, init_params->'general'->>'privacy_id' as privacy_id, init_params->'general'->>'region_id' as region_id, count(*) as count, array_agg(customer_call_runs.id) as ids").
    where(:comparison_group_call_runs => {:comparison_group_id => group_ids}).
    group("comparison_group_id, init_params->'general'->>'privacy_id', init_params->'general'->>'region_id', operator_id").select{|row| row.count > 1}.map{|row| row.attributes}
#    Comparison::GroupCallRun.where({:call_run_id => wrong_call_run_ids}).delete_all
    
  end

  #RatingsDataLoader.load_rating_types
  def self.load_rating_types
    RatingsData::RatingsType.each do |rating_type_id, rating_type_value|
      Comparison::OptimizationType.find_or_create_by(:id => rating_type_id).update(rating_type_value)      
    end
  end

  #RatingsDataLoader.optimization_id(0, 'business', 'rostov_i_oblast')
  def self.optimization_id(original_optimization_id, m_privacy, m_region)
    start_id = 200
    max_range = 200
    result = start_id + original_optimization_id * max_range + FastOptimization::DataLoader::InputRegionData[m_privacy][m_region][:optimization_id]
  end
  
  #RatingsDataLoader.original_optimization_id(0, 'business', 'rostov_i_oblast')
  def self.original_optimization_id(optimization_id, m_privacy, m_region)
    start_id = 200
    max_range = 200
    original_optimization_id = (optimization_id - start_id) / max_range
  end
  
  #RatingsDataLoader.privacy_region_from_id(315)
  def self.privacy_region_from_id(optimization_id)
    max_range = 200
    multiple_of_max_range = optimization_id / max_range
    original_optimization_id = optimization_id - multiple_of_max_range * max_range
    FastOptimization::DataLoader.privacy_and_region_by_optimization_id(original_optimization_id)
  end
  
  def self.original_ids
    RatingsData::Rating.map{|rating_key, rating_desc| rating_desc[:id]}
  end 
  
  def self.ids_from_original_ids(original_ids, m_privacy, m_region)
    original_ids.map{|original_id| optimization_id(original_id, m_privacy, m_region)} 
  end

  def self.group_id(original_group_id, final_optimization_id)
    start_id = 0
    max_range = 100
    result = start_id + final_optimization_id * max_range + original_group_id
  end
  
  def self.group_ids_from_original_ids(original_group_ids, m_privacy, m_region)
    final_group_ids = []
    original_group_ids.each do |original_group_id|
      final_group_ids << group_id_from_original_id(original_group_id, m_privacy, m_region) 
    end
    final_group_ids
  end
  
  def self.group_id_from_original_id(original_group_id, m_privacy, m_region)
    original_optimization_id = original_optimization_id_from_group_id(original_group_id)
    final_optimization_id = optimization_id(original_optimization_id, m_privacy, m_region)
    group_id(original_group_id, final_optimization_id) 
  end
  
  def self.original_optimization_id_from_group_id(original_group_id)
    RatingsData::Rating.each do |rating_key, rating_desc|
      rating_desc[:groups].each do |group_key, group_desc|
        return rating_desc[:id] if group_desc[:id] == original_group_id
      end
    end
    nil
  end

  def self.accounting_period_by_call_run_id(call_run_id)
    '1_2015'
  end

end

