Comparison::Optimization.find_or_create_by(:id => 406).update(JSON.parse("{\"id\":406,\"name\":\"Базовый рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах собственного и домашнего региона.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":100,\"optimization_type_id\":1,\"slug\":\"bazovyi_reiting_tarifov_sotovoi_svyazi_personal_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 40610).update(JSON.parse("{\"id\":40610,\"name\":\"Малая корзина (80 мин звонков, 110 смс)\",\"optimization_id\":406,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 40611).update(JSON.parse("{\"id\":40611,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета)\",\"optimization_id\":406,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 40612).update(JSON.parse("{\"id\":40612,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета)\",\"optimization_id\":406,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 606).update(JSON.parse("{\"id\":606,\"name\":\"Основной рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах России.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":101,\"optimization_type_id\":1,\"slug\":\"osnovnoi_reiting_tarifov_sotovoi_svyazi_personal_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 60615).update(JSON.parse("{\"id\":60615,\"name\":\"Малая корзина (80 мин звонков, 110 смс, 10% поездки по России)\",\"optimization_id\":606,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 60616).update(JSON.parse("{\"id\":60616,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета, 10% поездки по России)\",\"optimization_id\":606,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 60617).update(JSON.parse("{\"id\":60617,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета, 10% поездки по России)\",\"optimization_id\":606,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 806).update(JSON.parse("{\"id\":806,\"name\":\"Рейтинг лучших тарифов и опций для интернета при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для различного уровня потребления интернета.         Звонки учтены на минимальном уровне 5 мин в месяц.         Другие мобильные услуги (смс и ммс) не учитывались.         В состав услуг включены услуги только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":200,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_interneta_pri_nahozhdenii_v_sobstvennom_regione_personal_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 80620).update(JSON.parse("{\"id\":80620,\"name\":\"Объем потребления интернета 100 Мб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80621).update(JSON.parse("{\"id\":80621,\"name\":\"Объем потребления интернета 300 Мб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80622).update(JSON.parse("{\"id\":80622,\"name\":\"Объем потребления интернета 500 Мб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80623).update(JSON.parse("{\"id\":80623,\"name\":\"Объем потребления интернета 1 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80624).update(JSON.parse("{\"id\":80624,\"name\":\"Объем потребления интернета 2 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80625).update(JSON.parse("{\"id\":80625,\"name\":\"Объем потребления интернета 3 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80626).update(JSON.parse("{\"id\":80626,\"name\":\"Объем потребления интернета 5 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80627).update(JSON.parse("{\"id\":80627,\"name\":\"Объем потребления интернета 10 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80628).update(JSON.parse("{\"id\":80628,\"name\":\"Объем потребления интернета 15 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80629).update(JSON.parse("{\"id\":80629,\"name\":\"Объем потребления интернета 20 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 80630).update(JSON.parse("{\"id\":80630,\"name\":\"Объем потребления интернета 30 Гб\",\"optimization_id\":806,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 1206).update(JSON.parse("{\"id\":1206,\"name\":\"Рейтинг лучших тарифов и опций для звонков при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для разного количество минут.         Другие мобильные услуги (интернет, смс и ммс) не учитывались.         В состав услуг включены звонки только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":150,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_zvonkov_pri_nahozhdenii_v_sobstvennom_regione_personal_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 120650).update(JSON.parse("{\"id\":120650,\"name\":\"Общая длительность звонков 120 минут\",\"optimization_id\":1206,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 120651).update(JSON.parse("{\"id\":120651,\"name\":\"Общая длительность звонков 300 минут\",\"optimization_id\":1206,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 120652).update(JSON.parse("{\"id\":120652,\"name\":\"Общая длительность звонков 600 минут\",\"optimization_id\":1206,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 120653).update(JSON.parse("{\"id\":120653,\"name\":\"Общая длительность звонков 1000 минут\",\"optimization_id\":1206,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 120654).update(JSON.parse("{\"id\":120654,\"name\":\"Общая длительность звонков 1500 минут\",\"optimization_id\":1206,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 120655).update(JSON.parse("{\"id\":120655,\"name\":\"Общая длительность звонков 2000 минут\",\"optimization_id\":1206,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 120656).update(JSON.parse("{\"id\":120656,\"name\":\"Общая длительность звонков 3000 минут\",\"optimization_id\":1206,\"result\":null}"))