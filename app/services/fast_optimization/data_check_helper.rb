module FastOptimization::DataCheckHelper
  
  #FastOptimization::DataLoader.new.test
  def test(operators_to_calculate = [])
    service_selected = Customer::Info::ServiceChoices.services_for_comparison(
      Category::Operator::Const::OperatorsForOptimization, base_params[:optimization_type][:for_services_by_operator], privacy_id, region_txt)
    plan = {
      :operators_number => service_selected[:operators].count,
      :tarif_number => service_selected[:tarifs].map{|op| op[1].size}.sum,
      :part_number => base_params[:call_generation][:quantity].keys.size,
      :params_number => base_params[:call_generation][:quantity].map{|p| p[1].keys.size}.sum,
      :number_of_temp_groups => base_params[:call_generation][:quantity].map{|p| p[1].values.map(&:size).inject(:*)}.sum,
      :number_of_final_groups => base_params[:call_generation][:quantity].map{|p| p[1].values.map(&:size).inject(:*)}.inject(:*),      
    }    
    plan[:number_of_calls] = plan[:number_of_temp_groups] * plan[:operators_number] 
    plan[:number_of_variable_calculations] = plan[:number_of_temp_groups] * plan[:tarif_number]
    plan[:number_of_fixed_calculations] = plan[:number_of_final_groups] * plan[:tarif_number] * 2
    plan[:number_of_final_calculations] = plan[:number_of_final_groups] * plan[:tarif_number] 
    plan[:number_of_wrong_varaible_parts] = 0 
    plan[:number_of_wrong_fixed_parts] = 0 
    
    base_group_sql = Comparison::Group.where(:optimization_id => base_params[:optimization][:id])
    
    fact = {
      :number_of_temp_groups => base_group_sql.where("result->>'result_type' = ?", 'temp').size,
      :number_of_final_groups => base_group_sql.where("result->>'result_type' = ?", 'final').size,
      :number_of_calls => Customer::Call.select("customer_calls.call_run_id").joins(call_run: [group_call_runs: :comparison_group]).
        where(:comparison_groups => {:optimization_id => base_params[:optimization][:id]}).uniq("customer_calls.call_run_id").count(),
      :number_of_variable_calculations => Result::TarifResult.
        joins(run: :comparison_group).where(:comparison_groups => {:optimization_id => base_params[:optimization][:id]}).
        where(:part => base_params[:call_generation][:quantity].keys).pluck(:id).count(),
      :number_of_fixed_calculations => Result::TarifResult.
        joins(run: :comparison_group).where(:comparison_groups => {:optimization_id => base_params[:optimization][:id]}).
        where.not(:part => base_params[:call_generation][:quantity].keys).pluck(:id).count(),
      :number_of_final_calculations => Result::ServiceSet.select("result_service_sets.service_set_id as service_set_id").
        joins(run: :comparison_group).where(:comparison_groups => {:optimization_id => base_params[:optimization][:id]}).pluck(:service_set_id).count(),
      :number_of_wrong_varaible_parts => check_final_tarif_results_for_variable_parts.count(),
      :number_of_wrong_fixed_parts => check_final_tarif_results_for_fixed_parts.count(),
    }
    
    check = {}
    fact.each do |param, fact_value|
      if fact_value == plan[param]
        check[param] = fact_value
      else
        case param
        when :number_of_temp_groups
          temp_check = base_params[:call_generation][:quantity].map{|p| all_combinations_of_calls(p[1]).size}.sum
#          test_result = update_or_create_records_in_all_optimization_tables(true) 
        when :number_of_final_groups
          temp_check = base_params[:call_generation][:quantity].map{|p| all_combinations_of_calls(p[1]).size}.inject(:*)
        when :number_of_calls
          temp_check = nil
        when :number_of_variable_calculations
          temp_check = nil
        when :number_of_fixed_calculations
          temp_check = nil
        when :number_of_final_calculations
          temp_check = nil
        when :number_of_wrong_varaible_parts
          temp_check = nil
        when :number_of_wrong_fixed_parts
          temp_check = nil
        end
        check[param] = {:status => 'failed', :plan_fact => [plan[param], fact_value], :temp_check => temp_check}#, :test_result => test_result}
      end
    end
    check#.merge({:base_params => base_params})
  end
  
  #FastOptimization::DataLoader.new.check_final_tarif_results_for_fixed_parts
  def check_final_tarif_results_for_fixed_parts
    tarif_sql = [
      "select tarif_class_id, count(distinct service_category_tarif_classes.conditions#>>'{parts, 0}') as correct_part_number from service_category_tarif_classes",
      "where service_category_tarif_classes.conditions#>>'{parts, 0}' in ('onetime', 'periodic') \
      and (((conditions->>'tarif_set_must_include_tarif_options')::text is null) or ((conditions->>'tarif_set_must_include_tarif_options')::text = '[]'))",
      "group by tarif_class_id"
    ].join(" ")
    
    sql = Comparison::Group.where(:optimization_id => base_params[:optimization][:id]).
      select("comparison_groups.name as comparison_groups_id, result_runs.id as result_runs_id, result_services.tarif_id as tarif_id, \
        result_services.service_id as service_id, ((jsonb_array_elements(result_services.categ_ids))->>0)::integer as categ_id").
      joins(result_run: :services).
      group("comparison_groups_id, result_runs_id, tarif_id, service_id, categ_id").to_sql
    
    sql_2 = ["with first_sql as (#{sql}), tarif_sql as (#{tarif_sql})",
      "select comparison_groups_id, result_runs_id, tarif_id, service_id, count(distinct service_category_tarif_classes.conditions#>>'{parts, 0}') as part_number, \
        array_agg(distinct service_category_tarif_classes.conditions#>>'{parts, 0}'), correct_part_number",
      "from first_sql join service_category_tarif_classes on service_category_tarif_classes.id = categ_id",
      "join tarif_sql on tarif_sql.tarif_class_id =first_sql.service_id",
      "where service_category_tarif_classes.conditions#>>'{parts, 0}' in ('onetime', 'periodic') \
       and (((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::text is null) or ((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::text = '[]'))", 
      "group by comparison_groups_id, result_runs_id, tarif_id, service_id, correct_part_number",
      "having count(distinct service_category_tarif_classes.conditions#>>'{parts, 0}') <> tarif_sql.correct_part_number"].join(" ")
    
    Comparison::Group.find_by_sql(sql_2)#.count() #[0].try(:attributes)  
  end
  
  #FastOptimization::DataLoader.new.check_final_tarif_results_for_variable_parts
  def check_final_tarif_results_for_variable_parts
    correct_variable_part_number = base_params[:call_generation][:quantity].keys.size
    sql = Comparison::Group.where(:optimization_id => base_params[:optimization][:id]).
      select("comparison_groups.name as comparison_groups_id, result_runs.id as result_runs_id, result_agregates.tarif_id as tarif_id, \
        ((jsonb_array_elements(result_agregates.categ_ids))->>0)::integer as categ_id").
      joins(result_run: :agregates).
      group("comparison_groups_id, result_runs_id, tarif_id, categ_id").to_sql
    
    sql_2 = ["with first_sql as (#{sql}) select comparison_groups_id, result_runs_id, tarif_id, count(distinct service_category_tarif_classes.conditions#>>'{parts, 0}') as part_number, #{correct_variable_part_number} as correct_variable_part_number",
      "from first_sql join service_category_tarif_classes on service_category_tarif_classes.id = categ_id",
      "where service_category_tarif_classes.conditions#>>'{parts, 0}' not in ('onetime', 'periodic') \
      and ((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::text is null or \
           (service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::text = '[]')", 
      "group by comparison_groups_id, result_runs_id, tarif_id",
      "having count(distinct service_category_tarif_classes.conditions#>>'{parts, 0}') <> #{correct_variable_part_number}"]
    
    Comparison::Group.find_by_sql(sql_2.join(" "))#.count() #[0].try(:attributes)  
  end
  
end

