module RakeHelper::Ratings
  module Import
    def self.import_ratings_desciptions(m_privacy, region_txt)
      privacy_id = Category::Privacies[m_privacy].try(:[], 'id')
      path_to_import = RakeHelper::Ratings::General.ratings_description_path(m_privacy, region_txt)

      puts [m_privacy, region_txt, privacy_id, path_to_import].to_s
      rating_ids = RatingsDataLoader.original_ids
      optimization_ids = RatingsDataLoader.ids_from_original_ids(rating_ids, m_privacy, region_txt)
      Comparison::Optimization.where(:id => optimization_ids).published.each do |comparison|
        Comparison::Group.where(:optimization_id => comparison.id).each do |comparison_group|
          Comparison::GroupCallRun.where(:comparison_group_id => comparison_group.id).each do |comparison_group_call_run|
            Customer::CallRun.where(:id => comparison_group_call_run.call_run_id).each do |call_run|
  #              Customer::Call.where(:call_run_id => call_run.id).delete_all
            end
          end
          
          Result::Run.where(:comparison_group_id => comparison_group.id).each do |result_run|
            Result::Agregate.where(:run_id => result_run.id).delete_all
            Result::ServiceCategory.where(:run_id => result_run.id).delete_all
            Result::ServiceSet.where(:run_id => result_run.id).delete_all
            Result::Service.where(:run_id => result_run.id).delete_all
            Result::TarifResult.where(:run_id => result_run.id).delete_all
            Result::Tarif.where(:run_id => result_run.id).delete_all
            puts ['delete result_run', comparison.id, comparison_group.id, result_run.id].to_s
          end
        end
      end
      
      Dir[Rails.root.join("#{path_to_import}/*.rb")].sort.each do |f| 
        puts f
        File.foreach(f) do |line|
          eval line
        end
#        require f
      end 
      
    end

  end
end  