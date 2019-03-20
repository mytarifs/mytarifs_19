# == Schema Information
#
# Table name: customer_call_runs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  source      :integer
#  description :text
#  operator_id :integer
#  init_class  :string
#  init_params :jsonb
#  stat        :jsonb
#

class Customer::CallRun < ActiveRecord::Base
  include WhereHelper
  
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :operator, :class_name =>'::Category', :foreign_key => :operator_id
  has_many :calls, :class_name =>'Customer::Call', :foreign_key => :call_run_id, dependent: :delete_all
  has_many :group_call_runs, :class_name =>'Comparison::GroupCallRun', :foreign_key => :call_run_id

  def full_name
    "#{source_name}: #{name}" + (updated_at ? ", " + (updated_at.try(:to_formatted_s, :short) || "") : "")
  end
  
  def source_name
    self.class.source_names[source] if source
  end
  
  def self.source_names
    ['Моделирование', 'Загрузка детализации', 'Сравнение']
  end
  
  def self.allowed_new_call_run(user_type = :guest)
    {:guest => 3, :trial => 5, :user => 10, :admin => 100000}[user_type]
  end

  def self.min_new_call_run(user_type = :guest)
    {:guest => 1, :trial => 1, :user => 1, :admin => 1}[user_type]
  end
  
  def self.by_privacy_and_region(privacy_id, region_id)
    result = where("true")
    result = result.where("customer_call_runs.init_params->'general'->>'privacy_id' = '#{privacy_id}'") if !privacy_id.blank?
    result = result.where("customer_call_runs.init_params->'general'->>'region_id' = '#{region_id}'") if !region_id.blank?
    result
  end
  
  def self.generate_calls(only_new = true, test = false)
    (only_new ? unloaded_call_runs : all).collect do |call_run|
      call_run.generate_calls(only_new, test)
      call_run.name
    end
  end
  
  def self.generate_group_calls(only_new = true, test = false)
    group_calls = (only_new ? unloaded_call_runs : all)
    return [] if !group_calls.present?

    if test
      group_calls.map(&:id)
    else
      group_calls.first.generate_calls 
      new_call_run_ids = group_calls.map(&:id) - [group_calls.first.id]
      Customer::CallRun.generate_calls_from_one_to_other_operator(group_calls.first.id, new_call_run_ids)
    end
  end
  
  def generate_calls
    return false if !init_params
    calls_generation_params = init_params.symbolize_keys.deep_merge({:general => {"operator_id" => operator_id}})
    user_params = {"call_run_id" => id}
    
    Customer::Call.where(user_params).delete_all

    Calls::Generator.new(calls_generation_params, user_params).generate_calls

    calculate_call_stat
  end
  
  def self.generate_calls_from_one_to_other_operator(base_call_id, new_call_run_ids = [])
    base_call = where(:id => base_call_id).first
    if base_call
      where(:id => new_call_run_ids).each do |new_call_run|
        Customer::Call.where({"call_run_id" => new_call_run.id}).delete_all
        Calls::Generator.generate_calls_from_one_to_other_operator(base_call.operator_id, base_call.id, new_call_run.operator_id, new_call_run.id)
        new_call_run.calculate_call_stat
      end
    end
  end
  
  def self.loaded_call_run_ids
    Customer::Call.where("user_id is null").pluck(:call_run_id).uniq
  end
  
  def self.unloaded_call_runs
#    where("user_id is null").where.not(:id => loaded_call_run_ids)
    joins("left JOIN customer_calls ON customer_calls.call_run_id = customer_call_runs.id").
      where("customer_call_runs.user_id is null").where(:customer_calls => {:id => nil})
  end
  
  def calls_stat_array(group_by = [], accounting_period = nil)
    return [] if stat.blank?
    accounting_period = stat.keys[0] if !(accounting_period and stat.keys.include?(accounting_period))
    privacy_id = init_params.try(:[], 'general').try(:[], 'privacy_id') || 2
    region_txt = init_params.try(:[], 'general').try(:[], 'region_txt') || 'moskva_i_oblast'

    calculate_call_stat if !stat[accounting_period].is_a?(Hash)      
    chosen_stat = stat[accounting_period].try(:[], privacy_id.to_s).try(:[], region_txt)
    
    raise(StandardError, [
      chosen_stat
    ]) if false
    
    return [] if chosen_stat.blank?
    if group_by.blank?
      result = chosen_stat.collect{|row| row if row['count'] > 0}.compact
      result = (false ? result.sort_by{|row| row['order']} : result) || []
      result
    else
      i = 0
      result_hash = {}
      chosen_stat.each do |row|
        name = {}
        call_types = eval(row['call_types'])
#        raise(StandardError, [row['call_types'], call_types, row])
        name['rouming'] = call_types[0] if group_by.include?('rouming')
        name['service'] = call_types[1] if group_by.include?('service')
        name['direction'] = call_types[2] if group_by.include?('direction')
        name['geo'] = call_types[3] if group_by.include?('geo')
        name['operator'] = call_types[4] if group_by.include?('operator')

        name_string = name.keys.collect{|k| name[k] }.compact.join('_') 
        
        result_hash[name_string] ||= name.merge({'name_string' => name_string, 'categ_ids' => [], 'count' => 0, 'sum_duration' => 0.0, 'count_volume' => 0, 'sum_volume' => 0.0})
        result_hash[name_string]['categ_ids'] += (([row['order']] || []) - result_hash[name_string]['categ_ids'])
        result_hash[name_string]['count'] += row['count'] || 0
        result_hash[name_string]['sum_duration'] += row['sum_duration'] || 0.0
        result_hash[name_string]['count_volume'] += row['count_volume'] || 0
        result_hash[name_string]['sum_volume'] += row['sum_volume'] || 0.0
        i += 1
      end
      
      result = []
      result_hash.each {|name, value| result << value if value['count'] > 0.0 }
      true ? result.sort_by!{|item| item['name_string']} : result
    end
  end
  
  def calculate_call_stat
    accounting_periods = Customer::Call.where(:call_run_id => id).pluck("description->>'accounting_period'").uniq
    privacy_id = init_params.try(:[], 'general').try(:[], 'privacy_id') || 2
    region_txt = init_params.try(:[], 'general').try(:[], 'region_txt') || 'moskva_i_oblast'

    options_for_call_stat = {}
    options_for_call_stat[:region_txt] = region_txt
    options_for_call_stat[:privacy_id] = privacy_id

    result_call_stat = {}
    accounting_periods.each do |accounting_period|
      calls = Customer::Call.where("call_run_id = #{id} and description->>'accounting_period' = '#{accounting_period}'")
      call_stat = Optimization::Global::CallStat.new(options_for_call_stat).calculate_calls_stat(calls)
      
      stat = {} if !stat.is_a?(Hash)
      result_call_stat = stat || {}
      result_call_stat[accounting_period] ||= {}
      result_call_stat[accounting_period][privacy_id] ||= {}
      result_call_stat[accounting_period][privacy_id][region_txt] = call_stat
    end
    update_columns(:stat => result_call_stat)
  end

  
end

