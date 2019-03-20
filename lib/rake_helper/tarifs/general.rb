module RakeHelper::Tarifs
  module General
    def self.tarif_description_path(privacy_m)
        "db/seeds/autoload/tarif_description/#{privacy_m}"
    end
    
    def self.check_env_and_return_privacy_ids
      abort "PRIVACY_M value, #{[ENV['PRIVACY_M']]} is wrong" if !ENV['PRIVACY_M'].blank? and !Category::Privacies.keys.include?(ENV['PRIVACY_M'])
      result = ENV['PRIVACY_M'].blank? ? Category::Privacies.keys : [ENV['PRIVACY_M']]
      result += ['no_privacy']
    end
  
    def self.check_env_and_return_region_txts(scope = [])
      abort "REGION_TXT value, #{[ENV['REGION_TXT']]} is wrong" if !ENV['REGION_TXT'].blank? and !Category.mobile_regions_with_scope(scope).keys.include?(ENV['REGION_TXT'])
      result = ENV['REGION_TXT'].blank? ? Category.mobile_regions_with_scope(scope).keys : [ENV['REGION_TXT']]
      result += ['no_region']
    end
    
    def self.tarif_class_ids_from_privacy(privacy_m)
      privacy_id = (privacy_m == 'no_privacy' ? nil : Category::Privacies[privacy_m]['id'])
      
      TarifClass.where(:privacy_id => privacy_id).pluck(:id)
    end
    
    def self.update_standart_formulas
      Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }
      Dir[Rails.root.join("db/seeds/price/standard_formulas.rb")].sort.each { |f| require f }
    end

  end
end  