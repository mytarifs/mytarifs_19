Comparison::Optimization.find_or_create_by(:id => 515).update(JSON.parse("{\"id\":515,\"name\":\"Базовый рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах собственного и домашнего региона.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":100,\"optimization_type_id\":1,\"slug\":\"bazovyi_reiting_tarifov_sotovoi_svyazi_business_rostov_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 51510).update(JSON.parse("{\"id\":51510,\"name\":\"Малая корзина (80 мин звонков, 110 смс)\",\"optimization_id\":515,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 51511).update(JSON.parse("{\"id\":51511,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета)\",\"optimization_id\":515,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 51512).update(JSON.parse("{\"id\":51512,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета)\",\"optimization_id\":515,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 715).update(JSON.parse("{\"id\":715,\"name\":\"Основной рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах России.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":101,\"optimization_type_id\":1,\"slug\":\"osnovnoi_reiting_tarifov_sotovoi_svyazi_business_rostov_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 71515).update(JSON.parse("{\"id\":71515,\"name\":\"Малая корзина (80 мин звонков, 110 смс, 10% поездки по России)\",\"optimization_id\":715,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 71516).update(JSON.parse("{\"id\":71516,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета, 10% поездки по России)\",\"optimization_id\":715,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 71517).update(JSON.parse("{\"id\":71517,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета, 10% поездки по России)\",\"optimization_id\":715,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 915).update(JSON.parse("{\"id\":915,\"name\":\"Рейтинг лучших тарифов и опций для интернета при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для различного уровня потребления интернета.         Звонки учтены на минимальном уровне 5 мин в месяц.         Другие мобильные услуги (смс и ммс) не учитывались.         В состав услуг включены услуги только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":200,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_interneta_pri_nahozhdenii_v_sobstvennom_regione_business_rostov_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 91520).update(JSON.parse("{\"id\":91520,\"name\":\"Объем потребления интернета 100 Мб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91521).update(JSON.parse("{\"id\":91521,\"name\":\"Объем потребления интернета 300 Мб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91522).update(JSON.parse("{\"id\":91522,\"name\":\"Объем потребления интернета 500 Мб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91523).update(JSON.parse("{\"id\":91523,\"name\":\"Объем потребления интернета 1 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91524).update(JSON.parse("{\"id\":91524,\"name\":\"Объем потребления интернета 2 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91525).update(JSON.parse("{\"id\":91525,\"name\":\"Объем потребления интернета 3 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91526).update(JSON.parse("{\"id\":91526,\"name\":\"Объем потребления интернета 5 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91527).update(JSON.parse("{\"id\":91527,\"name\":\"Объем потребления интернета 10 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91528).update(JSON.parse("{\"id\":91528,\"name\":\"Объем потребления интернета 15 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91529).update(JSON.parse("{\"id\":91529,\"name\":\"Объем потребления интернета 20 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 91530).update(JSON.parse("{\"id\":91530,\"name\":\"Объем потребления интернета 30 Гб\",\"optimization_id\":915,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 1315).update(JSON.parse("{\"id\":1315,\"name\":\"Рейтинг лучших тарифов и опций для звонков при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для разного количество минут.         Другие мобильные услуги (интернет, смс и ммс) не учитывались.         В состав услуг включены звонки только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":150,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_zvonkov_pri_nahozhdenii_v_sobstvennom_regione_business_rostov_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 131550).update(JSON.parse("{\"id\":131550,\"name\":\"Общая длительность звонков 120 минут\",\"optimization_id\":1315,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 131551).update(JSON.parse("{\"id\":131551,\"name\":\"Общая длительность звонков 300 минут\",\"optimization_id\":1315,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 131552).update(JSON.parse("{\"id\":131552,\"name\":\"Общая длительность звонков 600 минут\",\"optimization_id\":1315,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 131553).update(JSON.parse("{\"id\":131553,\"name\":\"Общая длительность звонков 1000 минут\",\"optimization_id\":1315,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 131554).update(JSON.parse("{\"id\":131554,\"name\":\"Общая длительность звонков 1500 минут\",\"optimization_id\":1315,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 131555).update(JSON.parse("{\"id\":131555,\"name\":\"Общая длительность звонков 2000 минут\",\"optimization_id\":1315,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 131556).update(JSON.parse("{\"id\":131556,\"name\":\"Общая длительность звонков 3000 минут\",\"optimization_id\":1315,\"result\":null}"))
