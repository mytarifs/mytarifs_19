#Исходящие звонки от 11,9 руб.
@tc = TarifCreator.new(Category::Operator::Const::Mts)
@tc.create_tarif_class({
  :id => _mts_outcoming_calls_from_11_9_rur, :name => 'Исходящие звонки от 11,9 руб.', :operator_id => Category::Operator::Const::Mts, :privacy_id => _person, :standard_service_id => _special_service,
  :features => {:http => 'http://www.mts.ru/mob_connect/roaming/i_roaming/discount_roaming/137/',
    :region_txt => "moskva_i_oblast",
    :publication_status => Content::Article::PublishStatus[:published],
    },
  :dependency => {
    :categories => [_tcgsc_calls],
    :incompatibility => {}, 
    :general_priority => _gp_tarif_option,
    :other_tarif_priority => {:lower => [], :higher => []},
    :prerequisites => [],
    :forbidden_tarifs => {:to_switch_on => [], :to_serve => []},
    :multiple_use => false
  } } ) 

#Europe, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'Страны Европы МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#Europe, calls, outcoming, to rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Europe_countries, :name => 'Страны Европы МТС' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#SIC_1, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia',
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_1_countries, :name => 'Страны СНГ МТС 1-я группа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.9} } })

#SIC_1, calls, outcoming, to rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_1_countries, :name => 'Страны СНГ МТС 1-я группа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 11.9} } })

#SIC_2, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_2_countries, :name => 'Страны СНГ МТС 2-я группа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#SIC_2, calls, outcoming, to rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_2_countries, :name => 'Страны СНГ МТС 2-я группа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#SIC_3, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_3_countries, :name => 'Страны СНГ МТС 3-я группа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#SIC_3, calls, outcoming, to rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::Sic_3_countries, :name => 'Страны СНГ МТС 3-я группа' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#Other countries 1, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::From_11_9_option_countries_1, :name => 'Страны МТС 1-я группа 11,9 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })

#Other countries 1, calls, to rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::From_11_9_option_countries_1, :name => 'Страны МТС 1-я группа 11,9 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 19.9} } })
     
#Other countries 2, calls, outcoming, to Russia
category = {:uniq_service_category => 'abroad_countries/calls_out/to_russia', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::From_11_9_option_countries_2, :name => 'Страны МТС 2-я группа 11,9 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 79.9} } })

#Other countries 2, calls, to rouming_country
category = {:uniq_service_category => 'abroad_countries/calls_out/to_rouming_country', 
  :filtr => {:abroad_countries => {:in => Category::Country::Mts::From_11_9_option_countries_2, :name => 'Страны МТС 2-я группа 11,9 руб' }}}
  @tc.add_one_service_category_tarif_class(category, {}, {:calculation_order => 0, :standard_formula_id => Price::StandardFormula::Const::PriceBySumDuration, :formula => {:params => {:price => 79.9} } })
     
@tc.add_tarif_class_categories 

#Тарификация поминутная, начиная с первой секунды вызова.
#Оплата исходящих вызовов с использованием специального кода *137* на телефоны других стран производится по базовым тарифам на услуги международного роуминга.
#Если набор номера осуществляется в обычном формате международных вызовов без использования кода *137* (например, +7916ХХХХХХХ), 
#оплата производится по тарифам на исходящие вызовы в международном роуминге.

#Использование специального кода *137* доступно для подключения абонентам некорпоративных тарифных планов.
#Как позвонить с использованием кода *137*
#Наберите номер вызываемого абонента в формате: *137*код страны и номер абонента#вызов.
#Например, соединение с абонентом МТС или абонентом городской сети города Москвы (телефонный код России 7 (семь)) производится следующим образом: *137*7916ХХХХХХХ#вызов
#*137*7495ХХХХХХХ#вызов
#ПРИМЕР: Для звонка в Москву на номер 7777777, наберите: *137*74957777777# (где 7 – код России, 495 – код Москвы, 7777777 – номер в Москве). 
#Знак «плюс» или другие символы перед кодом страны набирать не надо.
#После отправки команды вы увидите на экране телефона сообщение «Ваш запрос принят. Пожалуйста, ожидайте». 
#Далее вы получите входящий звонок. Ответьте на него и ожидайте соединения с вызываемым абонентом.

#Оплата вызова производится с момента соединения с номером, на который осуществляется звонок.
#Возможность использования кода *137* предоставляется абонентам указанных тарифных планов бесплатно. 
#При переходе на тарифные планы, на которых опция не предоставляется, возможность набора номера с использованием специального кода не предоставляется.

#Для абонента, с которым установлено соединение, оплата вызова производится как для обычного входящего вызова, с учетом места нахождения.

#Соединение можно установить с абонентами мобильных и стационарных сетей России и зарубежных стран. 
#Возможность соединения с абонентами спутниковых систем связи (кроме отдельно указанных) не предоставляется.

#Условия использования предложения
#Если при подключенной опции «Ноль без границ» вы набираете номер абонента, с которым желаете установить соединение, с кодом *137*, 
#то оплата производится по тарифам для вызовов, осуществленных с указанным кодом.
#Если набор номера осуществляется в обычном формате для международных вызовов без использования кода *137* (например, +7916ХХХХХХХ), 
#то оплата производится по тарифам на исходящие вызовы в международном роуминге, при подключенной опции «Ноль без границ» - в соответствии с условиями указанной опции.

#Предложение действительно для абонентов г. Москвы и Московской области.
#Вы сможете воспользоваться предложением в роуминге только при наличии подключенных опций «Международный и национальный роуминг» и «Международный доступ», 
#или опции «Легкий роуминг и международный доступ». Проверить подключение данных опций можно через «Интернет-Помощник», сервис «Мои услуги». 
#При подключенной опции «Легкий роуминг и международный доступ» пользование телефоном возможно в сетях операторов, с которыми у МТС заключено соглашение о CAMEL-роуминге.
