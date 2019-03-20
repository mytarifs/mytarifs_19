module RakeHelper::FastOptimization
  module General
    def self.fast_optimization_description_path(privacy_id, region_txt)
      "db/seeds/autoload/comparison/fast_optimization/#{privacy_id}/#{region_txt}"
    end
    
  end
end  