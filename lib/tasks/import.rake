namespace :import do
  desc "import tarif related seeds/autoload/tarif_description/*.rb files to coresponding tables"
  task :tarifs => :environment do
    privacy_ms = RakeHelper::Tarifs::General.check_env_and_return_privacy_ids
    
    privacy_ms.each do |privacy_m|
      RakeHelper::Tarifs::Import.import_tarif_description(privacy_m)
    end
    
    RakeHelper::General.reset_table_ids
  end

  desc "import content related seeds/autoload/content/*.rb files to coresponding tables"
  task :content => :environment do
    Content::Article.delete_all

    Dir[Rails.root.join("db/seeds/autoload/content/*.rb")].sort.each { |f| require f }
    
    RakeHelper::General.reset_table_ids
  end

  desc "import seeds/autoload/comparison/fast_optimization/*.rb to fast_optimization related tables"
  task :fast_optimization => :environment do
    privacy_ms = RakeHelper::Tarifs::General.check_env_and_return_privacy_ids
    region_txts = RakeHelper::Tarifs::General.check_env_and_return_region_txts(['fast_optimization'])
    
    privacy_ms.each do |privacy_m|
      region_txts.each do |region_txt|
        next if FastOptimization::DataLoader::InputRegionData[privacy_m].try(:[], region_txt).blank?
        
        RakeHelper::FastOptimization::Import.import_fast_optimization_desciptions(privacy_m, region_txt)
      end
    end

    RakeHelper::General.reset_table_ids

  end
  
  desc "import seeds/autoload/comparison/ratings/*.rb to comparison_optimization related tables"
  task :ratings => :environment do
    privacy_ms = RakeHelper::Tarifs::General.check_env_and_return_privacy_ids
    region_txts = RakeHelper::Tarifs::General.check_env_and_return_region_txts(['ratings'])
    
    privacy_ms.each do |privacy_m|
      region_txts.each do |region_txt|
        next if RatingsData::RatingPrivacyRegionData[privacy_m].try(:[], region_txt).nil?
        
        RakeHelper::Ratings::Import.import_ratings_desciptions(privacy_m, region_txt)
      end
    end

    RakeHelper::General.reset_table_ids

  end
end