@tc = TarifCreator.new(Category::Operator::Const::Tele2)
@tc.create_tarif_class({
  :id => _tele_international_rouming, :name => 'Путешествия по миру', :operator_id => Category::Operator::Const::Tele2, :privacy_id => _person, :standard_service_id => _common_service,
  :features => {:http => 'http://msk.tele2.ru/roaming/abroad/',
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls, _tcgsc_sms],
    :incompatibility => {}, #{group_name => [tarif_class_ids]}
    :general_priority => _gp_common_service,
    :other_tarif_priority => {:lower => [], :higher => []},
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :prerequisites => [],
    :multiple_use => false
  } } )

#SIC, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#SIC, calls, outcoming, to Russia, to all operators
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#SIC, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#SIC, calls, outcoming, to sic
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Теле 2, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#SIC, calls, outcoming, to Europe
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Теле 2, Европа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#SIC, calls, outcoming, to Asia, Africa, Australia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Теле 2, Африка, Азия, Австралия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#SIC, calls, outcoming, to Noth and South America
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Теле 2, Южная и Северная Америка' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#SIC, sms, incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#SIC, sms, outcoming
  category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.0} } })  


#SIC, mms, incoming
  category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#SIC, mms, outcoming
  category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.0} } })  

#SIC, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Страны СНГ Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 25.0} } })




#Europe, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#Europe, calls, outcoming, to Russia, to all operators
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#Europe, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#Europe, calls, outcoming, to sic
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Теле 2, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#Europe, calls, outcoming, to Europe
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Теле 2, Европа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 15.0} } })  

#Europe, calls, outcoming, to Asia, Africa, Australia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Теле 2, Африка, Азия, Австралия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Europe, calls, outcoming, to Noth and South America
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2 , :name => 'Страны Европы Теле 2'}, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Теле 2, Южная и Северная Америка' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Europe, sms, incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Europe, sms, outcoming
  category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.0} } })  


#Europe, mms, incoming
  category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Europe, mms, outcoming
  category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.0} } })  

#Europe, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Страны Европы Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 25.0} } })




#Asia, Africa and Australia, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Asia, Africa and Australia, calls, outcoming, to Russia, to all operators
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Asia, Africa and Australia, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Asia, Africa and Australia, calls, outcoming, to sic
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5 , :name => 'Страны Азии, Африки и Австраии Теле 2'}, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Теле 2, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Asia, Africa and Australia, calls, outcoming, to Europe
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Теле 2, Европа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Asia, Africa and Australia, calls, outcoming, to Asia, Africa, Australia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Теле 2, Африка, Азия, Австралия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 35.0} } })  

#Asia, Africa and Australia, calls, outcoming, to Noth and South America
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Теле 2, Южная и Северная Америка' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#Asia, Africa and Australia, sms, incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Asia, Africa and Australia, sms, outcoming
  category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 12.0} } })  


#Asia, Africa and Australia, mms, incoming
  category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#Asia, Africa and Australia, mms, outcoming
  category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 12.0} } })  

#Asia, Africa and Australia, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Страны Азии, Африки и Австраии Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 50.0} } })



#South and North America, calls, incoming
  category = {:uniq_service_category => 'abroad_countries/calls_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#South and North America, calls, outcoming, to Russia, to all operators
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#South and North America, calls, outcoming, to rouming country
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#South and North America, calls, outcoming, to sic
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_1, :name => 'Теле 2, СНГ' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#South and North America, calls, outcoming, to Europe
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_2, :name => 'Теле 2, Европа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#South and North America, calls, outcoming, to Asia, Africa, Australia
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_5, :name => 'Теле 2, Африка, Азия, Австралия' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  

#South and North America, calls, outcoming, to Noth and South America
  category = {:uniq_service_category => 'abroad_countries/calls_out/to_other_countries', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }, :to_other_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Теле 2, Южная и Северная Америка' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 65.0} } })  


#South and North America, sms, incoming
  category = {:uniq_service_category => 'abroad_countries/sms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#South and North America, sms, outcoming
  category = {:uniq_service_category => 'abroad_countries/sms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 12.0} } })  


#South and North America, mms, incoming
  category = {:uniq_service_category => 'abroad_countries/mms_in', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 0.0} } })  

#South and North America, mms, outcoming
  category = {:uniq_service_category => 'abroad_countries/mms_out', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:standard_formula_id => Price::StandardFormula::Const::PriceByCountVolumeItem, :formula => {:params => {:price => 6.0} } })  

#South and North America, Internet
  category = {:uniq_service_category => 'abroad_countries/internet', 
  :filtr => {:abroad_countries => {:in => Category::Country::Tel::Service_to_tele_international_6, :name => 'Страны Южной и Северной Америки Теле 2' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0,:standard_formula_id => Price::StandardFormula::Const::PriceBySumVolumeMByte, :formula => {:params => {:price => 50.0} } })





@tc.add_tarif_class_categories

