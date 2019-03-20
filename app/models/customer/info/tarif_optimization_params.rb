# == Schema Information
#
# Table name: customer_infos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime
#

class Customer::Info::TarifOptimizationParams < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 7)
  end

  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.default_values
    {
      'calculate_on_background' => 'true',
      'calculate_with_multiple_use' => 'true',
      'use_short_tarif_set_name' => 'true',
      'show_zero_tarif_result_by_parts' => 'false',
      'max_tarif_set_count_per_tarif' => 1,
      'calculate_background_with_spawnling' => 'false',
      'max_number_of_tarif_optimization_workers' => 3,
      'clean_cache' => 'false',
      'calculate_with_sidekiq' => 'true', 
      'calculate_performance' => 'false',
    }
  end

end
