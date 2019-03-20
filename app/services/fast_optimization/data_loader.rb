class FastOptimization::DataLoader
  include Optimizator::RunnerGeneralHelper, FastOptimization::Data, FastOptimization::DataCheckHelper

  attr_reader :base_params, :optimization_params, :m_privacy, :privacy_id, :region_txt
  
  def initialize(input_key = :only_own_home_region, m_privacy = 'personal', region_txt = 'moskva_i_oblast')
    @m_privacy = m_privacy
    @privacy_id = Category::Privacies[m_privacy]['id']
    @region_txt = region_txt
    @optimization_params = {
      'calculate_on_background' => true,
      'calculate_with_sidekiq' => true,
      'calculate_performance' => false,      
      'calculate_with_cache_for_operator' => true,
    }
    calculate_base_params(input_key)
  end
     
#Последовательность расчетов
#FastOptimization::DataLoader.new.calculate("update_or_create_records_in_all_optimization_tables")
#FastOptimization::DataLoader.new.calculate("calculate_temp_variable_result")
#FastOptimization::DataLoader.new.calculate("calculate_temp_fixed_result")
#FastOptimization::DataLoader.new.calculate("calculate_final_tarif_results")  

  def self.calculate(calculation_options)
    input_key = calculation_options[:input_key]
    m_privacy_keys = calculation_options[:m_privacy_keys].blank? ? InputRegionData.keys : calculation_options[:m_privacy_keys]
    region_txt_keys = calculation_options[:region_txt_keys].blank? ? Category.mobile_regions_with_scope(['fast_optimization']).keys : calculation_options[:region_txt_keys]
    operators_to_calculate = calculation_options[:operators_to_calculate].blank? ? [] : calculation_options[:operators_to_calculate]
    method = calculation_options[:method]
    
    return "no method chosen" if method.blank?
    
    m_privacy_keys.each do |m_privacy|
      region_txt_keys.each do |region_txt|
        fast_optimizator = FastOptimization::DataLoader.new(input_key.try(:to_sym), m_privacy, region_txt)
        if method == 'test'
          return fast_optimizator.calculate(method, operators_to_calculate)
        else
          fast_optimizator.calculate(method, operators_to_calculate)
        end         
      end
    end    
  end 
  
  def calculate(method_name, operators_to_calculate = [])
    background = ['update_or_create_records_in_all_optimization_tables', 'test'].include?(method_name) ? false : false    
    
    if background #and optimization_params['calculate_on_background']
#      Background::WorkerManager::Manager.start_number_of_worker('worker', 1) if Background::WorkerManager::Manager.worker_quantity('worker') == 0
      ::SideFastOptimizationDataLoader.perform_async(method_name, operators_to_calculate)
    else 
      calculation_runner(method_name, operators_to_calculate)
    end
  end
  
  def calculation_runner(method_name, operators_to_calculate = [])
    send(method_name.to_sym, operators_to_calculate)
  end
    
  #FastOptimization::DataLoader.new.calculate_final_tarif_results
  def calculate_final_tarif_results(operators_to_calculate = [])
    Optimizator::Runner.new().clean_performance_stat_before_calculate_all(1)
    parts = base_params[:call_generation][:quantity].keys
    selected_service_categories =  Optimization::Global::Base.new.global_names_by_parts(parts)

    Comparison::Group.includes(:result_run).where(:optimization_id => base_params[:optimization][:id]).each do |group|
      next if group.result.try(:[], 'result_type') != 'final'
            
      result_run_id = group.result_run.id
      
      calculated_call_and_result_run_ids_from_temp_group_results = call_and_result_run_ids_from_temp_group_results(group, operators_to_calculate)
      
      call_run_ids = calculated_call_and_result_run_ids_from_temp_group_results[:call_run_ids]

      result_run_ids = calculated_call_and_result_run_ids_from_temp_group_results[:result_run_ids]
      
      Category::Operator::Const::OperatorsForOptimization.each do |operator_id|
        next if !operators_to_calculate.blank? and !operators_to_calculate.include?(operator_id)
        
        calculation_options = {
          :temp_value => {
            :user_id => 1,
            :user_region_id => nil,         
            :privacy_id => privacy_id,
            :region_txt => region_txt,
          },
          :optimization_params => {
            'calculate_one_operator_function_name' => 'calculate_final_tarif_sets_by_tarif_from_prepared_tarif_results'
          }.merge(optimization_params),
          :calculation_choices => {
            'accounting_period' => '1_2015',
            'call_run_id' => call_run_ids[operator_id],
            'result_run_id' => result_run_id,
            'temp_result_run_ids' => (result_run_ids[operator_id] + [result_run_id]),
          },
          :selected_service_categories => selected_service_categories,
          :services_by_operator => Customer::Info::ServiceChoices.services_for_comparison([operator_id], base_params[:optimization_type][:for_services_by_operator], privacy_id, region_txt),
        }
        

        optimizator = Optimizator::Runner.new(calculation_options)

        tarif_ids_to_clean = TarifClass.tarifs.where(:operator_id => operator_id, :privacy_id => privacy_id).pluck(:id)        
        Optimizator::RunnerGeneralHelper.clean_results(result_run_id, tarif_ids_to_clean)
        
        optimizator.run_calculation_of_one_operator(optimizator.options, false)
      end      
    end
  end
  
  #FastOptimization::DataLoader.new.calculate_temp_fixed_result
  def calculate_temp_fixed_result(operators_to_calculate = [])
    parts = base_params[:call_generation][:quantity].keys
    selected_service_categories =  Optimization::Global::Base.new.global_names_by_parts(parts)
    
    Comparison::Group.includes(:result_run, :call_runs).where(:optimization_id => base_params[:optimization][:id]).each do |group|
      next if group.result.try(:[], 'result_type') != 'final'
      result_run_id = group.result_run.id

      call_run_ids = call_and_result_run_ids_from_temp_group_results(group, operators_to_calculate)[:call_run_ids]
      
      Category::Operator::Const::OperatorsForOptimization.each do |operator_id|
        next if !operators_to_calculate.blank? and !operators_to_calculate.include?(operator_id)
        
        Result::TarifResult.joins(:tarif).where(:run_id => result_run_id, :tarif_classes => {:operator_id => operator_id}).delete_all
        
        calculation_options = {
          :temp_value => {
            :user_id => 1,
            :user_region_id => nil,         
            :privacy_id => privacy_id,
            :region_txt => region_txt,
          },
          :optimization_params => {
            'calculate_one_operator_function_name' => 'calculate_only_fixed_single_tarif_results_by_operator'
          }.merge(optimization_params),
          :calculation_choices => {
            'accounting_period' => '1_2015',
            'call_run_id' => call_run_ids[operator_id],
            'result_run_id' => result_run_id,
          },
          :selected_service_categories => selected_service_categories,
          :services_by_operator => Customer::Info::ServiceChoices.services_for_comparison([operator_id], base_params[:optimization_type][:for_services_by_operator], privacy_id, region_txt),
        }
        
        optimizator = Optimizator::Runner.new(calculation_options)

        tarif_ids_to_clean = TarifClass.tarifs.where(:operator_id => operator_id, :privacy_id => privacy_id).pluck(:id)        
        Optimizator::RunnerGeneralHelper.clean_results(result_run_id, tarif_ids_to_clean)
        
        optimizator.run_calculation_of_one_operator(optimizator.options, false)
      end      
    end
  end

  def call_and_result_run_ids_from_temp_group_results(group, operators_to_calculate = [])
    call_run_ids = {}; result_run_ids = {}
    
    Category::Operator::Const::OperatorsForOptimization.each do |operator_id|
      next if !operators_to_calculate.blank? and !operators_to_calculate.include?(operator_id)
      
      call_run_ids[operator_id] ||= []; result_run_ids[operator_id] ||= []
      group.result['temp_group_ids'].each do |group_id_hash|
        group_id_hash.each do |group_id, call_run_id_by_operator_id|
          call_run_ids[operator_id] << call_run_id_by_operator_id[operator_id.to_s]['call_run_id']
          result_run_ids[operator_id] << call_run_id_by_operator_id[operator_id.to_s]['result_run_id']
        end
      end #if group #and group.result and group.result['temp_group_ids']
    end
    {:call_run_ids => call_run_ids, :result_run_ids => result_run_ids}
  end
  
  #FastOptimization::DataLoader.new.calculate_temp_variable_result
  def calculate_temp_variable_result(operators_to_calculate = [])
    Comparison::Group.includes(:result_run, :call_runs).where(:optimization_id => base_params[:optimization][:id]).order("id desc").each do |group|
      next if group.result.try(:[], 'result_type') != 'temp'
      part = group.result['part']
      result_run_id = group.result_run.id

      group.call_runs.each do |call_run|
        operator_id = call_run.operator_id
        next if !operators_to_calculate.blank? and !operators_to_calculate.include?(operator_id)

        Result::TarifResult.joins(:tarif).where(:run_id => result_run_id, :tarif_classes => {:operator_id => operator_id}).delete_all

        selected_service_categories =  Optimization::Global::Base.new.global_names_by_part(part)
        
        calculation_options = {
          :temp_value => {
            :user_id => 1,
            :user_region_id => nil,         
            :privacy_id => privacy_id,
            :region_txt => region_txt,
          },
          :optimization_params => {
            'calculate_one_operator_function_name' => 'calculate_only_tarif_results_by_operator'
          }.merge(optimization_params),
          :calculation_choices => {
            'accounting_period' => '1_2015',
            'call_run_id' => call_run.id,
            'result_run_id' => result_run_id,
          },
          :selected_service_categories => selected_service_categories,
          :services_by_operator => Customer::Info::ServiceChoices.services_for_comparison([operator_id], base_params[:optimization_type][:for_services_by_operator], privacy_id, region_txt),
        }
        
        optimizator = Optimizator::Runner.new(calculation_options)

        tarif_ids_to_clean = TarifClass.tarifs.where(:operator_id => operator_id, :privacy_id => privacy_id).pluck(:id)        
        Optimizator::RunnerGeneralHelper.clean_results(result_run_id, tarif_ids_to_clean)
        
        optimizator.run_calculation_of_one_operator(optimizator.options, false)
      end
    end
  end
  
  #FastOptimization::DataLoader.new().update_or_create_records_in_all_optimization_tables
  def update_or_create_records_in_all_optimization_tables(test = false)
    prev_generated_group_ids, group_ids_by_variable_params = update_or_create_records_in_intermediate_optimization_tables
    
    group_combinations = update_or_create_records_in_final_optimization_tables(prev_generated_group_ids, group_ids_by_variable_params)
    
    generate_calls if !test
    
    group_combinations
  end
  
  #FastOptimization::DataLoader.new.generate_calls
  def generate_calls
    Comparison::Group.where(:optimization_id => base_params[:optimization][:id]).each do |group|
      next if group.result.try(:[], 'result_type') != 'temp'
      group.call_runs.generate_group_calls(false, false)
    end
  end
  
  def update_or_create_records_in_final_optimization_tables(prev_generated_group_ids, group_ids_by_variable_params)
    final_params = {}
    base_params[:call_generation][:quantity].each do |part, part_params|
      part_params.each{ |param_name, param_value| final_params[param_name] = param_value}
    end

    group_combinations = {}
    basa_call_params = generate_base_call_params
    group_ids = []
    
    all_combinations_of_calls(final_params).each do |variable_call_params|
      group_combinations[variable_call_params] ||= []
      variable_call_params.each do |variable_call_param_name, variable_call_param_value|
        group_combinations[variable_call_params] << group_ids_by_variable_params[{variable_call_param_name => variable_call_param_value}]
      end

      group_name = group_name_from_variable_call_params(basa_call_params, variable_call_params)
      
      group = Comparison::Group.find_or_create_by(:name => group_name, :optimization_id => base_params[:optimization][:id])
      group.update(:result => {:variable_call_params => variable_call_params, :temp_group_ids => group_combinations[variable_call_params], :result_type => 'final'})
      group_ids << group.id
      
      result_run = Result::Run.find_or_create_by(:comparison_group_id => group.id)
      result_run.update(:user_id => nil, :call_run_id => nil)
    end

    clean_old_records(group_ids + prev_generated_group_ids)
    
    group_combinations
  end
   
  #FastOptimization::DataLoader.new().update_or_create_records_in_intermediate_optimization_tables
  def update_or_create_records_in_intermediate_optimization_tables
    group_ids_by_variable_params = {}
    prev_generated_group_ids = []
    base_params[:call_generation][:quantity].each do |part, part_params|
      one_part_params = {}
      part_params.each{ |param_name, param_value| one_part_params[param_name] = param_value}
      prev_generated_group_ids += update_or_create_records_in_temp_optimization_tables(part, one_part_params, prev_generated_group_ids.deep_dup, group_ids_by_variable_params)
    end    

    [prev_generated_group_ids.uniq, group_ids_by_variable_params]
  end
    
  def update_or_create_records_in_temp_optimization_tables(part, call_generation_quantities, prev_generated_group_ids = [], group_ids_by_variable_params = {}) 
    Comparison::OptimizationType.find_or_create_by(:id => base_params[:optimization_type][:id]).update(base_params[:optimization_type].except(:id))

    Comparison::Optimization.find_or_create_by(:id => base_params[:optimization][:id]).update(base_params[:optimization].except(:id))
    
    group_ids = []
    basa_call_params = generate_base_call_params
    all_combinations_of_calls(call_generation_quantities).each do |variable_call_params|
      group_name = group_name_from_variable_call_params(basa_call_params, variable_call_params)
      
      group = Comparison::Group.find_or_create_by(:name => group_name, :optimization_id => base_params[:optimization][:id])
      group.update(:result => {:part => part, :variable_call_params => variable_call_params, :result_type => 'temp'})
      group_ids << group.id
      group_ids_by_variable_params[variable_call_params] ||= {}
      group_ids_by_variable_params[variable_call_params][group.id] ||= {} 
      
      result_run = Result::Run.find_or_create_by(:comparison_group_id => group.id)
      result_run.update(:user_id => nil, :call_run_id => nil)
      
      Category::Operator::Const::OperatorsForOptimization.each do |operator_id|
        current_call_params = final_call_generation_params(basa_call_params, variable_call_params).deep_merge({:general => {"operator_id" => operator_id}})  
        call_run = group.call_runs.find_or_create_by(:operator_id => operator_id)
        call_run.update(:user_id => nil, :source => 3, :name => "#{group_name}_#{operator_id}", :description => "", :operator_id => operator_id,
          :init_class => nil,:init_params => current_call_params)
        group_ids_by_variable_params[variable_call_params][group.id][operator_id] = {:call_run_id => call_run.id, :result_run_id => result_run.id}
      end
    end
#    clean_old_records(group_ids + prev_generated_group_ids)    
    (group_ids + prev_generated_group_ids).uniq
  end
  
  def group_name_from_variable_call_params(basa_call_params, variable_call_params)
    result = []
    variable_call_params.each do |param_name, param_value|
      result << case param_name
      when 'number_of_day_calls'
        "#{param_value * 30.0 * basa_call_params[:own_region]['duration_of_calls']} мин"
      when 'number_of_sms_per_day'
        "#{param_value * 30.0} смс"
      when 'internet_trafic_per_month'
        "#{param_value} Гб"
      end
    end
    result.join(", ")
  end
  
  def clean_old_records(new_group_ids)
    Comparison::Group.where(:optimization_id => base_params[:optimization][:id]).where.not(:id => new_group_ids).each do |old_group|
      if old_group.result_run
        old_group.result_run.tarif_results.delete_all
        old_group.result_run.delete 
      end
      old_group.group_call_runs.each do |group_call_run|
        group_call_run.call_run.calls.delete_all
        group_call_run.call_run.delete
        group_call_run.delete
      end
      old_group.delete
    end    
  end
  
  def final_call_generation_params(basa_call_params, variable_call_params)
    new_params = basa_call_params.deep_dup
    [:own_region, :home_region, :own_country, :abroad].each do |rouming|
      new_params.deep_merge!({rouming => variable_call_params})
    end
    new_params
  end
  
  #FastOptimization::DataLoader.new().all_combinations_of_calls
  def all_combinations_of_calls(input)
    keys = input.keys
    values = input.values
    values.shift.product(*values).map { |v| Hash[keys.zip(v)] }
  end
  
  #FastOptimization::DataLoader.new.generate_base_call_params
  def generate_base_call_params
    base_call_params = Customer::Call::Init::FastOptimization::Base.deep_merge(base_params[:call_generation].slice(:general))
    [:own_region, :home_region, :own_country, :abroad].each do |rouming|
      base_call_params.deep_merge!({rouming => base_params[:call_generation][:geo_calls]})
    end
    base_call_params
  end

  def calculate_base_params(input_key)
    home_regions = Category::MobileRegions[region_txt].try(:[], 'region_ids')
    
    @base_params = InputData[input_key].deep_merge({
      :call_generation => {
        :general => {
          "privacy_id" => privacy_id,
          "region_id" => home_regions[0], 
        },
        :own_region => {
          'region_id'.freeze => home_regions.try(:[], 0), 
          'privacy_id'.freeze => privacy_id,
          'region_for_region_calls_ids'.freeze => (region_txt == 'moskva_i_oblast' ? Category::Region::Const::Sankt_peterburg : Category::Region::Const::Moskva),
        },
        :home_region => {
          'rouming_region_id'.freeze => (home_regions.try(:[], 1) || home_regions.try(:[], 0)), 
        },
        :own_country => {
          'rouming_region_id'.freeze => (region_txt == 'moskva_i_oblast' ? Category::Region::Const::Sankt_peterburg : Category::Region::Const::Moskva), 
        },
      },
      :optimization => {
        :id => InputRegionData[m_privacy][region_txt][:optimization_id]
      }
    })
  end

  def self.privacy_and_region_by_optimization_id(optimization_id)
    InputRegionData.each do |m_privacy, desc_by_privacy|
      desc_by_privacy.each do |m_region, desc_by_region|
        return [m_privacy, m_region] if desc_by_region[:optimization_id] == optimization_id
      end
    end
    nil
  end
    
end

