# == Schema Information
#
# Table name: service_categories
#
#  id        :integer          not null, primary key
#  name      :string
#  type_id   :integer
#  parent_id :integer
#  level     :integer
#  path      :integer          default([]), is an Array
#

class Service::Category < ActiveRecord::Base
  include WhereHelper, PgArrayHelper
  extend BatchInsert

  belongs_to :type, :class_name =>'Category', :foreign_key => :type_id
  belongs_to :parent, :class_name =>'Service::Category', :foreign_key => :parent_id
  belongs_to :parent_call, :class_name =>'Service::Category', :foreign_key => :parent_id
  has_many :children, :class_name =>'Service::Category', :foreign_key => :parent_id
  has_many :criteria, :class_name =>'Service::Criterium', :foreign_key => :service_category_id
  
  ID = {
    'onetime' => {
      201 => "Одноразовые платежи",
      202 => "Подключение тарифа",
    },
    'periodic' => {
      280 => "Периодические платежи",
      281 => "Ежемесячные платежи",
      282 => "Ежедневные платежи",
    }
  }

  def children
    Service::Category.where('path && ARRAY[?]', id)
  end  
  
end

