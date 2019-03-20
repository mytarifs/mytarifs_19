class Customer::Call::SimpleForm
  include ActiveModel::Model, ActiveModel::AttributeMethods, ActiveModel::Validations
  
  attr_accessor :operator_id, :region_id, :number_of_day_calls, :duration_of_calls, :number_of_sms_per_day, :internet_trafic_per_month
#  attribute_method_prefix ''
  define_attribute_methods :operator_id, :region_id, :number_of_day_calls, :duration_of_calls, :number_of_sms_per_day, :internet_trafic_per_month
  
  
  def initialize(attributes)
    attributes = self.class.default_values if attributes.blank?
    super
  end  
  
  validates_presence_of :operator_id, :region_id
  validates_numericality_of :number_of_day_calls, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  validates_numericality_of :duration_of_calls, only_integer: false, greater_than: 0.0, less_than_or_equal_to: 60.0
  validates_numericality_of :number_of_sms_per_day, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100
  validates_numericality_of :internet_trafic_per_month, only_integer: false, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 30.0

  def attributes
    [:operator_id, :region_id, :number_of_day_calls, :duration_of_calls, :number_of_sms_per_day, :internet_trafic_per_month]
  end
  
  
  def self.default_values
    {
      :operator_id => 1023,
      :region_id => 1028,
      :number_of_day_calls => 5,
      :duration_of_calls => 2,
      :number_of_sms_per_day => 1,
      :internet_trafic_per_month => 0.2,      
    }
  end
  

end
