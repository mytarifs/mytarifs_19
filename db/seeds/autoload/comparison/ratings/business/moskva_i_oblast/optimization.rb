Comparison::Optimization.find_or_create_by(:id => 506).update(JSON.parse("{\"id\":506,\"name\":\"Базовый рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах собственного и домашнего региона.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":100,\"optimization_type_id\":1,\"slug\":\"bazovyi_reiting_tarifov_sotovoi_svyazi_business_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 50610).update(JSON.parse("{\"id\":50610,\"name\":\"Малая корзина (80 мин звонков, 110 смс)\",\"optimization_id\":506,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 50611).update(JSON.parse("{\"id\":50611,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета)\",\"optimization_id\":506,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 50612).update(JSON.parse("{\"id\":50612,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета)\",\"optimization_id\":506,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 706).update(JSON.parse("{\"id\":706,\"name\":\"Основной рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах России.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":101,\"optimization_type_id\":1,\"slug\":\"osnovnoi_reiting_tarifov_sotovoi_svyazi_business_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 70615).update(JSON.parse("{\"id\":70615,\"name\":\"Малая корзина (80 мин звонков, 110 смс, 10% поездки по России)\",\"optimization_id\":706,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 70616).update(JSON.parse("{\"id\":70616,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета, 10% поездки по России)\",\"optimization_id\":706,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 70617).update(JSON.parse("{\"id\":70617,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета, 10% поездки по России)\",\"optimization_id\":706,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 906).update(JSON.parse("{\"id\":906,\"name\":\"Рейтинг лучших тарифов и опций для интернета при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для различного уровня потребления интернета.         Звонки учтены на минимальном уровне 5 мин в месяц.         Другие мобильные услуги (смс и ммс) не учитывались.         В состав услуг включены услуги только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":200,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_interneta_pri_nahozhdenii_v_sobstvennom_regione_business_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 90620).update(JSON.parse("{\"id\":90620,\"name\":\"Объем потребления интернета 100 Мб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90621).update(JSON.parse("{\"id\":90621,\"name\":\"Объем потребления интернета 300 Мб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90622).update(JSON.parse("{\"id\":90622,\"name\":\"Объем потребления интернета 500 Мб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90623).update(JSON.parse("{\"id\":90623,\"name\":\"Объем потребления интернета 1 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90624).update(JSON.parse("{\"id\":90624,\"name\":\"Объем потребления интернета 2 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90625).update(JSON.parse("{\"id\":90625,\"name\":\"Объем потребления интернета 3 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90626).update(JSON.parse("{\"id\":90626,\"name\":\"Объем потребления интернета 5 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90627).update(JSON.parse("{\"id\":90627,\"name\":\"Объем потребления интернета 10 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90628).update(JSON.parse("{\"id\":90628,\"name\":\"Объем потребления интернета 15 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90629).update(JSON.parse("{\"id\":90629,\"name\":\"Объем потребления интернета 20 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90630).update(JSON.parse("{\"id\":90630,\"name\":\"Объем потребления интернета 30 Гб\",\"optimization_id\":906,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 1306).update(JSON.parse("{\"id\":1306,\"name\":\"Рейтинг лучших тарифов и опций для звонков при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для разного количество минут.         Другие мобильные услуги (интернет, смс и ммс) не учитывались.         В состав услуг включены звонки только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":150,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_zvonkov_pri_nahozhdenii_v_sobstvennom_regione_business_moskva_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 130650).update(JSON.parse("{\"id\":130650,\"name\":\"Общая длительность звонков 120 минут\",\"optimization_id\":1306,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130651).update(JSON.parse("{\"id\":130651,\"name\":\"Общая длительность звонков 300 минут\",\"optimization_id\":1306,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130652).update(JSON.parse("{\"id\":130652,\"name\":\"Общая длительность звонков 600 минут\",\"optimization_id\":1306,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130653).update(JSON.parse("{\"id\":130653,\"name\":\"Общая длительность звонков 1000 минут\",\"optimization_id\":1306,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130654).update(JSON.parse("{\"id\":130654,\"name\":\"Общая длительность звонков 1500 минут\",\"optimization_id\":1306,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130655).update(JSON.parse("{\"id\":130655,\"name\":\"Общая длительность звонков 2000 минут\",\"optimization_id\":1306,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130656).update(JSON.parse("{\"id\":130656,\"name\":\"Общая длительность звонков 3000 минут\",\"optimization_id\":1306,\"result\":null}"))
