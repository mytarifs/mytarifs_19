@tc = TarifCreator.new(Category::Operator::Const::Megafon)
@tc.create_tarif_class({
  :id => _mgf_bit_mega_pro_500, :name => 'БИТ MegaPRO 500', :operator_id => Category::Operator::Const::Megafon, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://moscow.megafon.ru/internet/options/bit_megafonpro.html',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :incompatibility => {
#      :add_speed_mgf_internet_24 => [_mgf_internet_24, _mgf_add_speed_1gb, _mgf_add_speed_5gb,
#        _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
      :mgf_internet_24 => [_mgf_internet_24, _mgf_internet_xs, _mgf_internet_s, _mgf_internet_m, _mgf_internet_l, _mgf_internet_xl, 
      _mgf_internet_24_pro, _mgf_bit_pro, _mgf_bit_mega_pro_150, _mgf_bit_mega_pro_250, _mgf_bit_mega_pro_500],
      }, 
    :general_priority => _gp_tarif_option_without_limits,#_gp_tarif_option_with_limits,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [_mgf_all_included_xs, _mgf_all_included_s, _mgf_all_included_m, _mgf_all_included_l, _mgf_all_included_vip, 
      _mgf_sub_moscow, _mgf_around_world, _mgf_international, _mgf_city_connection, ],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :is_archived => true,
    :multiple_use => false
  } } )
  

#Добавление новых service_category_group
#internet included in tarif
scg_mgf_bit_mega_pro_500 = @tc.add_service_category_group(
    {:name => 'scg_mgf_bit_mega_pro_500' }, 
    {:name => "price for scg_mgf_bit_mega_pro_500"}, 
    {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,  
      :formula => {:params => {:max_sum_volume => 500.0, :price => 29.0}, :window_over => 'day' } } )


#Own and home regions, Internet
  category = {:uniq_service_category => 'own_and_home_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_bit_mega_pro_500[:id])

#Own country, Internet
  category = {:uniq_service_category => 'own_country_regions/internet',}
  @tc.add_grouped_service_category_tarif_class(category, scg_mgf_bit_mega_pro_500[:id])


@tc.add_tarif_class_categories

#Ограничение максимальной скорости до 64 кбит/с снимается ежедневно с началом новых суток.
#Для того чтобы пользоваться опцией «БИТ PRO», «БИТ MegaPro 150» и «БИТ MegaPro 250» в поездках по России, подключите опцию «Интернет по России».
#Опции доступны для подключения на тарифах линеек «Все мобильные», «Вызов», «Гибкий», «Домашний», «МегаФон – Все включено», «Нон-Стоп», «О`Хард», «Первый Федеральный», «Подмосковный», «Приём», «Свобода слова», «Студенческий», «Тариф», «Твоё время», «Твоя сеть», «Тёплый приём 2009», а также на тарифах «5+», «FIX», «FiXL», «Безлимитный», «Безлимитный 3», «Безлимитный Премиум», «Болельщик», «Вокруг света», «Дневник.ру», «Единый», «За Три», «Классический», «Коммуникатор», «Контакт», «Международный», «Мобильный», «Ноль по области», «О`Лайт», «Один к одному!», «Переходи на ноль 2012», «Просто», «Ринг-Динг», «Рублевый», «Своя сеть», «Связь городов», «Смешарики», «УльтраЛАЙТ», «ФиксЛАЙТ».
