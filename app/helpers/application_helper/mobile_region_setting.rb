module ApplicationHelper::MobileRegionSetting
  include SavableInSession::Filtrable, SavableInSession::SessionInitializers
  
  def region_and_privacy_choiser_filtr
    create_filtrable("region_and_privacy_choiser")
  end

#  private
  
  def root_with_region_and_privacy(m_privacy, m_region, hash = {})   
    m_privacy_to_use = m_privacy == 'personal' ? nil : m_privacy
    m_region_to_use = m_region == 'moskva_i_oblast' ? nil : m_region
    root_path(m_privacy_to_use, m_region_to_use, hash)
  end

  def hash_with_region_and_privacy(hash = {}, original_m_privacy = nil, original_m_region = nil)
    m_privacy_use = original_m_privacy ? original_m_privacy : m_privacy
    m_region_use = original_m_region ? original_m_region : m_region
    result = hash || {}
    result = m_privacy_use == 'personal' ? result.merge({:m_privacy => nil}) : result.merge({:m_privacy => m_privacy_use})
    result = m_region_use == 'moskva_i_oblast' ? result.merge({:m_region => nil}) : result.merge({:m_region => m_region_use})
    result
  end

  def hash_with_context_region_and_privacy(context, hash = {})
    result = hash || {}
    result = context.m_privacy == 'personal' ? result.merge({:m_privacy => nil}) : result.merge({:m_privacy => context.m_privacy})
    result = context.m_region == 'moskva_i_oblast' ? result.merge({:m_region => nil}) : result.merge({:m_region => context.m_region})
    result
  end

  def region_and_privacy_tag(original_m_privacy = nil, original_m_region = nil)
    m_privacy_use = original_m_privacy ? original_m_privacy : m_privacy
    m_region_use = original_m_region ? original_m_region : m_region
    result = ""
    result = "для бизнеса" if m_privacy_use != 'personal'
    result = "#{result} #{Category::MobileRegions[m_region_use].try(:[], 'name')}" if m_region_use != 'moskva_i_oblast'
    result
  end

  def m_region
    params['m_region'] || 'moskva_i_oblast' #|| session['mobile_region'] 
  end

  def m_region_id
    Category::MobileRegions[m_region].try(:[], 'region_ids').try(:[], 0) 
  end

  def m_region_name
    Category::MobileRegions[m_region].try(:[], 'name')
  end
  
  def m_privacy
    params['m_privacy'] || 'personal' #|| session['m_privacy'] 
  end

  def m_privacy_id
    Category::Privacies[m_privacy].try(:[], 'id')
  end

  def m_privacy_name
    Category::Privacies[m_privacy].try(:[], 'name')
  end
  
#to use to define local to controllers and show local options in views
  def use_local_m_region_and_m_privacy
    false
  end  

  def show_local_m_region_and_m_privacy_select_views
    false
  end  
  
end
