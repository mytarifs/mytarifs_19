module ApplicationHelper::Cpanet
  def cpanet_program_items_to_show_by_places
    return @cpanet_program_items_to_show_by_places if @cpanet_program_items_to_show_by_places
    @cpanet_program_items_to_show_by_places = ::Cpanet::PageType.find_cpanet_program_items_to_show_by_places(self)
  end
  
  def show_cpanet_adv
#    user_type == :admin ? true : false
    true
  end
  
  def show_cpanet_program_item_only_source(place_type, place)
    program_item_to_show(place_type, place).try(:source)
  end
  
  def show_cpanet_program_item_with_html(place_type, place)
    program_item_to_show = program_item_to_show(place_type, place)
    
    return nil if program_item_to_show.nil?
    
    Cpanet::PlaceViewType.program_item_view(view_context, program_item_to_show)
  end
  
  def program_item_to_show(place_type, place)
    program_items_to_show = cpanet_program_items_to_show_by_places.try(:[], place_type).try(:[], place)
    
    program_item_to_show = program_items_to_show.try(:[], 1) ? select_one_cpanet_program_item(program_items_to_show) : program_items_to_show.try(:[], 0)
    
    program_item_to_show.blank? ? nil : program_item_to_show
  end
  
  def select_one_cpanet_program_item(cpanet_program_items)
    cpanet_program_items.try(:[], 0)    
  end
  

end
