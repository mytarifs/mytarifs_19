class Cpanet::MyOffer::Program < ActiveRecord::Base
  belongs_to :my_offer, :class_name =>'Cpanet::MyOffer', :foreign_key => :my_offer_id
  has_many :items, :class_name =>'Cpanet::MyOffer::Program::Item', :foreign_key => :program_id, :dependent => :destroy

  store_accessor :features, :page, :stat_id, :page_param_filtr, :page_id_filtr, :source_type, :source_filtr, 
                 :place_type, :place, :place_view_type, :place_view_params,
                 :catalog, 
                 :catalog_category_path, :catalog_category_path_text, :catalog_category_id_name, :catalog_category_id_name_text,
                 :catalog_offer_category_name, :catalog_offer_category_name_text, :catalog_offer_path, :catalog_offer_path_text,
                 :catalog_offer_name, :catalog_offer_name_text, :catalog_offer_url_name, :catalog_offer_url_name_text,
                 :catalog_category_values, :catalog_offer_values, :catalog_offers, :catalog_test_path

end

