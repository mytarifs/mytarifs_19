# == Schema Information
#
# Table name: price_standard_formulas
#
#  id             :integer          not null, primary key
#  name           :string
#  formula        :json
#  price_unit_id  :integer
#  volume_id      :integer
#  volume_unit_id :integer
#  description    :text
#  stat_params    :jsonb
#

class Price::StandardFormula < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  belongs_to :price_unit, :class_name =>'::Category', :foreign_key => :price_unit_id
  belongs_to :volume, :class_name =>'::Parameter', :foreign_key => :volume_id
  belongs_to :volume_unit, :class_name =>'::Category', :foreign_key => :volume_unit_id
  has_many :formulas, :class_name =>'Price::Formula', :foreign_key => :standard_formula_id
  

#help functions for seed  
  def self.sum_call_by_minutes_formula_constructor(array_of_minutes = [])
    min_array = []
    array_of_minutes = check_different_minutes_for_sum_call_by_minutes_formula #if array_of_minutes.blank?
    array_of_minutes.map do |min|
      min_array << "'#{min.to_i}'"
      min_array << "sum(case when ceil(((description->>'duration')::float)/60.0) <= #{min.to_f} then ceil(((description->>'duration')::float)/60.0)  else 0.0 end)"
    end 
    "json_build_object(#{min_array.join(', ')})"
  end
  
  def self.count_call_by_minutes_formula_constructor(array_of_minutes = [])
    min_array = []
    array_of_minutes = check_different_minutes_for_sum_call_by_minutes_formula #if array_of_minutes.blank?
    array_of_minutes.map do |min|
      min_array << "'#{min.to_i}'"
      min_array << "sum(case when ceil(((description->>'duration')::float)/60.0) <= #{min.to_f} then 1.0  else 0.0 end)"
    end 
    "json_build_object(#{min_array.join(', ')})"
  end
  
  def self.check_different_minutes_for_sum_call_by_minutes_formula
    Price::Formula.where(:standard_formula_id => [61, 70, 71]).all.map{|r| a = r.formula['params']; [a['duration_minute_1'], a['duration_minute_2']] if a}.flatten.compact.uniq.sort
  end

end
