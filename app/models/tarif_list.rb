# == Schema Information
#
# Table name: tarif_lists
#
#  id             :integer          not null, primary key
#  name           :string
#  tarif_class_id :integer
#  region_id      :integer
#  features       :json
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class TarifList < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  store_accessor :features, :status, :visited_page_url, :chosen_services, :current_to_scrap_services, :prev_to_scrap_services,
                            :current_scraped_services, :prev_scraped_services, :tarif_list_for_parsing_ids,
                            :current_saved_service_desc, :prev_saved_service_desc

  belongs_to :tarif_class, :class_name =>'TarifClass', :foreign_key => :tarif_class_id
  belongs_to :region, :class_name =>'Category', :foreign_key => :region_id
  has_many :price_lists, :class_name =>'PriceList', :foreign_key => :tarif_list_id


end

