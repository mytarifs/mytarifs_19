@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_add_trafic_5gb, :name => 'Добавить трафика 5Gb', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://msk.tele2.ru/internet/dlya-telefonov/addtraffic/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
      :add_speed_internet_options => [_tele_internet_from_phone, _tele_day_in_net, _tele_add_trafic_3gb, _tele_add_trafic_100mb, _tele_add_trafic_5gb,]
    }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => true
  } } )


#Ежемесячная плата
  @tc.add_one_service_category_tarif_class(_sctcg_periodic_monthly_fee, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByMonth, :formula => {:params => {:price => 0.02} } })

#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_only_service_category_tarif_class(category)  

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_only_service_category_tarif_class(category)  


@tc.add_tarif_class_categories
