class Cpanet::PageType
  Desc = {
    :root => {
      :name => 'домашняя страница', 
      :page_type_stat_id => 1, 
      :page_path_filtr => Proc.new{|context| 
        region_path = context.params[:m_region].blank? ? "" : "/#{context.params[:m_region]}" 
        privacy_path = context.params[:m_privacy].blank? ? "" : "/#{context.params[:m_privacy]}" 
        [
        "#{privacy_path}#{region_path}/",          
      ]},
    },
    
    :tarif => {
      :name => 'описание тарифа', 
      :page_type_stat_id => 2, 
      :page_path_filtr => Proc.new{|context| 
        region_path = context.params[:m_region].blank? ? "" : "/#{context.params[:m_region]}" 
        privacy_path = context.params[:m_privacy].blank? ? "" : "/#{context.params[:m_privacy]}" 
        [
        "#{privacy_path}#{region_path}/tarif_classes/#{context.params[:id]}",          
        "#{privacy_path}#{region_path}/tarif_classes/#{context.params[:operator_id]}/#{context.params[:id]}",          
        "#{privacy_path}#{region_path}/tarif_classes/unlimited_tarifs/#{context.params[:id]}",       
      ]},
      :page_param_filtr => {
        :m_region => Category::MobileRegions.keys, 
      },
      :page_id_filtr => {
        :operator_id => Category.where(:id => Category::Operator.operators_with_tarifs).pluck(:name, :id),
        :standard_service_id => TarifClass::ServiceType.map{|st, value| [st, value]},
        :privacy_id => Category::Privacies.map{|privacy, desc| [desc['name'], desc['id']]},
      },
      :page_item_filtr => {
        :model => Proc.new{|original_page_param_filtr_values, original_page_id_filtr_values|
          page_param_filtr_values = original_page_param_filtr_values.symbolize_keys
          page_id_filtr_values = original_page_id_filtr_values.symbolize_keys
          model = TarifClass.for_parsing('false').original_tarif_class
          model = model.regions_txt(page_param_filtr_values[:m_region]) if !page_param_filtr_values[:m_region].blank?
          model = model.where(:operator_id => page_id_filtr_values[:operator_id]) if !page_id_filtr_values[:operator_id].blank?
          model = model.where(:standard_service_id => page_id_filtr_values[:standard_service_id]) if !page_id_filtr_values[:standard_service_id].blank?
          model = model.where(:privacy_id => page_id_filtr_values[:privacy_id]) if !page_id_filtr_values[:privacy_id].blank?
          model
        },
        :select_fields => [:name, :id],
        :order_fields => [:name]
      },
      :page_item_method => :tarif_class,
      :page_item_id_method => :id,
    },

    :tarif_classes => {
      :name => 'список тарифов', 
      :page_type_stat_id => 3, 
      :page_path_filtr => Proc.new{|context| 
        region_path = context.params[:m_region].blank? ? "" : "/#{context.params[:m_region]}" 
        privacy_path = context.params[:m_privacy].blank? ? "" : "/#{context.params[:m_privacy]}" 
        [
        "#{privacy_path}#{region_path}/tarif_classes",          
        "#{privacy_path}#{region_path}/tarif_classes/ocenit_stoimost_tarifa",          
        "#{privacy_path}#{region_path}/tarif_classes/unlimited_tarifs",          
        "#{privacy_path}#{region_path}/tarif_classes/bez_abonentskoi_platy",          
        "#{privacy_path}#{region_path}/tarif_classes/dlya_plansheta",          
        "#{privacy_path}#{region_path}/tarif_classes/poezdki_po_miru",          
        "#{privacy_path}#{region_path}/tarif_classes/poezdki_po_rossii",          
        "#{privacy_path}#{region_path}/tarif_classes/zvonki_v_drugie_strany",          
        "#{privacy_path}#{region_path}/tarif_classes/zvonki_v_drugie_regiony",          
        "#{privacy_path}#{region_path}/tarif_classes/tele2",          
        "#{privacy_path}#{region_path}/tarif_classes/beeline",          
        "#{privacy_path}#{region_path}/tarif_classes/megafon",          
        "#{privacy_path}#{region_path}/tarif_classes/mts",          
      ]},
    },
    
    :compare_tarifs => {
      :name => 'сравнение тарифов', 
      :page_type_stat_id => 4, 
      :page_path_filtr => Proc.new{|context| 
        region_path = context.params[:m_region].blank? ? "" : "/#{context.params[:m_region]}" 
        privacy_path = context.params[:m_privacy].blank? ? "" : "/#{context.params[:m_privacy]}" 
        [
        "#{privacy_path}#{region_path}/sravnenie_tarifov",          
        "#{privacy_path}#{region_path}/sravnenie_tarifov/dlya_plansheta",          
        "#{privacy_path}#{region_path}/sravnenie_tarifov/tele2",          
        "#{privacy_path}#{region_path}/sravnenie_tarifov/beeline",          
        "#{privacy_path}#{region_path}/sravnenie_tarifov/megafon",          
        "#{privacy_path}#{region_path}/sravnenie_tarifov/mts",          
      ]},
    },
    
    :estimate_cost => {
      :name => 'быстрый подборы тарифов', 
      :page_type_stat_id => 5, 
      :page_path_filtr => Proc.new{|context| 
        region_path = context.params[:m_region].blank? ? "" : "/#{context.params[:m_region]}" 
        privacy_path = context.params[:m_privacy].blank? ? "" : "/#{context.params[:m_privacy]}" 
        [
        "#{privacy_path}#{region_path}/podbor_tarifov",          
        "#{privacy_path}#{region_path}/podbor_tarifov/dlya_plansheta",          
        "#{privacy_path}#{region_path}/podbor_tarifov/tele2",          
        "#{privacy_path}#{region_path}/podbor_tarifov/beeline",          
        "#{privacy_path}#{region_path}/podbor_tarifov/megafon",          
        "#{privacy_path}#{region_path}/podbor_tarifov/mts",          
      ]},
    },
    
    :mobile_article => {
      :name => 'мобильная статья', 
      :page_type_stat_id => 6, 
      :page_param_filtr => {
      },
    },
  }
  
  def self.find_cpanet_program_items_to_show_by_places(context)
    cpanet_pages_from_page_path_filtr = check_pages_for_page_path_filtr(context)

    cpanet_pages_from_page_param_filtr = check_programs_for_page_param_filtr(context, cpanet_pages_from_page_path_filtr)

    programs_to_show = check_programs_for_page_id_filtr(context, cpanet_pages_from_page_param_filtr)

    program_items_without_page_to_show = cpanet_items_without_page_item_to_show(programs_to_show)
    program_items_with_page_to_show = cpanet_items_with_page_item_to_show(context, programs_to_show)    
    program_items_to_show = program_items_with_page_to_show + program_items_without_page_to_show
    
    raise(StandardError) if false
        
    arrange_program_items_by_places_to_show(program_items_to_show)
  end
  
  def self.arrange_program_items_by_places_to_show(program_items)
    result = {}
    program_items.each do |program_item| 
      place_type = program_item.program.place_type.try(:to_sym)
      place = program_item.program.place.try(:to_sym)
      result[place_type] ||= {} 
      result[place_type][place] ||= []
      result[place_type][place] << program_item
    end
    result
  end
  
  def self.check_pages_for_page_path_filtr(context)
    result = []
    Desc.each do |page, page_desc|
      (page_desc[:page_path_filtr].try(:call, context) || []).each do |path_to_filtr|
        result << page if (context.request.path == path_to_filtr)
        raise(StandardError, [
          context.request.path,
          path_to_filtr
        ]) if page == :tarif_classes and false
      end
    end
    result
  end
  
  def self.check_programs_for_page_param_filtr(context, cpanet_pages_to_limit_check)
    cpanet_programs_to_show = []    
    
    program_model = ::Cpanet::MyOffer::Program.where(:status => 'active')
    if !cpanet_pages_to_limit_check.blank?
      cpanet_pages_to_limit_check_string = cpanet_pages_to_limit_check.map{|s| "'#{s}'"}.join(', ')
      program_model = program_model.where("cpanet_my_offer_programs.features#>>'{page}' in ( #{cpanet_pages_to_limit_check_string} )")
    end
    program_model.each do |cpanet_program_to_check|
        
      if_to_keep_cpanet_program_to_check = true
      (cpanet_program_to_check.page_param_filtr || {}).each do |param_filtr_key, param_filtr_value|     
        next if param_filtr_value.blank?
        
        param_value_to_check = case param_filtr_key
        when 'm_region'; context.m_region
        when 'm_privacy'; context.m_privacy
        else
          context.params.try(:[], param_filtr_key)
        end
        
        if_to_keep_cpanet_program_to_check = param_filtr_value.is_a?(Array) ? param_filtr_value.include?(param_value_to_check) : (param_filtr_value == param_value_to_check)

        break if !if_to_keep_cpanet_program_to_check
      end
      
      cpanet_programs_to_show << cpanet_program_to_check if if_to_keep_cpanet_program_to_check
    end
    cpanet_programs_to_show
  end

  def self.check_programs_for_page_id_filtr(context, cpanet_programs_to_check)
    cpanet_programs_to_show = []    
    
    cpanet_programs_to_check.each do |cpanet_program_to_check|
        
      page_item_method = Cpanet::PageType::Desc[cpanet_program_to_check.page.try(:to_sym)].try(:[], :page_item_method)
      
      if page_item_method.blank?
        cpanet_programs_to_show << cpanet_program_to_check
        next
      end
      
      page_item_object = context.try(page_item_method)

      if_to_keep_cpanet_program_to_check = true
      cpanet_program_to_check.page_id_filtr.each do |id_filtr_key, id_filtr_value|  
        next if id_filtr_value.blank?
              
        id_value_to_check = page_item_object.try(id_filtr_key.to_sym) if page_item_object.respond_to?(id_filtr_key.to_sym)
        
        if_to_keep_cpanet_program_to_check = id_filtr_value.is_a?(Array) ? id_filtr_value.include?(id_value_to_check) : (id_filtr_value == id_value_to_check)

        break if !if_to_keep_cpanet_program_to_check
      end
      
      cpanet_programs_to_show << cpanet_program_to_check if if_to_keep_cpanet_program_to_check
    end
    cpanet_programs_to_show
  end
  
  def self.cpanet_items_without_page_item_to_show(programs_to_show)
    ::Cpanet::MyOffer::Program::Item.includes(:program).
      where(:status => 'active').
      where("(cpanet_my_offer_program_items.features#>>'{page_item}')::text is null").
      where(:program_id => programs_to_show.map{|p| p.id}).all
  end

  def self.cpanet_items_with_page_item_to_show(context, programs_to_show)
    where_condition_for_items = []
    programs_to_show.each do |program_to_show|
      page_item_method = Cpanet::PageType::Desc[program_to_show.page.try(:to_sym)].try(:[], :page_item_method)
      next if page_item_method.blank?
      
      page_item_id_method = Cpanet::PageType::Desc[program_to_show.page.try(:to_sym)].try(:[], :page_item_id_method)
      page_item_id = context.try(page_item_method).try(page_item_id_method)
      
      page_item_condition = page_item_id ? "(cpanet_my_offer_program_items.features#>>'{page_item}')::text::integer = #{page_item_id}" : "true"
      program_condition = program_to_show.id ? "cpanet_my_offer_program_items.program_id = #{program_to_show.id}" : "true"
      
      where_condition_for_items << "( #{page_item_condition} and #{program_condition} )"        
    end
    
    model = ::Cpanet::MyOffer::Program::Item.includes(:program).where(:status => 'active')
    model = where_condition_for_items.blank? ? model.where("false") : model.where(where_condition_for_items.join(' or ')).all

    raise(StandardError, where_condition_for_items) if false
    
    model
  end

  def self.page_item_filtr(page, page_param_filtr_values, page_id_filtr_values)
    page_item_filtr_desc = Desc[page.try(:to_sym)].try(:[], :page_item_filtr)
    if page_item_filtr_desc.blank?
      []
    else
      order_fields = page_item_filtr_desc[:order_fields] || [:name]
      select_fields = page_item_filtr_desc[:select_fields] || [:name, :id]
      page_item_filtr_model(page, page_param_filtr_values, page_id_filtr_values).order(order_fields).pluck(*select_fields)
    end
  end
  
  def self.page_item_filtr_model(page, page_param_filtr_values, page_id_filtr_values)
    Desc[page.try(:to_sym)].try(:[], :page_item_filtr)[:model].try(:call, page_param_filtr_values, page_id_filtr_values)
  end
  

end

