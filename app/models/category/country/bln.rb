module Category::Country::Bln
  c = Category::Country::Const
  m = Category::Country::Mts
  o = Category::Country::Bln


  o::Sic = m::Sic_countries
  o::Other_world = c::World_countries_without_russia - o::Sic
  
  o::International_1 = (m::Sic_countries + [c::Gruziya]).sort
  o::International_2 = (m::Sic_countries + [c::Abhaziya, c::Gruziya, c::Uzhnaya_osetiya]).sort
  o::International_3 = (m::Europe_countries + [c::Turtsiya] + [ c::Ssha, c::Kanada]).sort 
  o::International_4 = c::Noth_america_countries - [ c::Ssha, c::Kanada]
  o::International_5 = []#_asia_countries
  o::International_6 = c::World_countries_without_russia - o::International_2 - o::International_3 - o::International_4 - o::International_5
  o::International_7 = (m::Sic_countries + [c::Abhaziya, c::Gruziya, c::Uzhnaya_osetiya] - [c::Azerbaidzhan, c::Belarus, c::Moldova]).sort
  o::International_8 = m::Sic_countries + [c::Abhaziya, c::Gruziya, c::Uzhnaya_osetiya] - [c::Azerbaidzhan, c::Belarus]
  o::International_9 = [c::Azerbaidzhan, c::Belarus].sort
  o::International_10 = c::Noth_america_countries - [c::Bagamskie_o_va, c::Barbados, c::Kanada, c::Kuba, c::Ssha]
  o::International_12 = [c::Burundi, c::Koreya_severnaya, c::Madagaskar, c::Maldivskie_o_va, c::Papua_novaya_gvineya, c::Seishelskie_o_va, c::Tunis].sort
  o::International_11 = c::World_countries_without_russia - o::International_2 - o::International_3 - o::International_10 - o::International_12
  o::International_13 = c::World_countries_without_russia - o::International_2
  
  o::International_14 = (m::Europe_countries + [c::Turtsiya + c::Kitai + c::Vetnam] + [ c::Ssha, c::Kanada]).sort
  o::International_15 = c::World_countries_without_russia - o::International_14

  o::Welcome_1 = [c::Tadzhikistan]
  o::Welcome_2 = [c::Armeniya, c::Ukraina].sort
  o::Welcome_3 = [c::Kazahstan]
  o::Welcome_4 = [c::Uzbekistan]
  o::Welcome_5 = [c::Turkmenistan, ]
  o::Welcome_6 = [c::Moldova]
  o::Welcome_7 = [c::Belarus, c::Azerbaidzhan].sort
  o::Welcome_8 = [c::Vetnam]
  o::Welcome_9 = [c::Kitai]
  o::Welcome_10 = [c::Indiya, c::Koreya_uzhnaya].sort
  o::Welcome_11 = [c::Turtsiya]
  
  o::Welcome_12 = [c::Kyrgyzstan, ] #3,5 9
  o::Welcome_13 = [c::Gruziya, ] #8 12
  o::Welcome_14 = [c::Abhaziya, c::Uzhnaya_osetiya].sort #12
  
  
  o::My_planet_groups_popular_countries_1 = [c::Egipet, c::Kitai, c::Ssha, c::Tailand, c::Turtsiya].sort
  o::My_planet_groups_1 = (m::Sic_countries + m::Europe_countries + o::My_planet_groups_popular_countries_1).sort
  o::My_planet_groups_2 = c::World_countries_without_russia - o::My_planet_groups_1
  
  o::Calls_to_other_countries_1 = m::Sic_countries - [c::Belarus, c::Azerbaidzhan, c::Moldova]
  o::Calls_to_other_countries_2 = (m::Europe_countries + [c::Turtsiya + c::Kitai] + [ c::Ssha, c::Kanada] + [c::Belarus, c::Azerbaidzhan, c::Moldova]).sort
  o::Calls_to_other_countries_3 = c::World_countries_without_russia - o::Calls_to_other_countries_1 - o::Calls_to_other_countries_2
  
  o::My_planet_groups_popular_countries_2 = [c::Uzhnaya_osetiya, c::Egipet, c::Izrail, c::Indiya, c::Kambodzha, c::Kanada, c::Katar, c::Kitai, c::Kuveit, c::Malaiziya, 
    c::Oae, c::Singapur, c::Ssha, c::Tailand, c::Turtsiya, c::Yaponiya].sort

  o::My_planet_groups_popular_countries_2_new = [c::Egipet, c::Tailand, c::Turtsiya, c::Ssha, c::Kuveit, c::Novaya_zelandiya, c::Gonkong, c::Indoneziya, c::Filippiny,
   c::Shri_lanka, c::Izrail, c::Indiya, c::Kambodzha, c::Kanada, c::Katar, c::Malaiziya, c::Oae, c::Singapur, c::Taivan, c::Yaponiya]

  o::The_best_internet_in_rouming_groups_1 = [c::Abhaziya, c::Armeniya, c::Azerbaidzhan, c::Belarus, c::Gruziya, c::Kazahstan, c::Kyrgyzstan, c::Moldova, 
  c::Tadzhikistan, c::Uzbekistan, c::Ukraina].sort
  o::The_best_internet_in_rouming_groups_2 = (m::Europe_countries + o::My_planet_groups_popular_countries_2_new).sort
  o::The_best_internet_in_rouming_groups_3 = [
    c::Avstraliya, c::Afganistan, c::Bangladesh, c::Boliviya, c::Botsvana, c::Braziliya, c::Burkina_faso, c::Burundi, 
    c::Vetnam, c::Gambiya, c::Gaiana, c::Gana, c::Demokraticheskaya_respublika_kongo, c::Zambiya, c::Kamerun, c::Keniya, c::Kitai, c::Kongo, c::Laos, 
    c::Liberiya, c::Makao, c::Malavi, c::Mali, c::Marokko, c::Mozambik, c::Mongoliya, c::Nigeriya, c::Pakistan, c::Reunon_o_v, c::Palau, c::Paragvai, c::Peru, c::Ruanda, 
    c::Saudovskaya_araviya, c::Svazilend, c::Uganda, c::Urugvai, c::Tsentralno_afrikanskaya_respublika, c::Chad, c::Chili, c::Ekvador, c::Uar, 
    c::Koreya_uzhnaya, c::Bagamskie_o_va, c::Beliz, c::Gaiti, c::Gvatemala, c::Gonduras, c::Meksika, c::Nikaragua, c::Salvador ].sort
    
  o::The_best_internet_in_rouming_groups_4 = c::World_countries_without_russia - o::The_best_internet_in_rouming_groups_1 - o::The_best_internet_in_rouming_groups_2 - o::The_best_internet_in_rouming_groups_3 

  o::My_abroad_countries_1 =  [c::Vetnam, c::Indiya, c::Kanada, c::Kitai, c::Koreya_uzhnaya, c::Ssha].sort
  o::My_abroad_countries_2 = (m::Europe_countries + [c::Turtsiya]).sort
  o::My_abroad_countries_3 = c::World_countries_without_russia - m::Sic_countries - o::My_abroad_countries_1 - o::My_abroad_countries_2


end

