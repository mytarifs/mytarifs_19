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

class Customer::Info::General < ActiveType::Record[Customer::Info]
  
  def self.default_scope
    where(:info_type_id => 1)
  end

  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create(:info => default_values).update_columns(:info => values)
  end
  
  def self.default_values
    {
    }
  end


end
