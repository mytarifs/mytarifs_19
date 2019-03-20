require 'sidekiq/web' #if ENV["RAILS_ENV"] == "development"
Rails.application.routes.draw do
  get 'index.html', to: redirect('home/index'), status: 301   
  get 'index.php', to: redirect('home/index'), status: 301

  get '*path', 
    to: redirect{|path_params, req| "#{req.path}/" + (req.query_string.blank? ? '' : "?#{req.query_string}")}, 
    status: 301, 
    constraints: lambda {|req| !(req.original_fullpath.split('?').first =~ /facebook|vk|vkontakte/) and req.original_fullpath.split('?').first =~ /[^\/]$/ }
  
  match "/404/" => "errors#error404", via: [ :get, :post, :patch, :delete ]
  match "/422/" => "errors#error422", via: [ :get, :post, :patch, :delete ]
  match "/500/" => "errors#error500", via: [ :get, :post, :patch, :delete ]
  
  devise_for :users, 
    controllers: { sessions: "users/sessions", registrations: "users/registrations", confirmations: "users/confirmations"},
    path_names: { sign_in: 'login', sign_out: 'logout'}

  devise_scope :user do
    patch "/confirm" => "confirmations#confirm"

    get "login" => "users/sessions#new"
    post "submit_login" => "users/sessions#create"
    get "logout" => "users/sessions#destroy"

  end
  
#  user_type == :guest ? (root 'home#index') : (root "comparison/optimizations/2")
#  get '/' => 'comparison/optimizations#index', :constraints => lambda { |request| request.env['warden'].authenticated? }
#  root :to => 'comparison/optimizations#choose_your_tarif_from_ratings'  

  get "/", :controller => "home", :action => 'index'

  scope "(:m_privacy)", :m_privacy => /#{Category::Privacies.keys.join('|')}/, defaults: {m_privacy: nil} do
    scope "(:m_region)", :m_region => /#{Category.mobile_regions_with_scope(['tarif_description']).keys.join('|')}/, defaults: {m_region: nil} do
      root :to => 'home#index'
    end
  end

  resources :users

  get "/auth/:action/callback/", :controller => "users/authentications", :constraints => { :action => /facebook|vk|vkontakte/ }
  get "/auth/:action/callback", :controller => "users/authentications", :constraints => { :action => /facebook|vk|vkontakte/ }
  
  scope "(:m_privacy)", :m_privacy => /#{Category::Privacies.keys.join('|')}/, defaults: {m_privacy: nil} do
    scope "(:m_region)", :m_region => /#{Category.mobile_regions_with_scope(['tarif_description']).keys.join('|')}/, defaults: {m_region: nil} do
      controller :tarif_classes do
        get 'tarif_classes/:operator_id', action: :by_operator, as: :tarif_classes_by_operator, 
          :constraints => lambda { |request| Category::Operator.where(:slug => request.path_parameters[:operator_id]).first }
        get 'tarif_classes/:operator_id/:id', action: :show_by_operator, as: :tarif_class_by_operator, 
          :constraints => lambda { |request| Category::Operator.where(:slug => request.path_parameters[:operator_id]).first }
        get 'tarif_classes/mass_edit', action: :mass_edit_tarif_classes, as: :mass_edit_tarif_classes
        get 'tarif_classes/parsed_tarif_lists', action: :parsed_tarif_lists, as: :parsed_tarif_lists
        get 'tarif_classes/admin/:id', action: :admin_tarif_class, as: :admin_tarif_class
        get 'tarif_classes/unlimited_tarifs', action: :unlimited_tarif_classes, as: :unlimited_tarif_classes
        get 'tarif_classes/unlimited_tarifs/:id', action: :unlimited_tarif_class, as: :unlimited_tarif_class
  
        get 'tarif_classes/bez_abonentskoi_platy', action: :pay_as_go_tarif_classes, as: :pay_as_go_tarif_classes
        get 'tarif_classes/dlya_plansheta', action: :planshet_tarif_classes, as: :planshet_tarif_classes
        get 'tarif_classes/poezdki_po_miru', action: :international_rouming_tarif_classes, as: :international_rouming_tarif_classes
        get 'tarif_classes/poezdki_po_rossii', action: :country_rouming_tarif_classes, as: :country_rouming_tarif_classes
        get 'tarif_classes/zvonki_v_drugie_strany', action: :international_calls_tarif_classes, as: :international_calls_tarif_classes
        get 'tarif_classes/zvonki_v_drugie_regiony', action: :country_calls_tarif_classes, as: :country_calls_tarif_classes
        get 'tarif_classes/business', action: :business_tarif_classes, as: :business_tarif_classes
  #      get 'tarif_classes/unlimited_internet_tarifs', action: :unlimited_internet_tarif_classes, as: :unlimited_internet_tarif_classes
  #      get 'tarif_classes/dlya_plansheta_bez_abonentki', action: :planshet_pay_as_go_tarif_classes, as: :planshet_pay_as_go_tarif_classes
  #      get 'tarif_classes/dlya_plansheta_bezlimitnyi', action: :planshet_unlimited_tarif_classes, as: :planshet_unlimited_tarif_classes
  #      get 'tarif_classes/internet_dlya_plansheta_bez_abonentki', action: :planshet_pay_as_go_internet_tarif_classes, as: :planshet_pay_as_go_internet_tarif_classes
  #      get 'tarif_classes/internet_dlya_plansheta_bezlimitnyi', action: :planshet_unlimited_internet_tarif_classes, as: :planshet_unlimited_internet_tarif_classes
  
        get 'tarif_classes/compare_tarifs', to: redirect('sravnenie_tarifov'), as: :compare_tarifs_old_0
        get 'sravnenie_tarifov', action: :compare_tarifs, as: :compare_tarifs
        get 'sravnenie_tarifov/:operator_id', action: :compare_tarifs_by_operator, as: :compare_tarifs_by_operator, 
          :constraints => lambda { |request| Category::Operator.where(:slug => request.path_parameters[:operator_id]).first }
        get 'sravnenie_tarifov/:name', action: :compare_tarifs_for_planshet, as: :compare_tarifs_for_planshet, 
          :constraints => lambda { |request| request.path_parameters[:name] == 'dlya_plansheta' }
  
        get 'tarif_classes/copy/:id', action: :copy, as: :copy_tarif_class
        get 'tarif_classes/change_status/:id', action: :change_status, as: :change_status_tarif_class
        get 'tarif_classes/ocenit_stoimost_tarifa', action: :estimate_cost, as: :estimate_cost_tarif_class
      end
      resources :tarif_classes do
        namespace :service do
          controller :category_groups do
            get 'category_groups/add', action: :add, as: :add_category_group
            get 'category_groups/:id/copy', action: :copy, as: :copy_category_group
          end
          controller :category_tarif_classes do
            get 'category_tarif_classes/:id/copy', action: :copy, as: :copy_category_tarif_class
          end
        end
      end
      namespace :service do
        resources :category_groups, only: [:destroy, :edit]
        resources :category_tarif_classes, only: [:show, :edit, :update, :destroy]
      end
      
      resources :price_lists do
        namespace :price do
          controller :formulas do
            get 'formulas/add', action: :add, as: :add_formula
            get 'formulas/:id/copy', action: :copy, as: :copy_formula
          end
          resources :formulas, only: [:index, :show, :edit, :update, :destroy]
        end    
      end
      namespace :price do
        resources :formulas, only: [:update]
      end    
  
    end

  end
  

  scope "(:m_privacy)", :m_privacy => /#{Category::Privacies.keys.join('|')}/, defaults: {m_privacy: nil} do
    scope "(:m_region)", :m_region => /#{Category.mobile_regions_with_scope(['tarif_description']).keys.join('|')}/, defaults: {m_region: nil} do

      controller :home do
        post 'home/mobile_region', action: :set_mobile_region, as: :home_set_mobile_region
        get 'home/mobile_region', action: :choose_mobile_region, as: :home_choose_mobile_region
        get 'home/change_locale', action: :change_locale, as: :change_locale
    #    get 'home/introduction', action: :introduction, as: :introduction
        get 'home/short_description' => :short_description
        get 'home/detailed_description', to: redirect('podrobnoe_opisanie_podbora_optimalnogo_tarifa'), as: :home_detailed_description_old_0
        get 'podrobnoe_opisanie_podbora_optimalnogo_tarifa', action: :detailed_description, as: :home_detailed_description
        get 'home/update_tabs' => :update_tabs
        get 'home/news', to: redirect('novosti'), as: :home_news_old_0    
        get 'novosti', action: :news, as: :home_news    
        get 'home/sitemap', to: redirect('sitemap'), as: :home_sitemap_old_0    
        get 'sitemap', action: :sitemap, as: :home_sitemap   
        get 'home/contacts', to: redirect('kontakty'), as: :home_contacts_old_0    
        get 'kontakty', action: :contacts, as: :home_contacts    
        get 'home/tarif_description', action: :tarif_description, as: :tarif_description    
        get 'home/introduction_after_first_calculations', to: redirect('opisanie_servisov_saita'), as: :introduction_after_first_calculations_old_0  
        get 'opisanie_servisov_saita', action: :introduction_after_first_calculations, as: :introduction_after_first_calculations    
        get 'home/search', action: :search, as: :search    
        get 'home/welcome/:id', action: :welcome, as: :home_welcome    
        get 'home/send_service_introduction', action: :send_service_introduction, as: :home_send_service_introduction  
        get 'check/:id', action: :check_phone, as: :home_check_phone  
        get 'home/index', to: redirect(''), as: :index  
#        get 'home/index', action: :index, as: :index  
      end
    
      namespace :content do
        resources :articles
      end
      get 'content/questions_and_answers', controller: "content/articles", to: redirect('voprosy_i_otvety'), as: :content_questions_and_answers_old_0
      get 'voprosy_i_otvety', controller: "content/articles", action: :questions_and_answers, as: :content_questions_and_answers
      get 'content/mobile_articles', controller: "content/articles", to: redirect('statii'), as: :content_mobile_articles_old_0
      get 'statii', controller: "content/articles", action: :mobile_articles, as: :content_mobile_articles
      get 'content/mobile_articles/:id', controller: "content/articles", to: redirect('statii/%{id}'), as: :content_mobile_article_old_0
      get 'statii/:id', controller: "content/articles", action: :mobile_article, as: :content_mobile_article


      namespace :comparison do
        controller :optimizations do
          get 'optimizations/:operator_id', action: :by_operator, as: :optimizations_by_operator, 
            :constraints => lambda { |request| Category::Operator.where(:slug => request.path_parameters[:operator_id]).first }
          get 'optimizations/:operator_id/:id', action: :show_by_operator, as: :optimization_by_operator, 
            :constraints => lambda { |request| Category::Operator.where(:slug => request.path_parameters[:operator_id]).first }
          get 'optimizations/:name', action: :unlimited_rating, as: :unlimited_rating, 
            :constraints => lambda { |request| request.path_parameters[:name] == 'reiting_bezlimitnyh_tarifov' }
          get 'optimizations/:name', action: :unlimited_rating_for_internet, as: :unlimited_rating_for_internet, 
            :constraints => lambda { |request| request.path_parameters[:name] == 'reiting_bezlimitnyh_tarifov_i_optsii_dlya_interneta' }
        end
        resources :optimizations
        controller :optimizations do 
          get 'set_calculate_ratings_options', action: :set_calculate_ratings_options, as: :set_calculate_ratings_options
          get 'calculate_ratings', action: :calculate_ratings, as: :calculate_ratings
          get 'choose_your_tarif_from_ratings', action: :choose_your_tarif_from_ratings, as: :choose_your_tarif_from_ratings
#          get 'choose_your_tarif_from_ratings', to: redirect(''), as: :choose_your_tarif_from_ratings
          get 'optimizations/call_stat/:id', action: :call_stat, as: :call_stat
        end
    
        controller :fast_optimizations do
          get 'fast_optimizations', to: redirect('podbor_tarifov'), as: :fast_optimizations_old_0
          get 'fast_optimizations/calculation_start', action: :calculation_start, as: :fast_optimizations_calculation_start
          get 'fast_optimizations/calculate/:method', action: :calculate, as: :fast_optimizations_calculate
        end
      end    
      get 'podbor_tarifov', controller: "comparison/fast_optimizations", action: :index, as: :comparison_fast_optimizations 
      get 'podbor_tarifov/:operator_id', controller: "comparison/fast_optimizations", action: :index_by_operator, as: :comparison_fast_optimizations_by_operator, 
            :constraints => lambda { |request| Category::Operator.where(:slug => request.path_parameters[:operator_id]).first }
      get 'podbor_tarifov/:name', controller: "comparison/fast_optimizations", action: :index_for_planshet, as: :comparison_fast_optimizations_for_planshet, 
            :constraints => lambda { |request| request.path_parameters[:name] == 'dlya_plansheta' }
    
      namespace :result do
        resources :runs
        controller :runs do
          get 'detailed_calculations/new', action: :new_calculation, as: :detailed_calculations_new
          get 'detailed_calculations/:id/edit', action: :edit_calculation, as: :detailed_calculations_edit
          patch 'detailed_calculations/:id/update', action: :update_calculation, as: :detailed_calculations_update
          get 'detailed_calculations/:id/select_calls', action: :select_calls, as: :detailed_calculations_select_calls
          post 'detailed_calculations/:id/upload_calls', action: :upload_calls, as: :detailed_calculations_upload_calls
          get 'detailed_calculations/:id/calls_parsing_calculation_status', action: :calls_parsing_calculation_status, as: :detailed_calculations_calls_parsing_calculation_status
          get 'detailed_calculations/:id/generate_calls', action: :generate_calls, as: :detailed_calculations_generate_calls
          get 'detailed_calculations/:id/send_calls_by_mail', action: :send_calls_by_mail, as: :detailed_calculations_send_calls_by_mail
          get 'detailed_calculations/:id/accounting_period_select', action: :accounting_period_select, as: :detailed_calculations_accounting_period_select
          get 'detailed_calculations/:id/optimization_select', action: :optimization_select, as: :detailed_calculations_optimization_select
          get 'detailed_calculations/:id/optimization_options', action: :optimization_options, as: :detailed_calculations_optimization_options
          get 'detailed_calculations/:id/prepare', action: :prepare_calculation, as: :detailed_calculations_prepare
          get 'detailed_calculations/:id/calculate', action: :calculate, as: :detailed_calculations_calculate
          get 'detailed_calculations/:id/calculation_status', action: :calculation_status, as: :detailed_calculations_calculation_status
          get 'detailed_calculations/new_simple_calculation', action: :new_simple_calculation, as: :detailed_calculations_new_simple_calculation
          get 'detailed_calculations/:id/choose_your_tarif_with_our_help', action: :choose_your_tarif_with_our_help, as: :detailed_calculations_choose_your_tarif_with_our_help
          get 'detailed_calculations/:id/generate_calls_from_simple_form', action: :generate_calls_from_simple_form, as: :detailed_calculations_generate_calls_from_simple_form
        end
    
        controller :service_sets do
          get 'service_sets/results' => :results
          get 'service_sets/result/:result_run_id', action: :result, as: :service_sets_result
          get 'service_sets/detailed_results/:result_run_id', action: :detailed_results, as: :service_sets_detailed_results
          get 'service_sets/compare/:result_run_id', action: :compare, as: :compare
          get 'service_sets/report/:result_run_id', action: :report, as: :service_sets_report
        end
      end
    
      namespace :customer do
        resources :demands, only: [:index, :create]   
        controller :demands do
          get 'demands/application_for_tele2_nmp', action: :application_for_tele2_nmp, as: :demands_application_for_tele2_nmp
          post 'demands/apply_for_tele2_nmp', action: :apply_for_tele2_nmp, as: :demands_apply_for_tele2_nmp
        end
         
        controller :optimization_results do
          get 'optimization_results/show_additional_info' => :show_additional_info
        end
        
        resources :services, only: [:index] do
          get 'calculate_statistic', on: :collection
        end   
        
        resources :call_runs
        controller :call_runs do
          get 'call_runs/call_stat/:id', action: :call_stat, as: :call_stat
          get 'call_runs/calculate_call_stat/:id', action: :calculate_call_stat, as: :calculate_call_stat
          get 'call_runs/:id/calls_as_json', action: :calls_as_json, as: :call_runs_calls_as_json
        end
    
        controller :calls do
          get 'calls/' => :index
          get 'calls/choose_your_tarif_with_our_help' => :choose_your_tarif_with_our_help
          get 'calls/generate_calls_from_simple_form' => :generate_calls_from_simple_form
          get 'calls/set_calls_generation_params' => :set_calls_generation_params
          get 'calls/set_default_calls_generation_params' => :set_default_calls_generation_params
          get 'calls/generate_calls' => :generate_calls
        end
    
        controller :history_parsers do
          get 'history_parsers/prepare_for_upload' => :prepare_for_upload
          post 'history_parsers/upload' => :upload
          get 'history_parsers/upload' => :upload
          get 'history_parsers/parse' => :parse
          get 'history_parsers/calculation_status' => :calculation_status
        end
    
        resource :payments, except: [:new]
        
        controller :payments do
    #      get 'payments/' => :new
    #      post 'payments/' => :create
          get 'payments/wait_for_payment_being_processed' => :wait_for_payment_being_processed
          post 'payments/process_payment' => :process_payment
        end
      end
      get 'customer/payments/new', controller: "customer/payments", to: redirect('oplata'), as: :new_customer_payments_old_0    
      get 'oplata', controller: "customer/payments", action: :new, as: :new_customer_payments   
      get 'customer/demands/new', controller: "customer/demands", to: redirect('obratnaya_svyaz'), as: :new_customer_demand_old_0    
      get 'obratnaya_svyaz', controller: "customer/demands", action: :new, as: :new_customer_demand
    
      namespace :price do
        resources :formulas, only: [:index]    
        resources :standard_formulas, only: [:index]    
      end


    end
  end
  

  
  namespace :tarif_optimizators do
    controller :admin do
      get 'admin/index' => :index
      get 'admin/recalculate' => :recalculate
      get 'admin/calculation_status' => :calculation_status
      get 'admin/select_services' => :select_services
      get 'admin/recalculate_new' => :recalculate_new
    end   

  end
  
  
  controller :tarif_lists do
    get 'scrap', action: :scrap, as: :scrap_tarif_lists
    resources :tarif_lists, only: [:destroy]
  end

  namespace :cpanet do
    controller :websites do
      get 'websites/synchronize', action: :synchronize, as: :synchronize_websites
    end
    resources :websites, only: [:index]

    controller :my_offers do
      get 'my_offers/synchronize', action: :synchronize, as: :synchronize_my_offers
      get 'my_offers/synchronize_offers', action: :synchronize_offers, as: :synchronize_offers
      get 'my_offers/synchronize_catalogs', action: :synchronize_catalogs, as: :synchronize_catalogs
    end
    
    resources :my_offers
    
    resources :my_offers, only: [:index] do
      resources :programs, only: [:index, :new, :create], module: 'my_offers'
    end

    resources :programs, only: [:show, :edit, :update, :destroy], module: 'my_offers' do
      controller :items, module: 'programs' do
        get 'items/load_deeplinks_from_catalog', action: :items_load_deeplinks_from_catalog, as: :items_load_deeplinks_from_catalog
      end
      resources :items, only: [:index, :new, :create], module: 'programs'
    end
    
    scope :my_offers, module: 'my_offers' do
      scope :programs, as: 'programs', module: 'programs' do
        resources :items, only: [:show, :edit, :update, :destroy]
      end
    end

  end

=begin
  namespace :service do
    resources :category_groups#, only: [:index] 
    resources :categories, only: [:index] do
      resources :criteria, only: [:index]
    end
#    get 'categories/' => 'categories#index'    
  end
=end
    
  authenticate :user, lambda { |u| u.name == "admin" } do
    mount MyWebSidekiq => '/sidekiq'
  end

  #api
  namespace :api do
    namespace :v1 do
      resources :fast_optimizations, only: [:index]
      controller :fast_optimizations do
        get 'fast_optimizations/input_params', action: :input_params, as: :fast_optimizations_input_params
        get 'fast_optimizations/test', action: :test, as: :fast_optimizations_test
      end
    end
  end  
#  resources :tarif_lists, :price_lists  
#  resources :parameters, only: :index
#  resources :categories, only: :index
  

#  controller :sessions do
#    get 'login' => :new
#    post 'submit_login' => :create
#    get 'logout' => :destroy
#    get 'new_location' => :new_location
#    get 'set_new_location' => :choose_location
#  end

#for testing
#  get "formable_concerns/", :controller => 'formable_concerns', :action => :new, :as => "formable_concerns/new"     

#  get "users/new_1", :controller => 'users', :action => :new, :as => "new/users" #for testing     

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
