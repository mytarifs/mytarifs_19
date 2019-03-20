module ApplicationHelper::PaginationPage

  def pagination_page_name(pagination_name)
    pagination_page(pagination_name) ? "Страница #{pagination_page(pagination_name)}" : ""
  end
  
  def pagination_page(pagination_name)
    params[:pagination][pagination_name] if params[:pagination] and params[:pagination][pagination_name] and params[:pagination][pagination_name] != "1"
  end
  
  def set_pagination_page_canonical
    if params["pagination"].try(:values).try(:[], 0) == '1'
      params.extract!("pagination")
      view_context.display_meta_tags(canonical: url_for(params)) 
    end
  end
   
end
