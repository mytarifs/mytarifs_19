module TarifClassesHelper::TarifClassShowHelper

  def services_with_support_service_filtr
    create_filtrable("services_with_support_service")
  end

  def tarif_class_description_region_filtr
    create_filtrable("tarif_class_description_region")
  end

  def tarif_class_description_support_services_filtr
    create_filtrable("tarif_class_description_support_services")
  end

  def other_tarifs_for_tarif_show
    model = TarifClass.includes(:privacy).where(:id => other_tarif_ids_for_tarif_show)

    options = {:base_name => 'other_tarifs_for_tarif_show', :current_id_name => 'other_tarifs_for_tarif_show_id', :pagination_per_page => 50}
    create_tableable(model, options)
  end

  def other_tarif_ids_for_tarif_show
    base_model = TarifClass.privacy_and_region_where_with_default(m_privacy, m_region).includes(:privacy).
      where(:operator_id => tarif_class.operator_id, :standard_service_id => tarif_class.standard_service_id).
      where("dependency->>'is_archived' != 'true' or (dependency->>'is_archived')::text is null").
      where(service_features_not_blank).for_parsing('false').original_tarif_class
      
    all_other_tarifs = []
    if tarif_class.standard_service_id == TarifClass::ServiceType[:special_service]
      tarif_class_service_categories = TarifClass.where(:id => tarif_class.id).to_service_categories([TarifClass::ServiceType[:special_service]])
      all_service_categories = base_model.to_service_categories([TarifClass::ServiceType[:special_service]])
      (tarif_class_service_categories.keys - [:all_service_types]).each do |service_category|
        tarif_class_service_categories[service_category].keys.each do |service_type|
          all_other_tarifs += all_service_categories[service_category][service_type] if all_service_categories.try(:[], service_category).try(:[], service_type)
        end
      end      
      all_other_tarifs = all_service_categories.values.map{|sc| sc[:all_service_types]}.flatten if (all_other_tarifs - [tarif_class.id]).blank?
    else
      all_other_tarifs = base_model.pluck(:id)
    end
    
    all_other_tarifs.uniq!
    all_other_tarifs.sort!
    
    max_tarif_to_show = [5 + 1, all_other_tarifs.size].min
    
    position_of_current_tarif_class = all_other_tarifs.find_index(tarif_class.id) || 0
              
    all_other_tarifs.rotate!(position_of_current_tarif_class)
    
    all_other_tarifs[1..max_tarif_to_show - 1]
  end

  def tarif_reference_to_operator_site_text
    if tarif_class.http
      tarif_class_name = (tarif_class.try(:name) || "").split(' ').size == 1 ? tarif_class.try(:name) : "«#{tarif_class.try(:name)}»"
      operator_name = tarif_class.try(:operator).try(:name)
      operator_name = tarif_class_name =~ /#{operator_name}/ ? "" : " #{operator_name}"
      full_http = advertise_url || tarif_class.full_http_from_http(m_region, :http)
      link = view_context.link_to("официальном сайте оператора", "#", :class => "external-link", "data-link" => full_http, :target => "", :rel => "nofollow")
      
      text = case tarif_class.try(:standard_service_id)
      when TarifClass::ServiceType[:tarif]
        "Более подробное описание тарифа #{operator_name} #{tarif_class_name} и его стоимости можно узнать на ".html_safe
      when TarifClass::ServiceType[:special_service]
        "Более подробное описание тарифной опции #{operator_name} #{tarif_class_name} и его стоимости можно узнать на ".html_safe
      else
        "Более подробное описание услуги #{operator_name} #{tarif_class_name} и его стоимости можно узнать на ".html_safe
      end      
      (text + link).gsub("TELE2", "ТЕЛЕ2").html_safe
    end
  end
  
  def tarif_class_description
    existing_tarif_class_description = Content::Article.tarif_description.
      where("(key->>'tarif_id')::integer = ?", tarif_class.id).
      where("( (key->>'m_region')::text = ? ) or (key->>'m_region')::text is null", m_region).first
    operator_name = tarif_class.try(:operator).try(:name)
    general_tag_description = "MyTarifs - сервис по подбору тарифов и опций операторов МТС, «Билайн», «Мегафон», TELE2. Анализируем все варианты и помогаем принять правильное решение!"    
    
#    tarif_class_name_with_plus = (tarif_class.try(:name) || "") == 'Smart+' ? 'Smart plus' : (tarif_class.try(:name) || "")
#    tarif_class_name = tarif_class_name_with_plus.split(' ').size == 1 ? tarif_class_name_with_plus : "«#{tarif_class_name_with_plus}»"

    tarif_class_name = (tarif_class.try(:name) || "").split(' ').size == 1 ? tarif_class.try(:name) : "«#{tarif_class.try(:name)}»"
    tag_site = 'Mytarifs.ru'
        
    if tarif_class_name =~ /#{operator_name}/i
      from_operator_name = ""; defic_operator_name = ""
    else
      from_operator_name = " от #{operator_name}"; defic_operator_name = " – #{operator_name}"
    end
    
    content_body = !existing_tarif_class_description.try(:content_body).blank? ? existing_tarif_class_description.try(:content_body) : ""
    content_title = existing_tarif_class_description.try(:content_title) if existing_tarif_class_description.try(:use_content_title) == 'true'
    is_noindex = [true, 'true'].include?(existing_tarif_class_description.try(:is_noindex)) ? true : false

    description_hash = case tarif_class.try(:standard_service_id)
    when TarifClass::ServiceType[:tarif]
      {
      :tag_title => ("#{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag} – описание и информация о тарифе"),
      :tag_description => "Описание тарифа #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}. #{general_tag_description}",
      :tag_keywords => "описание тарифа #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}".mb_chars.downcase.to_s,
      :content_title => (content_title || "Тариф #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}"), 
      :content_body => content_body, 
      :is_noindex => is_noindex, 
      }
    when TarifClass::ServiceType[:special_service]
      {
      :tag_title => "#{tarif_class_name}#{defic_operator_name} #{region_and_privacy_tag}: описание тарифной опции",
      :tag_description => "Описание тарифной опции #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}. #{general_tag_description}",
      :tag_keywords => "описание тарифной опции #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}".mb_chars.downcase.to_s,
      :content_title => "Тарифная опция #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}", 
      :content_body => content_body, 
      :is_noindex => is_noindex, 
      }
    else 
      {
      :tag_title => "#{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag} –  описание и информация о сервисе",
      :tag_description => "Описание услуги #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}. #{general_tag_description}",
      :tag_keywords => "описание услуги #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}".mb_chars.downcase.to_s,
      :content_title => "Услуга #{tarif_class_name}#{from_operator_name} #{region_and_privacy_tag}",  
      :content_body => content_body, 
      :is_noindex => is_noindex, 
      }
    end
    
    description_hash.merge!({
      :tag_site => tag_site,
      :image_name => existing_tarif_class_description.try(:image_name), 
      :image_title => existing_tarif_class_description.try(:image_title),
    })
      
    tarif_class_description = Content::Article.new(description_hash)
  end
  
  def advertise_url
    if show_cpanet_adv
      show_cpanet_program_item_only_source(:tarif_class_show, :advertise_url)
    else
      if tarif_class.operator_id == Category::Operator::Const::Tele2
        'http://ap.mytarifs.ru/click/58bc21fd8b30a8e7428b4567/126980/162117/subaccount'
      else
        nil
      end
    end    
  end
  
end
