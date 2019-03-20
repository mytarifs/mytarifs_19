class Comparison::FastOptimizationPresenter
  attr_reader :fast_optimization_data_loader
  
  def initialize(fast_optimization_key = :only_own_home_region, m_privacy = 'personal', region_txt = 'moskva_i_oblast')
    @fast_optimization_data_loader = FastOptimization::DataLoader.new(fast_optimization_key, m_privacy, region_txt)
  end
  
  #Comparison::FastOptimizationPresenter.fast_optimization_for_tarif_exists?(tarif_id) 
  def self.fast_optimization_for_tarif_exists?(tarif_id, region_txt)
    optimization_ids = FastOptimization::DataLoader::InputRegionData.map{|privacy| privacy[1][region_txt].try(:[], :optimization_id)}.flatten
    Result::ServiceSet.joins(run: :comparison_group).
      where({:comparison_groups => {:optimization_id => optimization_ids}, :tarif_id => tarif_id}).exists?
  end
  
  def result_presentation(params, result_type = :best_result, result_number = 5, tarif_id = nil, tarif_ids_to_limit_result = [])
    result = {}; service_ids = []
    result_run_id = result_run_id_from_params(params)
    result_service_set_by_result_type(result_run_id, result_type, result_number, tarif_id, tarif_ids_to_limit_result).each do |service_set|
      next if service_set.nil?
      result[service_set.id] = service_set.attributes.symbolize_keys
      result[service_set.id][:operator_name] = service_set.operator.try(:name)
      service_ids << service_set.tarif_options 
      service_ids << service_set.tarif_id      
    end

    tarifs_desc = {}
    TarifClass.where(:id => service_ids).each{|tarif| tarifs_desc[tarif.id] = tarif}
    
    result.each do |service_set_id, service_set_resut|
      option_names = []; option_slugs = []
      service_set_resut[:tarif_options].map{|option_id| option_names << tarifs_desc[option_id].name; option_slugs << tarifs_desc[option_id].slug}

      service_set_resut.merge!({
        :option_names => option_names, :option_slugs => option_slugs,
        :tarif_name => tarifs_desc[service_set_resut[:tarif_id]].name, :tarif_slug => tarifs_desc[service_set_resut[:tarif_id]].slug,
        })      
    end
    result
  end
  
  def result_service_set_by_result_type(result_run_id, result_type, result_number, tarif_id = nil, tarif_ids_to_limit_result = [])
    case result_type
    when :best_result_by_operator
      Category::Operator::Const::OperatorsForOptimization.map do |operator_id|
        Result::ServiceSet.includes(:operator).
          where(:run_id => result_run_id, :operator_id => operator_id, :tarif_id => tarif_ids_to_limit_result).order("price, array_length(tarif_options,0)").limit(1).first
      end.sort_by!{|item| (item.try(:price) || 100000000.0)}        
    when :best_result_by_tarif
      Result::ServiceSet.includes(:operator).best_service_sets_by_tarif(result_run_id, tarif_id, 1)
    else
      Result::ServiceSet.includes(:operator).best_service_sets(result_run_id, result_number, tarif_ids_to_limit_result)
    end
  end
  
  def result_run_id_from_params(params)
    variable_call_params = {}
    if params.slice(*parts).blank?
      base_params[:call_generation][:quantity].values.each do |p| 
        p.each do |k, v| 
          variable_call_params.merge!({k => v[0]}) 
        end                 
      end
    else
      params.slice(*parts).each{|key, param| variable_call_params.merge!(string_to_hash(param))}
    end 

    Comparison::Group.joins(:result_run).where(:optimization_id => base_params[:optimization][:id]).
      where("result->'variable_call_params' = ?", variable_call_params.to_json).pluck("distinct result_runs.id")[0]
  end
  
  def string_to_hash(string)
    if string.split('=>').size == 0
      {}
    else
      JSON.parse(string.gsub('=>', ':'))
    end
    
  end

  #Comparison::FastOptimizationPresenter.new.options_presentation
  def options_presentation
    result = {}
    options.each do |part, params_by_part|
      result[part] ||= {}
      result[part][:name] = part_name(part)
      result[part][:options] ||= {}
      all_combinations_of_part(part).sort_by!{|combination| combination.values.sum}.each do |combination|
        option_name_arr = []
        combination.each do |param_name, param_value|
          option_name_arr << option_name(param_name, param_value)
        end
        result[part][:options][combination] = option_name_arr.join(", ")
      end
      result[part][:empty_size] = max_param_size - all_combinations_of_part(part).size
    end
    result
  end
  
  def base_call_generation_params
    Customer::Call::Init::FastOptimization::Base
  end
  
  def options
    base_params[:call_generation][:quantity]
  end
  
  def base_params
    fast_optimization_data_loader.base_params
  end
  
  #Comparison::FastOptimizationPresenter.new.max_param_size
  def max_param_size
    options.keys.map{|part| all_combinations_of_part(part).size}.max
  end
  
  #Comparison::FastOptimizationPresenter.new.all_combinations_of_part('own-country-rouming/mobile-connection')
  def all_combinations_of_part(part)
    input = options[part]
    keys = input.keys
    values = input.values
    values.shift.product(*values).map { |v| Hash[keys.zip(v)] }
  end

  def parts
    options.keys
  end

  def part_name(part)
    case part
    when 'own-country-rouming/calls'
      "Длительность всех звонков, мин"
    when 'own-country-rouming/sms'
      "Количество всех смс, шт"
    when 'own-country-rouming/mobile-connection'
      "Объем всего трафика интернета, Гб"
    end
  end
  
  def option_name(param_key, param_value)
    case param_key
    when 'number_of_day_calls'
      "#{param_value * 30.0 * base_call_generation_params[:own_region]['duration_of_calls']} мин"
    when 'number_of_sms_per_day'
      "#{param_value * 30.0} смс"
    when 'internet_trafic_per_month'
      "#{param_value} Гб"
    end
  end

  
end

