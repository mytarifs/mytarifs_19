module RakeHelper::Tarifs
  module Export
    def self.export_tarif_desciptions(privacy_m)
      tarif_class_ids = RakeHelper::Tarifs::General.tarif_class_ids_from_privacy(privacy_m)
      service_category_group_ids = Service::CategoryGroup.where(:tarif_class_id => tarif_class_ids).pluck(:id)
      price_list_ids = PriceList.where(:service_category_group_id => service_category_group_ids).pluck(:id)
      
      TarifClass.where(:id => tarif_class_ids).verify_all_services_in_tarif_description_are_integer
      
      update_service_parts(tarif_class_ids)
      
      path_to_export = RakeHelper::Tarifs::General.tarif_description_path(privacy_m)

      export_tarif_class(tarif_class_ids, path_to_export)
      export_service_category_group(service_category_group_ids, path_to_export)
      export_service_category_tarif_class(service_category_group_ids, path_to_export)
      export_price_list(price_list_ids, path_to_export)
      export_price_formula(price_list_ids, path_to_export)
      
      RakeHelper::Tarifs::General.update_standart_formulas
      
    end
    
    def self.update_service_parts(tarif_class_ids)
      TarifClass.update_service_parts(tarif_class_ids)
      TarifClass.update_support_service_parts(tarif_class_ids)
    end
    
    def self.export_tarif_class(tarif_class_ids, path_to_export)
      File.open("#{path_to_export}/tarif_classes.rb", 'w+') do |f|
        File.truncate(f, 0)
        TarifClass.where(:id => tarif_class_ids).find_each do |row|        
          f.write "TarifClass.find_or_create_by(:id => #{row.id}).update(JSON.parse(#{row.to_json(:except => [:created_at, :updated_at ]).inspect}))\n"
        end
      end
    end
    
    def self.export_service_category_group(service_category_group_ids, path_to_export)
      File.open("#{path_to_export}/service_category_groups.rb", 'w+') do |f|
        File.truncate(f, 0)
        Service::CategoryGroup.where(:id => service_category_group_ids).find_each do |row|        
          f.write "Service::CategoryGroup.find_or_create_by(:id => #{row.id}).update(JSON.parse(#{row.to_json(:except => [:created_at, :updated_at ]).inspect}))\n"
        end
      end
    end

    def self.export_service_category_tarif_class(service_category_group_ids, path_to_export)
      File.open("#{path_to_export}/service_category_tarif_classes.rb", 'w+') do |f|
        File.truncate(f, 0)
        Service::CategoryTarifClass.where(:as_standard_category_group_id => service_category_group_ids).find_each do |row|        
          f.write "Service::CategoryTarifClass.find_or_create_by(:id => #{row.id}).update(JSON.parse(#{row.to_json(:except => [:created_at, :updated_at ]).inspect}))\n"
        end
      end
    end

    def self.export_price_list(price_list_ids, path_to_export)
      File.open("#{path_to_export}/price_lists.rb", 'w+') do |f|
        File.truncate(f, 0)
        PriceList.where(:id => price_list_ids).find_each do |row|        
          f.write "PriceList.find_or_create_by(:id => #{row.id}).update(JSON.parse(#{row.to_json(:except => [:created_at, :updated_at ]).inspect}))\n"
        end
      end
    end

    def self.export_price_formula(price_list_ids, path_to_export)
      File.open("#{path_to_export}/price_formulas.rb", 'w+') do |f|
        File.truncate(f, 0)
        Price::Formula.where(:price_list_id => price_list_ids).find_each do |row|        
          f.write "Price::Formula.find_or_create_by(:id => #{row.id}).update(JSON.parse(#{row.to_json(:except => [:created_at, :updated_at ]).inspect}))\n"
        end
      end      
    end

  end
end  