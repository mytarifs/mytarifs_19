#TODO Уменьшить кол-во страниц и кнопок на которых используется ajax
#TODO Добавить регионы и бизнес при операциях с логированием и пользователями
#TODO Проверить использование тяжелых фильтров вроде как в звонках
#TODO Подготовить основную простую статистику
#TODO Проверить старые задачи (в этом файле)
#TODO Фильты и рекламу для статей
#TODO Проверить KPI метрики
#TODO Убрать показ тарифов (или сделать редирект) если не совпадает бизнес или для частников
#TODO Добавить каноникал для страниц пагинации
#TODO Убрать текст на страницах кроме первой на страницах с пагинацей
#TODO Добавить номер страницы пагинации на списка тарифов по операторам
#TODO Добавить keywords
#TODO Проверить вертикальный фильт - active record в сравнении тарифов
#TODO 
#TODO 
#TODO 
#TODO 
#TODO 
#TODO Добавить проверку правильности выбора рейтинга и быстрого подбора для конкретного id и произвольных регионов
#TODO добавить согласие пользователя на обработку данных
#TODO 
#TODO 
#TODO 
#TODO Исправить тарифы в регионах для которых рейтинг показывает в проверке неправильное количество call_id_count
#TODO Мегафон не определяется как оператор (а если определяется, то смс не определяет)
#TODO Где то в тарифах подключение 10 ГБ за 70 рублей - проверить (МТС коннект)
#TODO Добавить privacy в детальный расчет тарифов и результаты подбора
#TODO 
#TODO 
#TODO При специальном подборе тарифа администратором не правильно задается accouning_period in result_run 
#TODO 
#TODO На странице результатов для пользователей не показывается статистика звонков 
#TODO Исправить параметры пагинации в TarifHelper for business and service_categories
#TODO 
#TODO проверить почему http://mytarifs.ru/tarif_classes/vsya_rossiya_smart/ не переходит на мтс (на описании тарифа)
#TODO  в описании тарифов не всегда правильно работает фильтры для опций - не показываются данные 
#TODO 
#TODO Добавить новые регионы в БД
#TODO add own_home_regions to RegionFiltrs in Service::CategoryTarifClassPresenter и исправить случай, когда домашняя сеть превышает домашний регион
#TODO 
#TODO Проверить расчет тарифа для фиксированного набора опций 
#TODO 
#TODO 
#TODO 
#TODO Упростить сравнение тарифов так же как и страницы тарифов 
#TODO Добавить линейки опций и тарифов в одном описании тарифов
#TODO Убрать дублирующую опция Интернет-планшет XS в Мегафоне
#TODO Добавить опций в быстрый подбор (особенно те, которые не надо считать)

#TODO Проверить что все сервисы id integer in tarif export and when tarif change
#TODO Добавить неделю в параметры задания тарифов (window over) 
#TODO Доработать редактирование тарифов - автоматизировать введение зависимых опций, добавление Прочих стран

#TODO Переделать всю почту на доменную
#TODO Добавить однокласников (логин гугле, яндекс)
#TODO Исправить меню, которое остается открытым после клика и переводы мышки на другой пункт меню
#TODO Убрать style
#TODO 
#TODO Исправить сравнении в рейтингах - что показывать
#TODO Убрать предварительную обработку файла при загрузке 
#TODO сделать везде selected_service_categories
#TODO Обновлять дату пересчета в call_runs
#TODO Объединить calls_stat_array из Result::CallStat и Customer::CallRun

 
#TODO 
#TODO Придумать название компании и сайта (взять симки ВЯ)
#TODO 
#TODO Проработать вопрос по рассылкам (почта, смс, закупка трафика) для привлечения клиентов
#TODO Проработать вопрос по закупке рекламе в яндексе
#TODO 
#TODO Добавить сравнение результатов с действующим тарифом
#TODO 
#TODO 
#TODO 
#TODO 
#TODO 
#TODO Исключить Крым из пакетов интернета для Теле2 http://msk.tele2.ru/about/press/news/2016/09/informacionnoe-soobshenie-dlya-fizicheskih-lic-i-biznes-abonentov/
#TODO Обновить опции МТС с пакетами интернета 20 октября - http://www.spb.mts.ru/news/2016-10-08-5413841/  и http://www.mts.ru/news/2016-10-08-5413809/
#TODO Добавить корпоративную опцию для безлимитного тарифа http://www.content-review.com/articles/37403/
#TODO Добавить корпоративные опции Мегафона для международного роуминга, которых нет у физлиц http://moscow.megafon.ru/corporate/mobile/roaming/world/
#TODO Обновить тарифы Мегафон http://corp.megafon.ru/press/news/moscow/20160909-1743.html
#TODO Добавить опцию МТС Интернет 4 Мбит/с http://www.mts.ru/mobil_inet_and_tv/tarifu/internet_dly_odnogo/additionally_services_comp/internet_4_mbps/
#TODO Добавить для всех роуминг в Крыму и Севастополе
#TODO Добавить для Теле2 опцию В Крыму как дома http://msk.tele2.ru/roaming/skidki/crimea/
#TODO Добавить опцию Мегафона МегаБезлимит http://moscow.megafon.ru/internet/options/megabezlimit.html
#TODO Добавить тариф МТС Смарт для своих http://www.mobile-networks.ru/assets/files/smart-dlya-svoih-2.pdf
#TODO         http://www.mobile-networks.ru/news/201606/mts_smart_dlya_svoix_obnovlen.html?utm_source=feedburner&utm_medium=email&utm_campaign=Feed%3A+mobile-networks%2FGMZB+%28«Мобильные+сети»+-+новости%2C+статьи%2C+обзоры%29
#TODO Добавить новой опции Мегафон «В Абхазии как дома» http://www.content-review.com/articles/35839/
#TODO Добавить Мегафон Безлимитная Италия http://www.content-review.com/articles/35925/

#TODO Добавить выбор оператора в workflow (детальном подборе и быстром подборе)
#TODO Добавить тариф МТС Отличный (в архиве http://static01.mts.ru/uploadmsk/contents/1686/otlichnij_msk_110216.pdf)
#TODO Добавить тариф МТС Умное устройство (http://static02.mts.ru/uploadmsk/contents/1686/smart_device_msk_180216.pdf)
#TODO Убрать для гостя сообщение, что сообщим результаты по почте
#TODO Проверить цены для интернета Оранжевый (группировка по направлению неправильная)


#TODO ПОСТОЯННЫЕ 
#TODO Обновить сайтмап

#TODO ПРИОРИТЕТНЫЕ 
#TODO 
#TODO Добавить название страницы откуда написали письмо, добавить цель отправка письма
#TODO Предложить клиентам услуги (у которых есть детализации или моделирование) переодический пересчет лучшего тарифа в обмен на инфор
#TODO Добавить почтовую рассылку клиентам с новостями
#TODO Добавить сравнение тарифа и Добавить возможность включения тарифа в список сравнения на странице тарифа
#TODO 
#TODO Переделать страницу с результатами подбора
#TODO Переделать письмо с результатами подбора
#TODO Добавить загрузку детализации вместо
#TODO Добавить автозагрузку детализации из кабинета по паролю от пользователя
#TODO Добавить ограничения на применимость тарифов и опций
#TODO Добавить доступность общих опций (вроде гудка) и их описание

#TODO Задать наводящие вопросы для выбора рекомендаций
#TODO Добавить опросник (анкету, профиль) после запуска подбора тарифа
#TODO Добавить рекомендации после подбора тарифа
#TODO Добавить рекомендацию пользователям отказаться от прямого номера (МТС) как возможность экономии на основании детализации

#TODO ЗАДАЧИ ПО ПРОДВИЖЕНИЮ ОТ ДЕМИЗ
#TODO Разместить преимущества компании на сайте в видном месте (under header or above footer)
#TODO Проверить цели в метрике
#TODO Увеличить количество страниц для тарифов (для отдельных регионов)
#TODO Добавить раздел Новости
#TODO Добавить инструкцию пользования сайтам в разделе Сервисы сайта
#TODO Добавить возможность голосования
#TODO Разместить слоган
#TODO Добавить в форме регистрации кнопку показать/скрыть пароль вместо  повторного ввода
#TODO 

#TODO 
#TODO ДОРАБОТКА САЙТА ТЕКУЩЕЙ ВЕРВИИ САЙТА
#TODO Добавить автовыбор описания подбора тарифа, если пустой на простой форме
#TODO 
#TODO Сброс фильторов (тарифы)
#TODO Добавить  short_name for ratings
#TODO 
#TODO Синхронизация корзин рейтингов и начальных параметров для моделирования
#TODO Добавить выбор региона
#TODO 
#TODO 


#TODO АДМИН
#TODO Ограничить доступ к чужим расчетам
#TODO Уведомления об ошибке админа
#TODO Добавить базовую статистку по сайту (кол-во пользователей, загрузок, моделирований и подборов)
#TODO 
#TODO 
#TODO 

#TODO ПРОЧЕЕ 
#TODO Проверить тарифы в других странах
#TODO Перенести загрузку на AWS
#TODO Подумать вернуть ахой




    
#TODO Глобальные задач
#TODO Добавить в глобальные категории to_own_operator and to_other_operators instead of to_operators
#TODO Доработать алгортим для равномерного учета затрат объемов, когда они ограничены и есть несколько категорий
#TODO Доработать алгоритм или поменять глобальную категорию для ммс в России
#TODO добавить анализ чувствительности (исходя из известных ключевых точках тарифов)
#TODO Добавить возможность расчета парсинга и моделирования через delayed_job

#TODO Определиться когда считать опции с лимитами (пока сделал все опции безлимитными, что на самом деле ускорило расчеты tarif_results)
#TODO Добавить многомесячный расчет (во время парсинга объединяешь результаты)    
#TODO Добавить генерацию модели поведения на основе многомесячной детализации

#TODO Улучшающие задачи по работе сайта

#TODO Разобраться все-таки как зависить потребление памяти от использование переменных (где (в контроллере или хелпере))(как влияет обнуление таких переменных)
#TODO добавить удаление звонков из БД после расчета тарифов или их перенос в архивную таблицу

#TODO Улучшающие задачи по оптимизации тарифов
#TODO Добавить поиск всех наборов тарифов которые близки к оптимальному (повторный расчет с изменной оценкой потенциально лучшего тарифа на какой-то процент)    
#TODO Добавить учет возможности отключения сервисов с ненулевым подключением и ненулевым ежедневным платежом которые подключаются при первом использовании (as everywhere_as_home)
#TODO Оценить влияние количества записей в customer_calls на скорость расчетов



#TODO Менее приоритетные
#TODO Добавить ввод и расчет цен регионов
#TODO Придумать как разделить development and production calculation engine
#TODO Перевести как можно больше вычислений в БД
#TODO Проверить как старый алгоритм будет считать с учетом новых подходов

#TODO Учет сколько пользователей рассчитывают тариф
#TODO Учет сколько пользователей online
#TODO Разработать workflow для различных процессов

  