module RatingsData
#    options_for_comparison = [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet]
  RatingsType = {
    0 => {
      :name => 'all_operators_no_tarif_options_only_own_and_home_regions_rouming', 
      :for_service_categories => {:country_roming => false, :intern_roming => false, :mms => false, :internet => false}, 
      :for_services_by_operator => []
    },
    1 => {
      :name => 'all_operators_all_tarif_optionss_all_rouming', 
      :for_service_categories => {:country_roming => true, :intern_roming => true, :mms => true, :internet => true}, 
      :for_services_by_operator => [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet]
    },
    2 => {
      :name => 'all_operators_all_tarif_optionss_only_internet_own_region', 
      :for_service_categories => {:country_roming => false, :intern_roming => false, :mms => false, :internet => true}, 
      :for_services_by_operator => [:country_rouming, :calls, :internet]
    },
    3 => {
      :name => 'all_operators_all_tarif_optionss_only_internet_own_region_and_own_country', 
      :for_service_categories => {:country_roming => true, :intern_roming => false, :mms => false, :internet => true}, 
      :for_services_by_operator => [:country_rouming, :calls, :internet]
    },
  }
  
  Rating = {
    :test_rating => {
      :id => 0,
      :name => 'base_rank', :description => "all_operators_no_tarif_options_only_own_and_home_regions_rouming", 
      :publication_status_id => 100, :publication_order => 10000, :optimization_type_id => 0,
      :groups => {
        :students => {:id => 0, :name => 'Студенты', :call_init_params => Customer::Call::Init::Student::OwnAndHomeRegionsOnly},
        :pensioneers => {:id => 1, :name => 'Пенсионеры', :call_init_params => Customer::Call::Init::Pensioner::OwnAndHomeRegionsOnly},
      }
    },
    :base_rating => {
      :id => 1,
      :name => 'Базовый рейтинг тарифов сотовой связи', 
      :description => "Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.\
        В состав услуг включены услуги только в пределах собственного и домашнего региона. \ 
        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru \
        для каждого тарифа и для каждой корзины", 
      :publication_status_id => 102, :publication_order => 100, :optimization_type_id => 1,
      :groups => {
        :small_basket => {:id => 10, :name => 'Малая корзина (80 мин звонков, 110 смс)', :call_init_params => Customer::Call::Init::SmallBasket::OwnAndHomeRegionsOnly},
        :middle_basket => {:id => 11, :name => 'Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета)', :call_init_params => Customer::Call::Init::MiddleBasket::OwnAndHomeRegionsOnly},
        :large_basket => {:id => 12, :name => 'Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета)', :call_init_params => Customer::Call::Init::ExpensiveBasket::OwnAndHomeRegionsOnly},
      }
    },
    :main_rating => {
      :id => 2,
      :name => 'Основной рейтинг тарифов сотовой связи', 
      :description => "Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.\
        В состав услуг включены услуги только в пределах России. \ 
        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru \
        для каждого тарифа и для каждой корзины", 
      :publication_status_id => 102, :publication_order => 101, :optimization_type_id => 1,
      :groups => {
        :small_basket => {:id => 15, :name => 'Малая корзина (80 мин звонков, 110 смс, 10% поездки по России)', :call_init_params => Customer::Call::Init::SmallBasket::OwnCountryOnly},
        :middle_basket => {:id => 16, :name => 'Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета, 10% поездки по России)', :call_init_params => Customer::Call::Init::MiddleBasket::OwnCountryOnly},
        :large_basket => {:id => 17, :name => 'Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета, 10% поездки по России)', :call_init_params => Customer::Call::Init::ExpensiveBasket::OwnCountryOnly},
      }
    },
    :best_internet_own_region => {
      :id => 3,
      :name => 'Рейтинг лучших тарифов и опций для интернета при нахождении в собственном регионе', 
      :description => "Рейтинг подготовлен для различного уровня потребления интернета. \
        Звонки учтены на минимальном уровне 5 мин в месяц. \
        Другие мобильные услуги (смс и ммс) не учитывались. \
        В состав услуг включены услуги только в пределах региона подключения. \ 
        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.", 
      :publication_status_id => 102, :publication_order => 200, :optimization_type_id => 2,
      :groups => {
        :mb_100 => {:id => 20, :name => 'Объем потребления интернета 100 Мб', :call_init_params => Customer::Call::Init::Internet::Mb100},
        :mb_300 => {:id => 21, :name => 'Объем потребления интернета 300 Мб', :call_init_params => Customer::Call::Init::Internet::Mb300},
        :mb_500 => {:id => 22, :name => 'Объем потребления интернета 500 Мб', :call_init_params => Customer::Call::Init::Internet::Mb500},
        :mb_1000 => {:id => 23, :name => 'Объем потребления интернета 1 Гб', :call_init_params => Customer::Call::Init::Internet::Mb1000},
        :mb_2000 => {:id => 24, :name => 'Объем потребления интернета 2 Гб', :call_init_params => Customer::Call::Init::Internet::Mb2000},
        :mb_3000 => {:id => 25, :name => 'Объем потребления интернета 3 Гб', :call_init_params => Customer::Call::Init::Internet::Mb3000},
        :mb_5000 => {:id => 26, :name => 'Объем потребления интернета 5 Гб', :call_init_params => Customer::Call::Init::Internet::Mb5000},
        :mb_10000 => {:id => 27, :name => 'Объем потребления интернета 10 Гб', :call_init_params => Customer::Call::Init::Internet::Mb10000},
        :mb_15000 => {:id => 28, :name => 'Объем потребления интернета 15 Гб', :call_init_params => Customer::Call::Init::Internet::Mb15000},
        :mb_20000 => {:id => 29, :name => 'Объем потребления интернета 20 Гб', :call_init_params => Customer::Call::Init::Internet::Mb20000},
        :mb_30000 => {:id => 30, :name => 'Объем потребления интернета 30 Гб', :call_init_params => Customer::Call::Init::Internet::Mb30000},
      }
    },
    :best_internet_russia => {
      :id => 4,
      :name => 'Рейтинг лучших тарифов и опций для интернета при путешествии по России', 
      :description => "Рейтинг подготовлен для различного уровня потребления интернета. \
        Звонки учтены на минимальном уровне 5 мин в месяц. \
        Другие мобильные услуги (смс и ммс) не учитывались. \
        В состав услуг включен интернет только за пределах региона подключения, 100 % по России. \ 
        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.", 
      :publication_status_id => 100, :publication_order => 201, :optimization_type_id => 3,
      :groups => {
        :mb_100 => {:id => 31, :name => 'Объем потребления интернета 100 Мб', :call_init_params => Customer::Call::Init::CountryInternet::Mb100},
        :mb_300 => {:id => 32, :name => 'Объем потребления интернета 300 Мб', :call_init_params => Customer::Call::Init::CountryInternet::Mb300},
        :mb_500 => {:id => 33, :name => 'Объем потребления интернета 500 Мб', :call_init_params => Customer::Call::Init::CountryInternet::Mb500},
        :mb_1000 => {:id => 34, :name => 'Объем потребления интернета 1 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb1000},
        :mb_2000 => {:id => 35, :name => 'Объем потребления интернета 2 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb2000},
        :mb_3000 => {:id => 36, :name => 'Объем потребления интернета 3 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb3000},
        :mb_5000 => {:id => 37, :name => 'Объем потребления интернета 5 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb5000},
        :mb_10000 => {:id => 38, :name => 'Объем потребления интернета 10 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb10000},
        :mb_15000 => {:id => 39, :name => 'Объем потребления интернета 15 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb15000},
        :mb_20000 => {:id => 40, :name => 'Объем потребления интернета 20 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb20000},
        :mb_30000 => {:id => 41, :name => 'Объем потребления интернета 30 Гб', :call_init_params => Customer::Call::Init::CountryInternet::Mb30000},
      }
    },
    :best_calls_own_region => {
      :id => 5,
      :name => 'Рейтинг лучших тарифов и опций для звонков при нахождении в собственном регионе', 
      :description => "Рейтинг подготовлен для разного количество минут. \
        Другие мобильные услуги (интернет, смс и ммс) не учитывались. \
        В состав услуг включены звонки только в пределах региона подключения. \ 
        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.", 
      :publication_status_id => 102, :publication_order => 150, :optimization_type_id => 2,
      :groups => {
        :min_120 => {:id => 50, :name => 'Общая длительность звонков 120 минут', :call_init_params => Customer::Call::Init::Calls::Min120},
        :min_300 => {:id => 51, :name => 'Общая длительность звонков 300 минут', :call_init_params => Customer::Call::Init::Calls::Min300},
        :min_600 => {:id => 52, :name => 'Общая длительность звонков 600 минут', :call_init_params => Customer::Call::Init::Calls::Min600},
        :min_1000 => {:id => 53, :name => 'Общая длительность звонков 1000 минут', :call_init_params => Customer::Call::Init::Calls::Min1000},
        :min_1500 => {:id => 54, :name => 'Общая длительность звонков 1500 минут', :call_init_params => Customer::Call::Init::Calls::Min1500},
        :min_2000 => {:id => 55, :name => 'Общая длительность звонков 2000 минут', :call_init_params => Customer::Call::Init::Calls::Min2000},
        :min_3000 => {:id => 56, :name => 'Общая длительность звонков 3000 минут', :call_init_params => Customer::Call::Init::Calls::Min3000},
      }
    }
  }
  
  RatingOperators = Category::Operator::Const::OperatorsForOptimization

  RatingPrivacyRegionData = {
    'personal' => {
      'khakasia' => {},
      'novosibirsk_i_oblast' => {},
      'krasnoyarsk_i_oblast' => {},
      'alania' => {},
      'moskva_i_oblast' => {},
      'sankt_peterburg_i_oblast' => {},
      'ekaterinburg_i_oblast' => {},
      'nizhnii_novgorod_i_oblast' => {},
      'samara_i_oblast' => {},
      'rostov_i_oblast' => {},
      'krasnodar_i_oblast' => {},
    },
    'business' => {
      'khakasia' => {},
      'novosibirsk_i_oblast' => {},
      'krasnoyarsk_i_oblast' => {},
      'alania' => {},
      'moskva_i_oblast' => {},
      'sankt_peterburg_i_oblast' => {},
      'ekaterinburg_i_oblast' => {},
      'nizhnii_novgorod_i_oblast' => {},
      'samara_i_oblast' => {},
      'rostov_i_oblast' => {},
      'krasnodar_i_oblast' => {},
    }
  }


end

