module RakeHelper::FastOptimization
  module Export
    def self.export_fast_optimization_desciptions(privacy_id, region_txt)
      path_to_export = RakeHelper::FastOptimization::General.fast_optimization_description_path(privacy_id, region_txt)
      
      File.open("#{path_to_export}/fast_optimization.rb", 'w+') do |f|
      File.open("#{path_to_export}/call_run.rb", 'w+') do |f_customer_call|
      File.open("#{path_to_export}/result_run.rb", 'w+') do |f_result_run|
      File.open("#{path_to_export}/result_aggregate.rb", 'w+') do |f_result_aggregate|
      File.open("#{path_to_export}/result_call_stat.rb", 'w+') do |f_result_call_stat|
      File.open("#{path_to_export}/result_service_category.rb", 'w+') do |f_result_service_category|
      File.open("#{path_to_export}/result_service_set.rb", 'w+') do |f_result_service_set|
      File.open("#{path_to_export}/result_service.rb", 'w+') do |f_result_service|
      File.open("#{path_to_export}/result_tarif_result.rb", 'w+') do |f_result_tarif_result|
      File.open("#{path_to_export}/result_tarif.rb", 'w+') do |f_result_tarif|
        File.truncate(f, 0)
        File.truncate(f_customer_call, 0)
        File.truncate(f_result_run, 0)
        File.truncate(f_result_aggregate, 0)
        File.truncate(f_result_call_stat, 0)
        File.truncate(f_result_service_category, 0)
        File.truncate(f_result_service_set, 0)
        File.truncate(f_result_service, 0)
        File.truncate(f_result_tarif_result, 0)
        File.truncate(f_result_tarif, 0)
        
        FastOptimization::DataLoader::InputData.each do |input_key, input|
          
          optimization_id = FastOptimization::DataLoader::InputRegionData[privacy_id].try(:[], region_txt).try(:[], :optimization_id)
  
          Comparison::Optimization.where(:id => optimization_id).each do |comparison|
            f.write "Comparison::Optimization.find_or_create_by(:id => #{comparison.id}).update(JSON.parse(#{comparison.to_json(:except => []).inspect}))\n"
  
            Comparison::OptimizationType.where(:id => comparison.optimization_type_id).each do |comparison_type|
              f.write "Comparison::OptimizationType.find_or_create_by(:id => #{comparison_type.id}).update(JSON.parse(#{comparison_type.to_json(:except => []).inspect}))\n"
            end
  
            Comparison::Group.where(:optimization_id => comparison.id).each do |comparison_group|
              f.write "Comparison::Group.find_or_create_by(:id => #{comparison_group.id}).update(JSON.parse(#{comparison_group.to_json(:except => []).inspect}))\n"
              
              Comparison::GroupCallRun.where(:comparison_group_id => comparison_group.id).each do |comparison_group_call_run|
                f.write "Comparison::GroupCallRun.find_or_create_by(:comparison_group_id => #{comparison_group.id}, :call_run_id => #{comparison_group_call_run.call_run_id})\n"
                
                Customer::CallRun.where(:id => comparison_group_call_run.call_run_id).each do |call_run|
                  f.write "Customer::CallRun.find_or_create_by(:id => #{call_run.id}).update(JSON.parse(#{call_run.to_json(:except => [:created_at, :updated_at]).inspect}))\n"
                  
                  Customer::Call.where(:call_run_id => call_run.id).each do |customer_call|
  #                  f_customer_call.write "Customer::Call.create(JSON.parse(#{customer_call.to_json(:except => [:id, :created_at, :updated_at]).inspect}))\n"
                  end
                end
              end
              
              Result::Run.where(:comparison_group_id => comparison_group.id).each do |result_run|
                f_result_run.write "Result::Run.find_or_create_by(:id => #{result_run.id}).update(JSON.parse(#{result_run.to_json(:except => [:created_at, :updated_at]).inspect}))\n"
  
                Result::Agregate.where(:run_id => result_run.id).each do |result_aggregate|
  #                f_result_aggregate.write "Result::Agregate.find_or_create_by(:id => #{result_aggregate.id}).update(JSON.parse(#{result_aggregate.to_json(:except => [:id]).inspect}))\n"
                end
  
                Result::CallStat.where(:run_id => result_run.id).each do |result_call_stat|
  #                f_result_call_stat.write "Result::CallStat.find_or_create_by(:id => #{result_call_stat.id}).update(JSON.parse(#{result_call_stat.to_json(:except => [:id]).inspect}))\n"
                end
  
                Result::ServiceCategory.where(:run_id => result_run.id).each do |result_service_category|
  #                f_result_service_category.write "Result::ServiceCategory.find_or_create_by(:id => #{result_service_category.id}).update(JSON.parse(#{result_service_category.to_json(:except => []).inspect}))\n"
                end
  
                Result::ServiceSet.where(:run_id => result_run.id).each do |result_service_set|
                  f_result_service_set.write "Result::ServiceSet.find_or_create_by(:id => #{result_service_set.id}).update(JSON.parse(#{result_service_set.to_json(:except => [:id]).inspect}))\n"
                end
  
                Result::Service.where(:run_id => result_run.id).each do |result_service|
  #                f_result_service.write "Result::Service.find_or_create_by(:id => #{result_service.id}).update(JSON.parse(#{result_service.to_json(:except => [:id]).inspect}))\n"
                end
  
                Result::TarifResult.where(:run_id => result_run.id).each do |result_tarif_result|
  #                f_result_tarif_result.write "Result::TarifResult.find_or_create_by(:id => #{result_tarif_result.id}).update(JSON.parse(#{result_tarif_result.to_json(:except => [:id]).inspect}))\n"
                end
  
                Result::Tarif.where(:run_id => result_run.id).each do |result_tarif|
  #                f_result_tarif.write "Result::Tarif.find_or_create_by(:id => #{result_tarif.id}).update(JSON.parse(#{result_tarif.to_json(:except => [:id]).inspect}))\n"
                end
              end
            end
          end
        end
  
      end
      end
      end
      end
      end
      end
      end
      end
      end
      end
    end

  end
end  