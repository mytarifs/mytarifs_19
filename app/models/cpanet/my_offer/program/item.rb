class Cpanet::MyOffer::Program::Item < ActiveRecord::Base
  belongs_to :program, :class_name =>'Cpanet::MyOffer::Program', :foreign_key => :program_id

  store_accessor :features, :page_item, :page_item_name_for_check, :source, :content_name, :content_desc,
                 :is_for_yandex_rsy, :use_yandex_adaptive_css_class, :rtb_id_small, :rtb_id_middle, :rtb_id_big, :stat_id

end

