module RakeHelper::Ratings
  module General
    def self.ratings_description_path(m_privacy, region_txt)
      "db/seeds/autoload/comparison/ratings/#{m_privacy}/#{region_txt}"
    end

  end
end  