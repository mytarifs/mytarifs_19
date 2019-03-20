# == Schema Information
#
# Table name: customer_demands
#
#  id             :integer          not null, primary key
#  customer_id    :integer
#  type_id        :integer
#  info           :json
#  status_id      :integer
#  responsible_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Customer::Demand < ActiveRecord::Base

  belongs_to :customer, :class_name =>'User', :foreign_key => :customer_id
  belongs_to :type, :class_name =>'::Category', :foreign_key => :type_id
  belongs_to :status, :class_name =>'::Category', :foreign_key => :status_id
  belongs_to :responsible, :class_name =>'User', :foreign_key => :responsible_id
  
  validates :info, :customer_id, presence: true
  validates_each :type_id do |record, attr, value|
    record.errors[:base] << 'Тип сообщения не может быть пустым' if value.blank?
  end
  
  validates_each :info do |record, attr, value|
    record.errors[:base] << 'Тема сообщения не может быть пустым' if value and value["title"].blank?
    record.errors[:base] << 'Тело сообщения не может быть пустым' if value and value["message"].blank?
    record.errors[:base] << 'Тело сообщения должно содержать не менее 5 слов' if value and !value["message"].blank? and value["message"].split(' ').size < 5
    record.errors[:base] << 'Тело сообщения должно содержать не более 1000 слов' if value and !value["message"].blank? and value["message"].split(' ').size > 1000
    record.errors[:base] << 'У вас слишком длинные слова, используйте пробелы' if value and !value["message"].blank? and value["message"].split(' ').map(&:length).max > 20

    if record.type_id.try(:to_i) == 345
      record.errors[:base] << 'Вам необходимо дать согласие на передачу ваших данных в Теле2' if value and (value["constent"].blank? or ![true, "true"].include?(value["constent"]))
      record.errors[:base] << 'Обращение к Вам не может быть пустым' if value and value["name"].blank?
      record.errors[:base] << 'Телефон не может быть пустым' if value and value["phone_number"].blank?
            
      if value and !value["phone_number"].blank?
        digits_only = value["phone_number"].gsub(/[^\d]/, '')
        record.errors[:base] << 'Номер телефона неправильной длины, должно быть 10 цифр' if digits_only.size != 10
      end
    end
  end
end

