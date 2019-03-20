module TarifClassesHelper::MassEditHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers

  def chosen_tarifs_to_mass_edit
    filtr = session_filtr_params(tarifs_to_update_select_filtr)
    result = TarifClass.
      where(:operator_id => filtr['operator_id']).
      where(:standard_service_id => filtr['standard_service_id']).
      where(:privacy_id => filtr['privacy_id']).
      where(is_service_archived(filtr.clone)).
      is_service_published?(filtr['publication_status'])
    result = result.region_txt(filtr['region_txt']) if !filtr['region_txt'].blank?
    result = result.for_parsing(filtr['for_parsing']) if !filtr['for_parsing'].blank?
    result = result.original_tarif_class if filtr['hide_secondary_tarif_class'] == 'true'
    result    
  end
  
  def update_incompatibility_tarif_class
    filtr = params['incompatibility_tarif_class_filtr']
    if filtr.try(:[], 'choose_other_incompatibility_value') == 'true' and !filtr.try(:[], 'new_existing_incompatibility_value').blank?
      tarifs_to_update = ((filtr.try(:[], 'tarifs_to_update_new_value') || []) - ['']).map(&:to_i)
      value_to_update_str = filtr.try(:[], 'new_existing_incompatibility_value')
      existing_record_with_value_to_update = TarifClass.where("dependency#>>'{incompatibility, #{filtr['incompatibility_key']} }' = $$#{value_to_update_str}$$").first
      if !tarifs_to_update.blank? and existing_record_with_value_to_update
        value_to_update = existing_record_with_value_to_update['dependency'].try(:[], 'incompatibility').try(:[], filtr['incompatibility_key'])
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          full_value_to_update = tarif_class['dependency'].deep_merge({'incompatibility' => {filtr['incompatibility_key'] => value_to_update}})
          tarif_class['dependency'] = full_value_to_update
          tarif_class.save
        end
      end      
      filtr['tarifs_to_update_new_value'] = []
    end

    if filtr.try(:[], 'change_incompatibility_key') == 'true'
      tarifs_to_update = ((filtr.try(:[], 'tarifs_to_update_new_value') || []) - ['']).map(&:to_i)
      if !tarifs_to_update.blank? and !filtr['new_incompatibility_key'].blank?
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          value_to_update = tarif_class['dependency'].try(:[], 'incompatibility').try(:[], filtr['incompatibility_key'])
          full_value_to_update = tarif_class['dependency'].deep_merge({'incompatibility' => {filtr['new_incompatibility_key'] => value_to_update}})
          full_value_to_update['incompatibility'].extract!(filtr.try(:[], 'incompatibility_key'))
          tarif_class['dependency'] = full_value_to_update
          tarif_class.save
        end
      end      
      filtr['new_incompatibility_key'] = nil
      filtr['tarifs_to_update_new_value'] = []
    end

    if filtr.try(:[], 'delete_incompatibilty_key_from_service') == 'true'
      tarifs_to_update = ((filtr.try(:[], 'tarifs_to_update_new_value') || []) - ['']).map(&:to_i)
      if !tarifs_to_update.blank? and !filtr['incompatibility_key'].blank?
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          tarif_class['dependency']['incompatibility'].extract!(filtr.try(:[], 'incompatibility_key'))
          tarif_class.save
        end
      end      
      filtr['tarifs_to_update_new_value'] = []
    end
  end
  
  def change_incompatibility_value_tarif_class
    filtr = params['incompatibility_change_tarif_class_filtr']
    if filtr.try(:[], 'change_incompatibility_value') == 'true' and !filtr['incompatibility_key'].blank? and !filtr['incompatibility_value'].blank?
      tarifs_to_update = ((filtr.try(:[], 'tarifs_with_chosen_value') || []) - ['']).map(&:to_i)
      value_to_update = ((filtr.try(:[], 'new_incompatibility_options') || []) - ['']).map(&:to_i).uniq
      if !tarifs_to_update.blank?
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          full_value_to_update = tarif_class['dependency'].deep_merge({'incompatibility' => {filtr['incompatibility_key'] => value_to_update}})
          tarif_class['dependency'] = full_value_to_update
          tarif_class.save
        end
      end      
      filtr['tarifs_with_chosen_value'] = []
    end
  end
  
  def update_dependent_on_tarif_class
    filtr = params['dependent_on_tarif_class_filtr']
    if filtr.try(:[], 'update_value_for_dependency') == 'true'
      tarifs_to_update = ((filtr.try(:[], 'tarifs_to_update_new_value') || []) - ['']).map(&:to_i)
      value_to_update_str = filtr.try(:[], 'new_value_for_features_or_dependency')
      existing_record_with_value_to_update = TarifClass.where("#{filtr['features_or_dependency']}->>'#{filtr['fields_for_features_or_dependency']}' = $$#{value_to_update_str}$$").first
      if !tarifs_to_update.blank? and existing_record_with_value_to_update
        value_to_update = existing_record_with_value_to_update[filtr['features_or_dependency']].try(:[], filtr['fields_for_features_or_dependency'])
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          full_value_to_update = tarif_class[filtr['features_or_dependency']].merge({filtr['fields_for_features_or_dependency'] => value_to_update})
          tarif_class[filtr['features_or_dependency']] = full_value_to_update
          tarif_class.save
        end
      end      
      filtr['tarifs_to_update_new_value'] = []
    end
  end
  
  def update_general_features_tarif_class
    filtr = params['general_features_tarif_class_filtr']
    if filtr.try(:[], 'update_value_for_features_or_dependency') == 'true'
      tarifs_to_update = ((filtr.try(:[], 'tarifs_to_update_new_value') || []) - ['']).map(&:to_i)
      value_to_update_str = filtr.try(:[], 'new_value_for_features_or_dependency')
      existing_record_with_value_to_update = TarifClass.where("#{filtr['features_or_dependency']}->>'#{filtr['fields_for_features_or_dependency']}' = $$#{value_to_update_str}$$").first
      if !tarifs_to_update.blank? and existing_record_with_value_to_update
        value_to_update = existing_record_with_value_to_update[filtr['features_or_dependency']].try(:[], filtr['fields_for_features_or_dependency'])
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          full_value_to_update = tarif_class[filtr['features_or_dependency']].merge({filtr['fields_for_features_or_dependency'] => value_to_update})
          tarif_class[filtr['features_or_dependency']] = full_value_to_update
          tarif_class.save
        end
      end      
      filtr['tarifs_to_update_new_value'] = []
    end

    if filtr.try(:[], 'delete_value_for_service') == 'true'
      tarifs_to_update = ((filtr.try(:[], 'tarifs_to_update_new_value') || []) - ['']).map(&:to_i)
      if !tarifs_to_update.blank? and !filtr['fields_for_features_or_dependency'].blank?
        TarifClass.where(:id => tarifs_to_update).find_each do |tarif_class|
          tarif_class[filtr['features_or_dependency']].extract!(filtr['fields_for_features_or_dependency'])
          tarif_class.save
        end
      end      
      filtr['tarifs_to_update_new_value'] = []
    end
  end

end
