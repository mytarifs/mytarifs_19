Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

module Customer::Call::Init
  CommonParams = {
    "country_id"=>1100, 
    "region_id"=> ::Category::Region::Const::Moskva, 
#    "operator_id"=>1030, 
    "privacy_id"=>2, 
    :own_region=> {
#      "phone_usage_type_id"=>201, 
      "roumin_country_id" => 1100,
      "rouming_region_id"=> ::Category::Region::Const::Moskva,
      "region_for_region_calls_ids"=> ::Category::Region::Const::Sankt_peterburg, #1255, 
      "country_for_international_calls_ids"=> Category::Country::Const::Frantsiya, #1786
    },  
    :home_region=> {
#      "phone_usage_type_id"=>211, 
      "roumin_country_id" => 1100,
      "rouming_region_id"=> 1127,
    }, 
    :own_country=>{
#      "phone_usage_type_id"=>221, 
      "roumin_country_id" => 1100,
      "rouming_region_id"=> Category::Region::Const::Sankt_peterburg, #1255,
    }, 
    :abroad=>{
#      "phone_usage_type_id"=>234, 
      "continent_id"=>1591, 
      "roumin_country_id"=> Category::Country::Const::Frantsiya, #1786,
    } 
  }

end

