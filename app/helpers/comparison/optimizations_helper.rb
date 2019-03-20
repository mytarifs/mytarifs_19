module Comparison::OptimizationsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers
  include Shared::CallStat

  def calculate_ratings_options
    create_filtrable("calculate_ratings_options")
  end
  
  def check_calculate_ratings_options
    if params['calculate_ratings_options_filtr']
      if params['calculate_ratings_options_filtr']['rating_keys_to_process']
        params['calculate_ratings_options_filtr']['rating_keys_to_process'] = params['calculate_ratings_options_filtr']['rating_keys_to_process'] - ['']
      end

      if params['calculate_ratings_options_filtr']['privacy_keys_to_process']
        params['calculate_ratings_options_filtr']['privacy_keys_to_process'] = params['calculate_ratings_options_filtr']['privacy_keys_to_process'] - ['']
      end

      if params['calculate_ratings_options_filtr']['region_keys_to_process']
        params['calculate_ratings_options_filtr']['region_keys_to_process'] = params['calculate_ratings_options_filtr']['region_keys_to_process'] - ['']
      end

      if params['calculate_ratings_options_filtr']['test_group_key']
        params['calculate_ratings_options_filtr']['test_group_key'] = params['calculate_ratings_options_filtr']['test_group_key'] - ['']
      end

      if params['calculate_ratings_options_filtr']['test_operator']
        params['calculate_ratings_options_filtr']['test_operator'] = (params['calculate_ratings_options_filtr']['test_operator'] - ['']).map(&:to_i)

        if params['calculate_ratings_options_filtr']['tarif_id_to_process']
          params['calculate_ratings_options_filtr']['tarif_id_to_process'] = (params['calculate_ratings_options_filtr']['tarif_id_to_process'] - ['']).map(&:to_i)
          
          params['calculate_ratings_options_filtr']['services_by_operator_to_use'] ||= {}
          params['calculate_ratings_options_filtr']['test_operator'].each do |operator_id|
            tarif_ids = TarifClass.where(:operator_id => operator_id, :id => params['calculate_ratings_options_filtr']['tarif_id_to_process']).pluck(:id).uniq
            next if tarif_ids.blank?
            params['calculate_ratings_options_filtr']['services_by_operator_to_use'][operator_id] = tarif_ids
          end
        end
      end

    end

  end
  
  def comparison_optimizations_table 
    model_to_show = user_type == :admin ? Comparison::Optimization.by_privacy_region_with_fast_optimization(m_privacy, m_region) : 
      Comparison::Optimization.by_privacy_region(m_privacy, m_region).published
    model_to_show = model_to_show.includes(:publication_status)
    options = {:base_name => 'comparison_optimizations', :current_id_name => 'comparison_optimization_id', :id_name => 'id', :pagination_per_page => 10}
    create_tableable(model_to_show, options)
  end
  
  def comparison_groups    
    model_to_show = comparison_optimization_form.model ? comparison_optimization_form.model.groups.includes(:call_runs, :result_run) : nil
    options = {:base_name => 'comparison_groups', :current_id_name => 'comparison_group_id', :id_name => 'id', :pagination_per_page => 1000}
    create_tableable(model_to_show, options)
  end
  
  def check_current_id_exists
#    session[:current_id]['comparison_optimization_id'] = params[:id] if session[:current_id]['comparison_optimization_id'].blank?
    session[:current_id]['comparison_optimization_id'] = Comparison::Optimization.friendly.find(params[:id]).try(:id) if session[:current_id]['comparison_optimization_id'].blank?
  end
  
  def set_run_id    
    comparison_group = Comparison::Group.where(:id => session[:current_id]['comparison_group_id']).first
    group_results = @group_result_description[m_privacy][m_region][comparison_group.id]
    if group_results
      service_set_ids = group_results.map{|group_result| group_result.try(:[], :group).try(:[], 0).try(:[], :service_set_id)} 
      service_set_ids_by_place = {}
      service_set_ids.each_with_index{|service_set_id, index| service_set_ids_by_place[index.to_s] = service_set_id}
    end
    if comparison_group and group_results
        session[:filtr]["service_set_choicer_filtr"] ||={}
        session[:filtr]["service_set_choicer_filtr"]['result_service_set_id'] = service_set_ids_by_place
    end
  end
  
  def set_back_path
    session[:back_path]['service_sets_result_return_link_to'] = 'comparison_optimization_path'
  end

  def call_runs
#    @call_runs ||= 
    Customer::CallRun.joins(:group_call_runs).where(:comparison_group_call_runs => {:comparison_group_id => session[:current_id]['comparison_group_id']})
  end
  
  def operator_choicer
#    @operator_choicer ||= 
    create_filtrable("operator_choicer")
  end
  
  def operator_options
#    @operator_options ||= 
    call_runs.pluck(:operator_id)
  end

  def call_run
    operator_id = session_filtr_params(operator_choicer).try(:[], :operator_id).try(:to_i) || operator_options[0]
    call_runs.where(:operator_id => operator_id).first
  end

  def id_name
    Comparison::Optimization.respond_to?(:friendly) ? :slug : :id
  end

  def comparison_description
    return @comparison_description if @comparison_description    
    if params[:operator_id].blank?
      @comparison_description = Content::Article.
        where("((key->>'operator_id') is null or (key->>'operator_id') = '') and key->>'comparison_id' = ?", comparison_optimization.id.try(:to_s)).first
      raise(StandardError, [@comparison_description, comparison_optimization.attributes]) if false
      if !@comparison_description      
        @comparison_description = Content::Article.new(
          :tag_title => "#{comparison_optimization.try(:name)} #{region_and_privacy_tag}",
          :tag_description => "#{comparison_optimization.try(:name)} #{region_and_privacy_tag}. www.mytarifs.ru — сервис по подбору тарифов и опций для мобильных операторов: «МТС», «Билайн», «Мегафон», TELE2. Помогаем принять правильное решение! Предлагаем широкий выбор средств для анализа услуг в области мобильной связи.",
          :tag_keywords => "рейтинг операторов самые лучшие тарифы #{region_and_privacy_tag}",
          :content_title => "#{comparison_optimization.try(:name)} #{region_and_privacy_tag}", 
          :content_body => "", 
        )
      else
        @comparison_description.tag_title += " #{region_and_privacy_tag}"
        descriptions = @comparison_description.tag_description.try(:split, '.') || ["", ""]
        @comparison_description.tag_description+= "#{descriptions[0]} #{region_and_privacy_tag}. #{descriptions[1]}" 
        @comparison_description.tag_keywords += " #{region_and_privacy_tag}" 
        @comparison_description.content_title += " #{region_and_privacy_tag}" 
      end
    else
      @comparison_description = Content::Article.
        where("key->>'comparison_id' = ? and key->>'operator_id' = ?", comparison_optimization.id.try(:to_s), operator.id.try(:to_s)).first
      if !@comparison_description      
        @comparison_description = Content::Article.new(
          :tag_title => "#{comparison_optimization.try(:name)} для #{operator.name} #{region_and_privacy_tag}",
          :tag_description => "#{comparison_optimization.try(:name)} для #{operator.name} #{region_and_privacy_tag}. www.mytarifs.ru — сервис по подбору тарифов и опций для мобильных операторов: «МТС», «Билайн», «Мегафон», TELE2. Помогаем принять правильное решение! Предлагаем широкий выбор средств для анализа услуг в области мобильной связи.",
          :tag_keywords => "рейтинг тарифов #{operator.name} самые лучшие тарифы #{region_and_privacy_tag}",
          :content_title => "#{comparison_optimization.try(:name)} для #{operator.name} #{region_and_privacy_tag}", 
          :content_body => "", 
        )
      else
        @comparison_description.tag_title += " #{region_and_privacy_tag}"
        descriptions = @comparison_description.tag_description.try(:split, '.') || ["", ""]
        @comparison_description.tag_description+= "#{descriptions[0]} #{region_and_privacy_tag}. #{descriptions[1]}" 
        @comparison_description.tag_keywords += " #{region_and_privacy_tag}" 
        @comparison_description.content_title += " #{region_and_privacy_tag}" 
      end
    end
    
    @comparison_description
  end
  
  def group_result_description_by_original_group_id_privacy_and_region(original_group_id, original_m_privacy = nil, original_m_region = nil)
    m_privacy_to_use = original_m_privacy.blank? ? m_privacy : original_m_privacy
    m_region_to_use = original_m_region.blank? ? m_region : original_m_region
    
    final_group_id = RatingsDataLoader.group_id_from_original_id(original_group_id, m_privacy_to_use, m_region_to_use)
    @group_result_description[m_privacy_to_use][m_region_to_use][final_group_id]
  end
  
  def operator
    @operator
  end

end
