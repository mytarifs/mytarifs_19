module Content::ArticlesHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::SessionInitializers

  def content_article_form_for_table
    params[:id] = (params[:current_id].try(:[], 'article_id') || session[:current_id].try(:[], 'article_id')).try(:to_i)
    model = if params[:id]
      params[:id] = params[:id].try(:to_i)
      Content::Article.respond_to?(:friendly) ? 
        Content::Article.friendly.find(params[:id]) : 
        Content::Article.find(params[:id])        
    else
      Content::Article.new
    end
    create_formable(model)    
  end
  
  def articles_select
    create_filtrable("articles_select")
  end
  
  def check_articles_select_before_filtr
    raise(StandardError) if false
    if params['articles_select_filtr']
      params['articles_select_filtr']['status_id'] = nil if params['articles_select_filtr']['status_id'].blank?
      params['articles_select_filtr']['type_id'] = nil if params['articles_select_filtr']['type_id'].blank?
      params['articles_select_filtr']['slug'] = nil if params['articles_select_filtr']['slug'].blank?
      
      if params['key']
        params['articles_select_filtr']['key']['operator_id'] = nil if params['articles_select_filtr']['key']['operator_id'].blank?
        params['articles_select_filtr']['key']['m_region'] = nil if params['articles_select_filtr']['key']['m_region'].blank?
      end
    end
    puts
    puts
    puts params['articles_select_filtr']
    puts
  end

  def content_articles
    filtr = session_filtr_params(articles_select)

    select_tarif_classes = "content_articles.*, tarif_classes.name as tarif_name, tarif_classes.features->>'region_txt' as tarif_region_txt"

    joins_tarif_classes = "left join tarif_classes on (tarif_classes.id)::text = (key->>'tarif_id')"

    where_hash = ['true']
    where_hash << "(key->>'operator_id')::integer = #{filtr['key']['operator_id']}" if !filtr["key"].try(:[], "operator_id").blank?
    where_hash << "(content->>'is_noindex') = '#{filtr['content']['is_noindex']}'" if !filtr["content"].try(:[], "is_noindex").blank?
    
    where_hash << "tarif_classes.standard_service_id = #{filtr['standard_service_id']}" if !filtr["standard_service_id"].blank?
    if !filtr["region_txt"].blank?
      if filtr["region_txt"] == 'no_region'
        where_hash << "nullif(tarif_classes.features#>>'{region_txt}', '[]') is null"
      else
        where_hash << "tarif_classes.features->>'region_txt' = '#{filtr['region_txt']}'"
      end
    end     

    if !filtr["key"].try(:[], "m_region").blank?
      if filtr["key"].try(:[], "m_region") == 'no_region'
        where_hash << "(key->>'m_region') is null"
      else
        where_hash << "(key->>'m_region') = '#{filtr['key']['m_region']}'"
      end
    end     
    
    model = Content::Article.includes(:author).
      select(select_tarif_classes).joins(joins_tarif_classes).
      query_from_filtr(filtr.except('content', 'key')).where(where_hash.join(" and "))
       
    options = {:base_name => 'content_articles', :current_id_name => 'article_id', :id_name => 'id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 10)}    
    create_tableable(model, options)
  end

  def mobile_articles
    options = {:base_name => 'content_articles', :current_id_name => 'article_id', :id_name => 'id', :pagination_per_page => 25}
    model = Content::Article.includes(:author).published.general_articles.order("id desc")    
    create_tableable(model, options)
  end
  
  def mobile_article
    @mobile_article ||= Content::Article.friendly.find(params[:id])
  end

end
