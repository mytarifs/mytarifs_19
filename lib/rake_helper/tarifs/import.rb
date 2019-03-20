module RakeHelper::Tarifs
  module Import
    def self.import_tarif_description(privacy_m)
      clean_db_from_tarif_desciption_records(privacy_m)
      
      path_to_import_from = RakeHelper::Tarifs::General.tarif_description_path(privacy_m)
      Dir[Rails.root.join("#{path_to_import_from}/*.rb")].sort.each { |f| require f }
      
      RakeHelper::Tarifs::General.update_standart_formulas
    end
    
    def self.clean_db_from_tarif_desciption_records(privacy_m)
      tarif_class_ids = RakeHelper::Tarifs::General.tarif_class_ids_from_privacy(privacy_m)
      service_category_group_ids = Service::CategoryGroup.where(:tarif_class_id => tarif_class_ids).pluck(:id)
      price_list_ids = PriceList.where(:service_category_group_id => service_category_group_ids).pluck(:id)
      
      TarifClass.where(:id => tarif_class_ids).delete_all
      Service::CategoryGroup.where(:id => service_category_group_ids).delete_all
      Service::CategoryTarifClass.where(:as_standard_category_group_id => service_category_group_ids).delete_all
      PriceList.where(:id => price_list_ids).delete_all
      Price::Formula.where(:price_list_id => price_list_ids).delete_all
    end
    
  end
end  