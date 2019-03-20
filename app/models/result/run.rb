# == Schema Information
#
# Table name: result_runs
#
#  id                              :integer          not null, primary key
#  name                            :string
#  description                     :text
#  user_id                         :integer
#  call_run_id                     :integer
#  accounting_period               :string
#  optimization_type_id            :integer
#  run                             :integer
#  optimization_params             :jsonb
#  calculation_choices             :jsonb
#  selected_service_categories     :jsonb
#  services_by_operator            :jsonb
#  temp_value                      :jsonb
#  service_choices                 :jsonb
#  services_select                 :jsonb
#  services_for_calculation_select :jsonb
#  service_categories_select       :jsonb
#  categ_ids                       :jsonb
#  comparison_group_id             :integer
#  slug                :string
#

class Result::Run < ActiveRecord::Base
  include WhereHelper, FriendlyIdHelper #PgJsonHelper
  extend BatchInsert
  
  Result::Run::OptimizationTypes = {
    0 => {:name => 'Все операторы', :optimization_controller => 'tarif_optimizators/main'}, 
    1 => {:name => 'Выбранный тариф', :optimization_controller => 'tarif_optimizators/fixed_services'}, 
    2 => {:name => 'С ограничением услуг', :optimization_controller => 'tarif_optimizators/limited_scope'}, 
    3 => {:name => 'Выбранный оператор', :optimization_controller => 'tarif_optimizators/fixed_operators'},
    4 => {:name => 'Со всеми опциями', :optimization_controller => 'tarif_optimizators/all_options'}, 
    5 => {:name => 'Для администратора', :optimization_controller => 'tarif_optimizators/admin'},
    6 => {:name => 'Для рейтинга', :optimization_controller => 'tarif_optimizators/admin'}
    }
  Result::Run::UserOptimizationTypes = Result::Run::OptimizationTypes.slice(0, 1, 2, 3)
  Result::Run::AdminOptimizationTypes = Result::Run::OptimizationTypes.slice(4, 5)

  friendly_id :slug_candidates, use: [:slugged]#, :finders]

  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :call_run, :class_name =>'Customer::CallRun', :foreign_key => :call_run_id
  belongs_to :comparison_group, :class_name =>'Comparison::Group', :foreign_key => :comparison_group_id
  has_many :agregates, :class_name =>'Result::Agregate', :foreign_key => :run_id, :dependent => :destroy
  has_many :call_stats, :class_name =>'Result::CallStat', :foreign_key => :run_id, :dependent => :destroy
  has_many :service_categories, :class_name =>'Result::ServiceCategory', :foreign_key => :run_id, :dependent => :destroy
  has_many :service_sets, :class_name =>'Result::ServiceSet', :foreign_key => :run_id, :dependent => :destroy
  has_many :services, :class_name =>'Result::Service', :foreign_key => :run_id, :dependent => :destroy
  has_many :tarif_results, :class_name =>'Result::TarifResult', :foreign_key => :run_id, :dependent => :destroy
  has_many :tarifs, :class_name =>'Result::Tarif', :foreign_key => :run_id, :dependent => :destroy

#  serialize :calculation_choices, HashSerializer
#  store_accessor :calculation_choices, :blog, :github, :twitter
  
  def slug_candidates
    [
      :short_name_for_slug,
      [:name_for_slug, :privacy_and_region_from_id],
    ]
  end
  
  def short_name_for_slug
    max_word_in_slug = 20;  excluded_short_word_length = 3;
    result = []
    i = 0
    name_for_slug.split(" ").each do |word|
      result << word
      i += 1 if word.length > excluded_short_word_length
    end if name
    result[0..max_word_in_slug].join(" ")
  end
  
  def privacy_and_region_from_id
    comparison_id = comparison_group.try(:optimization).try(:id)
    if comparison_id
      m_privacy, m_region = RatingsDataLoader.privacy_region_from_id(comparison_id)
      "#{m_privacy}_#{m_region}"
    else
      ""
    end
  end
  
  def name_for_slug
    comparison_group ? "#{comparison_group.optimization.name}, корзина: #{comparison_group.name}" : "#{name} #{id}"
  end

  def full_name
    "#{name}, тип подбора: #{optimization_type}" + (updated_at ? ", обновлен " + (updated_at.try(:to_formatted_s, :short) || "") : "") + 
    (call_run ? ", рассчитан на основании: #{call_run.name}" : "")
  end
  
  def optimization_type
    Result::Run::OptimizationTypes[optimization_type_id][:name] if optimization_type_id
  end

  def self.allowed_new_result_run(user_type = :guest)
    {:guest => 3, :trial => 10, :user => 20, :admin => 100000}[user_type]
  end
  
  def self.allowed_min_result_run(user_type = :guest)
    {:guest => 1, :trial => 1, :user => 1, :admin => 1}[user_type]
  end
  
  def self.by_privacy_and_region(privacy_id, region_id)
    call_run_ids = Customer::CallRun.by_privacy_and_region(privacy_id, region_id).pluck(:id).uniq
    where("(result_runs.calculation_choices#>>'{call_run_id}')::integer in ( #{call_run_ids.join(', ')} )")
  end
  

end

