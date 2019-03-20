module Optimization::Global
  class Base
    region_constans = Category::Region::Const.constants.map{|c| "Category::Region::Const::#{c.to_s}"}
    operator_constans = Category::Operator::Const.constants.map{|c| "Category::Operator::Const::#{c.to_s}"}
    country_constans = Category::Country::Const.constants.map{|c| "Category::Country::Const::#{c.to_s}"} + 
      Category::Country::Bln.constants.map{|c| "Category::Country::Bln::#{c.to_s}"} + 
      Category::Country::Mgf.constants.map{|c| "Category::Country::Mgf::#{c.to_s}"} + 
      Category::Country::Mts.constants.map{|c| "Category::Country::Mts::#{c.to_s}"} + 
      Category::Country::Tel.constants.map{|c| "Category::Country::Tel::#{c.to_s}"}
    chosen_numbers = Category::ChosenPhoneNumber.constants.map{|c| "Category::ChosenPhoneNumber::#{c.to_s}"}
    internet_types = Category::InternetType.constants.map{|c| "Category::InternetType::#{c.to_s}"}
    
    StructureFiltrs = {
      :own_country_regions => region_constans,
      :to_operators => operator_constans,
      :to_other_countries => country_constans,
      :to_own_and_home_regions => region_constans,
      :to_own_country_regions => region_constans,
      :abroad_countries => country_constans,
      :own_and_home_regions => region_constans,
      :to_abroad_countries => country_constans,    
      :to_chosen_numbers => chosen_numbers,   
      :internet => internet_types
    } 
    
  end    
end
