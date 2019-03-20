#TODO Добавить расширенный международный роуминг (новую категорию стран)
#International rouming
@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_international_rouming, :name => 'Путешествие по миру', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://moscow.megafon.ru/roaming/world/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {},
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } )


#Europe, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#Europe, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#Europe, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#Europe, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Europe, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Europe, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#Europe, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 30.0} } })  

#Europe, mms, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 37.0} } })  

#Europe, mms, outcoming, to sic
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 40.0} } })  

#Europe, mms, outcoming, to europe
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 50.0} } })  

#Europe, mms, outcoming, to other_countries
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Europe_international_rouming, :name => 'Страны Европы Мегафона' }, :to_other_countries => {:in => Category::Country::Mts::Other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 50.0} } })  



#sic, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#sic, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#sic, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 49.0} } })  

#sic, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#sic, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#sic, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#sic, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 35.0} } })  

#sic, mms, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 42.0} } })  

#sic, mms, outcoming, to sic
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'Мегафон, услуги в СНГ, Абхазию, Грузию и Южную Осетию' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 45.0} } })  

#sic, mms, outcoming, to europe
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 55.0} } })  

#sic, mms, outcoming, to other_countries
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Sic_international_rouming, :name => 'Страны СНГ Мегафона' }, :to_other_countries => {:in => Category::Country::Mts::Other_countries, :name => 'Мегафон, услуги в страны кроме СНГ, Абхазии, Грузии и Южной Осетии' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 55.0} } })  



#Other countries, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration,:formula => {:params => {:price => 79.0} } })  

#other_countries, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 79.0} } })  

#other_countries, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 79.0} } })  

#other_countries, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#other_countries, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#other_countries, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#other_countries, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 100.0} } })  

#other_countries, mms, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 107.0} } })  

#other_countries, mms, outcoming, to sic
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 110.0} } })  

#other_countries, mms, outcoming, to europe
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 120.0} } })  

#other_countries, mms, outcoming, to other_countries
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Other_countries_international_rouming, :name => 'Остальные страны Мегафона для международного роуминга' }, :to_other_countries => {:in => Category::Country::Mts::Other_countries, :name => 'МТС, остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 120.0} } })  

#Extended countries, calls, incoming
category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, calls, outcoming, to rouming country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, calls, outcoming, to not rouming country and not Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 129.0} } })  

#Extended countries, sms, incoming
category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Extended countries, sms, outcoming
category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 19.0} } })  

#Extended countries, mms, incoming
category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 140.0} } })  

#Extended countries, mms, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 147.0} } })  

#Extended countries, mms, outcoming, to sic
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }, :to_other_countries => {:in => Category::Country::Mts::Sic_countries, :name => 'услуги в СНГ МТС' }}} 
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 1, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 150.0} } })  

#Extended countries, mms, outcoming, to europe
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }, :to_other_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'услуги в Европу МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 2, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 160.0} } })  

#Extended countries, mms, outcoming, to other_countries
category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mgf::Extended_countries_international_rouming, :name => 'Cтраны Мегафона для расширенного международного роуминга' }, :to_other_countries => {:in => Category::Country::Mts::Other_countries, :name => 'МТС, остальные страны' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 3, :standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 160.0} } })  



@tc.add_tarif_class_categories

