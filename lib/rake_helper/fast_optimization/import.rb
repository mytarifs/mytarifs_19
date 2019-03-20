module RakeHelper::FastOptimization
  module Import
    def self.import_fast_optimization_desciptions(privacy_id, region_txt)
      path_to_import = RakeHelper::FastOptimization::General.fast_optimization_description_path(privacy_id, region_txt)

      FastOptimization::DataLoader::InputData.each do |input_key, input|
        optimization_id = FastOptimization::DataLoader::InputRegionData[privacy_id].try(:[], region_txt).try(:[], :optimization_id)
        
        Comparison::Optimization.where(:id => optimization_id).each do |comparison|
          Comparison::Group.where(:optimization_id => comparison.id).each do |comparison_group|
            Comparison::GroupCallRun.where(:comparison_group_id => comparison_group.id).each do |comparison_group_call_run|
              Customer::CallRun.where(:id => comparison_group_call_run.call_run_id).each do |call_run|
  #              Customer::Call.where(:call_run_id => call_run.id).delete_all
              end
            end
            
            Result::Run.where(:comparison_group_id => comparison_group.id).each do |result_run|
              Result::Agregate.where(:run_id => result_run.id).delete_all
              Result::CallStat.where(:run_id => result_run.id).delete_all
              Result::ServiceCategory.where(:run_id => result_run.id).delete_all
              Result::ServiceSet.where(:run_id => result_run.id).delete_all
              Result::Service.where(:run_id => result_run.id).delete_all
              Result::TarifResult.where(:run_id => result_run.id).delete_all
              Result::Tarif.where(:run_id => result_run.id).delete_all
            end
            Result::Run.where(:comparison_group_id => comparison_group.id).delete_all
          end
        end
      end
      
      Dir[Rails.root.join("#{path_to_import}/*.rb")].sort.each { |f| require f }
      

    end

  end
end  