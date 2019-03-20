namespace :export do
  desc "update price_standard_formulas from seed file"
  task :update_price_standard_formulas_from_seed_file => :environment do
    Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

    Dir[Rails.root.join("db/seeds/price/standard_formulas.rb")].sort.each { |f| require f}
  end


  desc "export tarif related tables to coresponding seeds/autoload/tarif_description/ files"
  task :tarifs => :environment do
    privacy_ms = RakeHelper::Tarifs::General.check_env_and_return_privacy_ids
    
    privacy_ms.each do |privacy_m|
      FileUtils.mkdir_p RakeHelper::Tarifs::General.tarif_description_path(privacy_m)
      
      RakeHelper::Tarifs::Export.export_tarif_desciptions(privacy_m)
    end

  end

  desc "export content related tables to coresponding seeds/autoload/content/ files"
  task :content => :environment do
    File.open('db/seeds/autoload/content/articles.rb', 'w+') do |f|
      File.truncate(f, 0)
      Content::Article.find_each do |row|        
        f.write "Content::Article.create(JSON.parse(#{row.to_json(:except => [:created_at, :updated_at ]).inspect}))\n"
      end
    end

  end

  desc "export fast_optimization related tables to seeds/autoload/comparison/fast_optimization/*.rb"
  task :fast_optimization => :environment do
    privacy_ms = RakeHelper::Tarifs::General.check_env_and_return_privacy_ids
    region_txts = RakeHelper::Tarifs::General.check_env_and_return_region_txts(['fast_optimization'])
    
    privacy_ms.each do |privacy_m|
      region_txts.each do |region_txt|
        next if FastOptimization::DataLoader::InputRegionData[privacy_m].try(:[], region_txt).blank?
        
        FileUtils.mkdir_p RakeHelper::FastOptimization::General.fast_optimization_description_path(privacy_m, region_txt)
        
        RakeHelper::FastOptimization::Export.export_fast_optimization_desciptions(privacy_m, region_txt)
      end
    end

  end

  desc "export comparison_optimization related tables to seeds/autoload/comparison/ratings/*.rb"
  task :ratings => :environment do
    privacy_ms = RakeHelper::Tarifs::General.check_env_and_return_privacy_ids
    region_txts = RakeHelper::Tarifs::General.check_env_and_return_region_txts(['ratings'])
    
    privacy_ms.each do |privacy_m|
      region_txts.each do |region_txt|
        next if RatingsData::RatingPrivacyRegionData[privacy_m].try(:[], region_txt).nil?
        
        FileUtils.mkdir_p RakeHelper::Ratings::General.ratings_description_path(privacy_m, region_txt)
        
        RakeHelper::Ratings::Export.export_ratings_desciptions(privacy_m, region_txt)
      end
    end


  end

end