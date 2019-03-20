# Set the host name for URL creation
# foreman run rake sitemap:refresh:no_ping
SitemapGenerator::Sitemap.default_host = "http://www.mytarifs.ru"
SitemapGenerator::Sitemap.sitemaps_path = ''
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.ping_search_engines("http://www.mytarifs.ru/sitemap.xml")


SitemapGenerator::Sitemap.create do
  extend ApplicationHelper::MobileRegionSetting
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  defaults_params = {:priority => nil, :changefreq => nil, :lastmod => nil}
  
  Category::Privacies.each do |m_privacy, privacy_desc|
    Category.mobile_regions_with_scope(['ratings']).each do |m_region, region_desc|
      
      add comparison_optimizations_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add comparison_choose_your_tarif_from_ratings_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add customer_calls_choose_your_tarif_with_our_help_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params  
      
      rating_ids = RatingsDataLoader.original_ids
      optimization_ids = RatingsDataLoader.ids_from_original_ids(rating_ids, m_privacy, m_region)
      
      Comparison::Optimization.where(:id => optimization_ids).published.find_each do |comparison|
        add comparison_optimization_path(hash_with_region_and_privacy({id: comparison.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
        comparison.groups.each do |group|
          add result_service_sets_result_path(hash_with_region_and_privacy({result_run_id: group.result_run.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
          add result_compare_path(hash_with_region_and_privacy({result_run_id: group.result_run.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
        end
      end
      
      Category::Operator.operators_with_tarifs.find_each do |operator|
        add comparison_optimizations_by_operator_path(hash_with_region_and_privacy({operator_id: operator.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
        Comparison::Optimization.where(:id => optimization_ids).published.find_each do |comparison|
          add comparison_optimization_by_operator_path(hash_with_region_and_privacy({id: comparison.slug, operator_id: operator.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
        end
      end
      add comparison_unlimited_rating_path(hash_with_region_and_privacy({name: 'reiting_bezlimitnyh_tarifov', trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add comparison_unlimited_rating_for_internet_path(
        hash_with_region_and_privacy({name: 'reiting_bezlimitnyh_tarifov_i_optsii_dlya_interneta', trailing_slash: true}, m_privacy, m_region) ), defaults_params
      
      add comparison_fast_optimizations_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      Category::Operator.operators_with_tarifs.find_each do |operator|
        add comparison_fast_optimizations_by_operator_path(
          hash_with_region_and_privacy({:operator_id => operator.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
      end  
      add comparison_fast_optimizations_for_planshet_path(
        hash_with_region_and_privacy({:name => 'dlya_plansheta', trailing_slash: true}, m_privacy, m_region) ), defaults_params
    
      add result_detailed_calculations_new_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
    

      
      add tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      Category::Operator.operators_with_tarifs.find_each do |operator|
        add tarif_classes_by_operator_path(hash_with_region_and_privacy({operator_id: operator.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
      end
    
      TarifClass.service_is_published.where("features is not null").find_each do |tarif_class|
        add tarif_class_path(hash_with_region_and_privacy({id: tarif_class.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
      end
      
      add unlimited_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
    
      add pay_as_go_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add planshet_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add international_rouming_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add country_rouming_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add international_calls_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      add country_calls_tarif_classes_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
    
      add estimate_cost_tarif_class_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
    
      add compare_tarifs_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params
      Category::Operator.operators_with_tarifs.find_each do |operator|
        add compare_tarifs_by_operator_path(hash_with_region_and_privacy({operator_id: operator.slug, trailing_slash: true}, m_privacy, m_region) ), defaults_params
      end  
      add compare_tarifs_for_planshet_path(hash_with_region_and_privacy({name: 'dlya_plansheta', trailing_slash: true}, m_privacy, m_region) ), defaults_params
      
      add home_sitemap_path(hash_with_region_and_privacy({trailing_slash: true}, m_privacy, m_region) ), defaults_params

    end
  end
  

  
  
  add content_mobile_articles_path(trailing_slash: true), defaults_params
  Content::Article.published.general_articles.find_each do |mobile_article|
    add content_mobile_article_path(mobile_article, trailing_slash: true), defaults_params
  end
  add content_questions_and_answers_path(trailing_slash: true), defaults_params
  
  add introduction_after_first_calculations_path(trailing_slash: true), defaults_params
  add home_detailed_description_path(trailing_slash: true), defaults_params
  add home_news_path(trailing_slash: true), defaults_params
  add home_contacts_path(trailing_slash: true), defaults_params
  add new_customer_demand_path(trailing_slash: true), defaults_params
end
