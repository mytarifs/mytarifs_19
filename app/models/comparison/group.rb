# == Schema Information
#
# Table name: comparison_groups
#
#  id              :integer          not null, primary key
#  name            :string
#  optimization_id :integer
#  result          :jsonb
#

class Comparison::Group < ActiveRecord::Base
  store_accessor :result, :variable_call_params

  belongs_to :optimization, :class_name =>'Comparison::Optimization', :foreign_key => :optimization_id
  has_one :result_run, :class_name =>'Result::Run', :foreign_key => :comparison_group_id
  has_many :group_call_runs, :class_name =>'Comparison::GroupCallRun', :foreign_key => :comparison_group_id, dependent: :delete_all
  has_many :call_runs, through: :group_call_runs, dependent: :delete_all
  
  def name_with_rating
    "#{name}, #{optimization.name}"
  end
  

end

