Comparison::Optimization.find_or_create_by(:id => 508).update(JSON.parse("{\"id\":508,\"name\":\"Базовый рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах собственного и домашнего региона.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":100,\"optimization_type_id\":1,\"slug\":\"bazovyi_reiting_tarifov_sotovoi_svyazi_business_krasnoyarsk_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 50810).update(JSON.parse("{\"id\":50810,\"name\":\"Малая корзина (80 мин звонков, 110 смс)\",\"optimization_id\":508,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 50811).update(JSON.parse("{\"id\":50811,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета)\",\"optimization_id\":508,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 50812).update(JSON.parse("{\"id\":50812,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета)\",\"optimization_id\":508,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 708).update(JSON.parse("{\"id\":708,\"name\":\"Основной рейтинг тарифов сотовой связи\",\"description\":\"Рейтинг подготовлен для трех фиксированных наборов мобильных услуг сотовых операторов (корзин): малой, средней и дорогой.        В состав услуг включены услуги только в пределах России.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru         для каждого тарифа и для каждой корзины\",\"publication_status_id\":102,\"publication_order\":101,\"optimization_type_id\":1,\"slug\":\"osnovnoi_reiting_tarifov_sotovoi_svyazi_business_krasnoyarsk_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 1).update(JSON.parse("{\"id\":1,\"name\":\"all_operators_all_tarif_optionss_all_rouming\",\"for_service_categories\":{\"mms\":true,\"internet\":true,\"intern_roming\":true,\"country_roming\":true},\"for_services_by_operator\":[\"international_rouming\",\"country_rouming\",\"mms\",\"sms\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 70815).update(JSON.parse("{\"id\":70815,\"name\":\"Малая корзина (80 мин звонков, 110 смс, 10% поездки по России)\",\"optimization_id\":708,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 70816).update(JSON.parse("{\"id\":70816,\"name\":\"Средняя корзина (400 мин звонков, 240 смс, 1Гб интернета, 10% поездки по России)\",\"optimization_id\":708,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 70817).update(JSON.parse("{\"id\":70817,\"name\":\"Дорогая корзина (1200 мин звонков, 420 смс, 3Гб интернета, 10% поездки по России)\",\"optimization_id\":708,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 908).update(JSON.parse("{\"id\":908,\"name\":\"Рейтинг лучших тарифов и опций для интернета при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для различного уровня потребления интернета.         Звонки учтены на минимальном уровне 5 мин в месяц.         Другие мобильные услуги (смс и ммс) не учитывались.         В состав услуг включены услуги только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":200,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_interneta_pri_nahozhdenii_v_sobstvennom_regione_business_krasnoyarsk_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 90820).update(JSON.parse("{\"id\":90820,\"name\":\"Объем потребления интернета 100 Мб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90821).update(JSON.parse("{\"id\":90821,\"name\":\"Объем потребления интернета 300 Мб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90822).update(JSON.parse("{\"id\":90822,\"name\":\"Объем потребления интернета 500 Мб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90823).update(JSON.parse("{\"id\":90823,\"name\":\"Объем потребления интернета 1 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90824).update(JSON.parse("{\"id\":90824,\"name\":\"Объем потребления интернета 2 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90825).update(JSON.parse("{\"id\":90825,\"name\":\"Объем потребления интернета 3 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90826).update(JSON.parse("{\"id\":90826,\"name\":\"Объем потребления интернета 5 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90827).update(JSON.parse("{\"id\":90827,\"name\":\"Объем потребления интернета 10 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90828).update(JSON.parse("{\"id\":90828,\"name\":\"Объем потребления интернета 15 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90829).update(JSON.parse("{\"id\":90829,\"name\":\"Объем потребления интернета 20 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 90830).update(JSON.parse("{\"id\":90830,\"name\":\"Объем потребления интернета 30 Гб\",\"optimization_id\":908,\"result\":null}"))
Comparison::Optimization.find_or_create_by(:id => 1308).update(JSON.parse("{\"id\":1308,\"name\":\"Рейтинг лучших тарифов и опций для звонков при нахождении в собственном регионе\",\"description\":\"Рейтинг подготовлен для разного количество минут.         Другие мобильные услуги (интернет, смс и ммс) не учитывались.         В состав услуг включены звонки только в пределах региона подключения.  \\n        Стоимость услуг оценивалась с учетом подбора оптимальных тарифных опций по алгоритму www.mytarifs.ru.\",\"publication_status_id\":102,\"publication_order\":150,\"optimization_type_id\":2,\"slug\":\"reiting_luchshih_tarifov_i_optsii_dlya_zvonkov_pri_nahozhdenii_v_sobstvennom_regione_business_krasnoyarsk_i_oblast\"}"))
Comparison::OptimizationType.find_or_create_by(:id => 2).update(JSON.parse("{\"id\":2,\"name\":\"all_operators_all_tarif_optionss_only_internet_own_region\",\"for_service_categories\":{\"mms\":false,\"internet\":true,\"intern_roming\":false,\"country_roming\":false},\"for_services_by_operator\":[\"country_rouming\",\"calls\",\"internet\"]}"))
Comparison::Group.find_or_create_by(:id => 130850).update(JSON.parse("{\"id\":130850,\"name\":\"Общая длительность звонков 120 минут\",\"optimization_id\":1308,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130851).update(JSON.parse("{\"id\":130851,\"name\":\"Общая длительность звонков 300 минут\",\"optimization_id\":1308,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130852).update(JSON.parse("{\"id\":130852,\"name\":\"Общая длительность звонков 600 минут\",\"optimization_id\":1308,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130853).update(JSON.parse("{\"id\":130853,\"name\":\"Общая длительность звонков 1000 минут\",\"optimization_id\":1308,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130854).update(JSON.parse("{\"id\":130854,\"name\":\"Общая длительность звонков 1500 минут\",\"optimization_id\":1308,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130855).update(JSON.parse("{\"id\":130855,\"name\":\"Общая длительность звонков 2000 минут\",\"optimization_id\":1308,\"result\":null}"))
Comparison::Group.find_or_create_by(:id => 130856).update(JSON.parse("{\"id\":130856,\"name\":\"Общая длительность звонков 3000 минут\",\"optimization_id\":1308,\"result\":null}"))