module ServiceParser
   
  class Base
    include GeneralHelper, GlobalCategoryHelper, ServiceParamsAutoUpdateHelper
    
    attr_reader :tags_to_exclude_from_page, :operator_id, :region_id, :parsing_class, :tarif_class
    attr_accessor :doc, :service_desc
    
    def initialize(options)
      @operator_id = options[:operator_id]
      @region_id = options[:region_id]
      @parsing_class = options[:parsing_class]
      @tarif_class = options[:tarif_class]
      @tags_to_exclude_from_page = options[:tags_to_exclude_from_page] || []
      @doc = set_doc(options[:original_page])
#      puts @doc.to_html
    end
    
    def set_doc(html_page)
      @row_body = nil
      @body = nil
      @service_desc = nil
      @doc = Nokogiri::HTML(html_page)
    end
    
    def test_search_tag(search_tag, default_url = nil)
      begin
        search_tag(body, search_tag, default_url)
      rescue StandardError => e
        e
      end      
    end
    
    def parse_service(service_parsing_tags_to_use = {})
      begin
        service_parsing_tags_to_use = service_parsing_tags if service_parsing_tags_to_use.blank?
        
        result = {}
        
        service_scope = parse_base_service_scope(service_parsing_tags_to_use)

        return {} if service_scope.blank?

        service_parsing_tags_to_use[:service_blocks].each do |service_block_tags|
          block_scopes = parse_service_scope_for_block_scopes(service_scope, service_block_tags)
          
          block_scopes.each do |original_block_scope|
            block_scope = original_block_scope.dup
            if service_block_tags[:outside_block_name_tag]              
              previous_element = return_previous_element(original_block_scope, service_block_tags[:outside_block_name_tag]).try(:dup)
              add_new_element_to_node_as_child_with_tag(block_scope, previous_element, "title") 
            end
            
            result = parse_block_scope(result, block_scope, service_block_tags)
          end                    
        end
        
        result
#      rescue StandardError => e
#        {}
      end      
    end
    
    def parse_block_scope(previous_result, block_scope, service_block_tags)
      block_title = parse_block_scope_for_block_title(block_scope, service_block_tags)

      return previous_result if (service_block_tags[:block_names_to_exclude] || []).include?(block_title)

      sub_block_scopes = parse_block_scope_for_sub_block_scopes(block_scope, service_block_tags)
      
      default_sub_block_title = sub_block_scopes.blank? ? 'no_sub_block' : "sub_block"
      
      sub_block_scopes.each do |original_sub_block_scope| 
        sub_block_scope = original_sub_block_scope.dup       
        if service_block_tags[:outside_sub_block_name_tag]          
          previous_element = return_previous_element(original_sub_block_scope, service_block_tags[:outside_sub_block_name_tag]).try(:dup)
          add_new_element_to_node_as_child_with_tag(sub_block_scope, previous_element, "title") 
        end
        
        previous_result = parse_sub_block_scope(previous_result, sub_block_scope, service_block_tags, block_title, default_sub_block_title)
      end
      previous_result
    end
    
    def parse_sub_block_scope(previous_result, sub_block_scope, service_block_tags, block_title, default_sub_block_title)
      sub_block_title = parse_sub_block_scope_for_sub_block_title(sub_block_scope, service_block_tags, default_sub_block_title)
      
      sub_block_title, default_param_value = parse_sub_block_title_to_split_by_regex(sub_block_title, service_block_tags)

      row_params = parse_row_scope(sub_block_scope, service_block_tags, default_param_value)      
              
      row_params_by_global_categories = search_global_categories(block_title, sub_block_title, row_params)
      row_params_by_global_categories.each do |global_category, row_params_by_global_category|
        previous_result[global_category] ||= []
        previous_result[global_category] += row_params_by_global_category
      end
      previous_result
    end
    
    def parse_base_service_scope(service_parsing_tags_to_use)
#      puts body.to_html
      service_scope = check_and_return_first_node_with_scope(body, service_parsing_tags_to_use[:base_service_scope]) || body
      service_scope = check_and_return_first_node_with_scope(service_scope, service_parsing_tags_to_use[:additional_service_scope]) if !service_parsing_tags_to_use[:additional_service_scope].blank?
      service_scope
    end
    
    def parse_service_scope_for_block_scopes(service_scope, service_block_tags)
      block_scopes = check_and_return_all_nodes_with_scope(service_scope, service_block_tags[:block_tag])
      block_scopes = [service_scope] if service_block_tags[:block_tag].blank? and block_scopes.blank?
      block_scopes = process_node(block_scopes, service_block_tags[:process_block]) if service_block_tags[:process_block]
      block_scopes
    end
    
    def parse_block_scope_for_block_title(block_scope, service_block_tags)
      block_title_node = check_and_return_first_node_with_scope(block_scope, service_block_tags[:block_name_tag])
      block_title_node = add_text_from_node_attributes(block_title_node, service_block_tags[:block_name_attributes_to_text]) if block_title_node and service_block_tags[:block_name_attributes_to_text]
      block_title = squished_node_text(block_title_node, service_block_tags[:return_ony_own_block_text])

      block_title = "block" if block_title.blank?
      block_title = substitute_name_from_hash_with_regex(block_title, Category::Region::Desc.new(region_id, operator_id).substitute_names)
      block_title = substitute_name_from_hash_with_exact_match(block_title,  service_block_tags[:block_name_substitutes]) if !service_block_tags[:block_name_substitutes].blank?
      block_title = substitute_name_by_match_with_regex(block_title,  service_block_tags[:block_name_substitutes_regex]) if !service_block_tags[:block_name_substitutes_regex].blank?
      block_title
    end
    
    def parse_block_scope_for_sub_block_scopes(block_scope, service_block_tags)
      sub_block_scopes = check_and_return_all_nodes_with_scope(block_scope, service_block_tags[:sub_block_tag])
      sub_block_scopes = [block_scope] if sub_block_scopes.blank?
      sub_block_scopes = process_node(sub_block_scopes, service_block_tags[:process_sub_block]) if service_block_tags[:process_sub_block]
      sub_block_scopes
    end
    
    def parse_sub_block_scope_for_sub_block_title(sub_block_scope, service_block_tags, default_sub_block_title)      
      sub_block_title_node = check_and_return_first_node_with_scope(sub_block_scope, service_block_tags[:sub_block_name_tag])
      sub_block_title = squished_node_text(sub_block_title_node, service_block_tags[:return_ony_own_sub_block_text])              
      sub_block_title = sub_block_title.blank? ? 
        default_sub_block_title : 
        substitute_name_from_hash_with_regex(sub_block_title, Category::Region::Desc.new(region_id, operator_id).substitute_names)
      sub_block_title = substitute_name_from_hash_with_exact_match(sub_block_title,  service_block_tags[:sub_block_name_substitutes]) if !service_block_tags[:sub_block_name_substitutes].blank?
      sub_block_title
    end
    
    def parse_sub_block_title_to_split_by_regex(sub_block_title, service_block_tags)
      default_param_value = 'blank'
      if service_block_tags[:sub_block_text_to_split_by_regex]
        params = match_text_by_divider_hash(sub_block_title, service_block_tags[:sub_block_text_to_split_by_regex])[0]
        if params.size > 1
          sub_block_title = params[0]
          default_param_value = params[1]
        end
      end
      [sub_block_title, default_param_value]
    end
    
    def parse_row_scope(block_scope, service_block_tags, default_param_value = 'blank')
      result = {}      
      row_scopes = service_block_tags[:row_tag].blank? ? [block_scope] : check_and_return_all_nodes_with_scope(block_scope, service_block_tags[:row_tag])
      row_scopes.each_with_index do |row_scope, index|        
        row_scope.css('br').each{ |br| br.replace("\n") } if row_scope.at_css('br')
        
        if service_block_tags[:return_row_item_text]
          return_only_row_item_text = service_block_tags[:return_row_item_text_with_children_text] == true ? false : true
          row_item_text = squished_node_text(row_scope, return_only_row_item_text)
          row_item_text = substitute_name_from_hash_with_regex(row_item_text, Category::Region::Desc.new(region_id, operator_id).substitute_names)
          row_item_text_to_split_by_regex = service_block_tags[:row_item_text_to_split_by_regex]            
        else
          param_name_node = check_and_return_first_node_with_scope(row_scope, service_block_tags[:param_name_tag])
          param_name = squished_node_text(param_name_node, service_block_tags[:return_ony_own_param_name_text])
          param_name = param_name.blank? ? "param" : substitute_name_from_hash_with_regex(param_name, Category::Region::Desc.new(region_id, operator_id).substitute_names)
  
          param_value = if service_block_tags[:return_multiple_nodes_for_param_value] == true
            param_value_nodes = check_and_return_all_nodes_with_scope(row_scope, service_block_tags[:param_value_tag])
            param_values = (param_value_nodes || []).map{|param_value_node| squished_node_text(param_value_node, service_block_tags[:return_ony_own_param_value_text])}
            (param_values - ['']).join(" ")            
          else
            param_value_node = check_and_return_first_node_with_scope(row_scope, service_block_tags[:param_value_tag])
            squished_node_text(param_value_node, service_block_tags[:return_ony_own_param_value_text])
          end
          param_value = param_value.blank? ? default_param_value : substitute_name_from_hash_with_regex(param_value, Category::Region::Desc.new(region_id, operator_id).substitute_names)
          
          param_divider = "____"
          row_item_text = "#{param_name}#{param_divider}#{param_value}"
          row_item_text_to_split_by_regex = {/(.*)#{param_divider}(.*)/i => [1..1, 2..2]}
        end

        multi_params = match_text_by_divider_hash(row_item_text, row_item_text_to_split_by_regex, 
          service_block_tags[:return_multi_results_row_item_text_to_split_by_regex], service_block_tags[:return_text_if_nil_result])

        multi_params.each do |params|
          params[1] = substitute_name_from_hash_with_regex_array(params[1], service_to_global_category_attributes[:blank_param_value_substitutes]) if !params[1].blank?
          if params.size > 1
            processed_param_name = substitute_name_from_hash_with_regex(params[0], Category::Region::Desc.new(region_id, operator_id).substitute_names)
            result[processed_param_name] ||= []
            result[processed_param_name] << params[1]
          else
            if !params[0].blank?
              result["param #{index}"] ||= []
              result["param #{index}"] << params[0] 
            end
          end
        end
      end
      result
    end
    
    def service_parsing_tags_possible_keys
      result = []
      TarifClass.where(:operator_id => [1023, 1030]).each do |tarif_class|
        begin
          parser = ServiceParser::Runner.init({
            :operator_id => tarif_class.operator_id,
            :tarif_class => tarif_class,
            :parsing_class => tarif_class.parsing_class,
          })    
          temp_service_block_tags_list = []
          parser.service_parsing_tags[:service_blocks].each{|sbt| temp_service_block_tags_list += (sbt.keys - temp_service_block_tags_list) }
          result += (temp_service_block_tags_list - result)
        rescue NameError
          next
        end
      end if false
      
      result = [
        :block_tag, 
        :outside_block_name_tag, 
        :process_block, 
        :block_name_tag, 
        :block_name_substitutes, 
        :block_name_substitutes_regex, 
        :block_names_to_exclude, 
        
        :sub_block_tag, 
        :outside_sub_block_name_tag,
        :process_sub_block, 
        :sub_block_name_tag, 
        :sub_block_name_substitutes, 
        :sub_block_text_to_split_by_regex, 
        :return_ony_own_sub_block_text, 
        
        :row_tag, 
        :return_row_item_text, 
        :return_row_item_text_with_children_text, 
        :return_multi_results_row_item_text_to_split_by_regex, 
        :return_text_if_nil_result, 
        :row_item_text_to_split_by_regex, 
    
        :return_ony_own_param_name_text, 
        :param_name_tag, 
        :return_multiple_nodes_for_param_value,
        :return_ony_own_param_value_text, 
        :param_value_tag, 
      ] if result.blank?
#      puts
#      puts result.to_s
#      puts
      result
    end
    
    def match_text_by_divider_hash(text, match_array, return_multi_results = false, return_text_if_nil_result = true)
      return [[text]] if match_array.blank?
      result = []
      match_array.each do |match_item, array_ids_for_params|
        matched_array = text.match(match_item)
        if !matched_array.blank?
          if return_multi_results == true
            result << [(matched_array[array_ids_for_params[0]] || []).join(' '), (matched_array[array_ids_for_params[1]] || []).join(' ')]
          else
            return [[(matched_array[array_ids_for_params[0]] || []).join(' '), (matched_array[array_ids_for_params[1]] || []).join(' ')]]
          end          
        end           
      end
      result.blank? ? (return_text_if_nil_result ? [[text]] : [[]]) : result
    end
    
    def substitute_name_from_hash_with_regex(name_to_substitute, substitute_hash)
      return name_to_substitute if substitute_hash.blank?
      substitute_hash.each do |regex_string, new_subsitute_part|
      
        new_name = name_to_substitute.gsub(/#{regex_string}/i, new_subsitute_part)
        raise(StandardError) if regex_string == 'Хакасия (Республика Хакасия) — Абакан' and name_to_substitute == 'Хакасия (Республика Хакасия) — Абакан'
        return new_name if new_name != name_to_substitute
      end
      name_to_substitute
    end
    
    def substitute_name_from_hash_with_regex_array(name_to_substitute, substitute_hash)
      return name_to_substitute if substitute_hash.blank?
      substitute_hash.each do |regex_string_array, new_subsitute_part|
        regex_string_array.each do |regex_string|
          new_name = name_to_substitute.gsub(/#{regex_string}/i, new_subsitute_part)
          return new_name if new_name != name_to_substitute
        end      
      end
      name_to_substitute
    end
    
    def substitute_name_from_hash_with_exact_match(name_to_substitute, substitute_hash)
      name_to_use = normailze_name(name_to_substitute)
#      puts
#      puts name_to_use
#      puts
      substitute_hash.try(:[], name_to_use) ? substitute_hash.try(:[], name_to_use) :  name_to_substitute
    end
    
    def substitute_name_by_match_with_regex(name_to_substitute, regex_hash)
      return name_to_substitute if name_to_substitute.blank? or regex_hash.blank?
      regex_hash.each do |regex, array_ids_for_params|
        matched_array = name_to_substitute.match(regex)
        if !matched_array.blank?
          result = array_ids_for_params.map{|i| matched_array[i] }.join('')
          result = normailze_name(result)
          return result
        end
      end
      "wrong_name"
    end
    
    def check_and_return_first_node_with_scope(node, scope_tags)
      return nil if node.blank? or scope_tags.blank?
      return node if scope_tags == ["use_parent_node"]
      scope_tags.each do |scope_tag|
        scope_result = node.at_css(scope_tag)
#        scope_result = node.at_css(scope_tag)
        return scope_result if !scope_result.blank?
      end
      nil
    end
    
    def check_and_return_all_nodes_with_scope(node, scope_tags)
      return [] if node.blank? or scope_tags.blank?
      scope_tags.each do |scope_tag|
        scope_result = node.css(scope_tag)#.try(:children)
        return scope_result if !scope_result.blank?
      end
      []
    end
    
    def add_new_element_to_node_as_child_with_tag(node, new_element, new_child_tag)
      new_child_node = Nokogiri::XML::Node.new new_child_tag, doc
      new_child_node.add_child(new_element) if new_element
      node.add_child(new_child_node)
      node
    end
    
    def return_previous_element(block_scope, outside_block_name_tags)
      current_element = block_scope.previous_element
      if outside_block_name_tags.is_a?(Array)       
        while current_element
          break if outside_block_name_tags.include?(current_element.name) and !current_element.text.blank?
          current_element = current_element.previous_element
        end
      end
      current_element
    end

    def add_text_from_node_attributes(node, attributes_to_text)
      node_text = [node.content].compact
      node_text += (attributes_to_text || []).map{|attribute_to_text| node[attribute_to_text]}.compact
      node.content = node_text.join(' /// ')
      node
    end

    def search_services(search_tags_hash, excluded_words = [], default_url = nil)
      begin
        return {} if search_tags_hash.blank?
        result = {}
        search_tags_hash.each do |key, search_tag|
          searched_node = search_tag(body, [search_tag], default_url)
          node_with_links = searched_node.try(:css, 'a')
          if node_with_links.blank? and no_link_from_node(key)
            next if default_url.blank?
            default_url_without_domain = url_without_domain(default_url)
            service_names = (search_tag(body, [search_tag]).try(:children) || []).map{|node| service_name_from_node(node, key)}
            service_names.each do |service_name|
              next if service_name.blank?
              next if excluded_words.include?(service_name.mb_chars.downcase.to_s)              
              result[service_name] ||= []
              result[service_name] += ([default_url_without_domain] - result[service_name])
            end
          else
            (parsing_class.blank? ? searched_node.css("a") : searched_node.children).each do |node|
            raise(StandardError, [
            ]) if false
              service_name = service_name_from_node(node, key)
              next if service_name.blank?
              next if excluded_words.include?(service_name.mb_chars.downcase.to_s)
              url = url_without_domain(service_url(node, key))
              result[service_name] ||= []
              result[service_name] += ([url] - result[service_name])
            end
          end
        end
        result
      rescue StandardError => e
        {}
      end      
    end
    
    def service_name_from_node(node, key = nil)
      node.text
    end
    
    def service_url(node, key = nil)
      node['href']
    end
    
    def service_desc
      return @service_desc if @service_desc
      @service_desc = search_tag(body, service_tags)
    end
    
    def row_body
      return nil if doc.nil?
      @row_body ||= doc.at_css('body')
    end

    def body
      return nil if row_body.nil?
      return @body if @body
      start = Time.now
      original_body = row_body
      original_body.css("script").remove
      t1 = Time.now - start
      original_body.css("noscript").remove
      t2 = Time.now - start - t1
      original_body.css("img").remove
      t3 = Time.now - start - t1 - t2
      original_body.css("iframe").remove
      original_body.css("style").remove
#      original_body.css("svg").remove
      original_body.css("[rel=stylesheet]").remove
      t4 = Time.now - start - t1 - t2 - t3
      original_body.css("[style]").each{|node| node['style'] = ''}
      original_body.css(".content").remove_class('content').add_class('my_content')
      t5 = Time.now - start - t1 - t2 - t3 - t4
#      original_body.css('.hidden').each{|node| node['hidden'] = 'hidden1'}
#      @body = Nokogiri::XML::Node.new "body", doc
#      @body.children = original_body.children
      @body = original_body
      @body['class'] = "first_body_div"
#      first_body_div = Nokogiri::XML::Node.new "div", doc
#      first_body_div['class'] = "first_body_div"
#      first_body_div.children = original_body.children
#      @body.add_child(first_body_div)
      t6 = Time.now - start - t1 - t2 - t3 - t4 - t5
#      puts "#{[t1, t2, t3, t4, t5, t6]}"
      @body
    end
    
    def clean_body(tags_to_exclude)
      return nil if body.nil?
      tags_to_exclude.each do |tag_to_exclude|
        body.css(tag_to_exclude).remove
      end
      self
    end
    
    def search_tag(base_1, tags, default_url = nil)
      return nil if base_1.nil?

      base = base_1.dup
      tags.each do |tag|        
        temp_result = if tag.is_a?(Array)
          new_node = Nokogiri::XML::Node.new "div", doc
          tag.each do |tag_part|
            tag_part_splitted_by_add_default_url_to_href = tag_part.split(' add_default_url_to_href ')
            if_to_add_default_url_to_href = tag_part_splitted_by_add_default_url_to_href.size > 1 ? true : false
            tag_part_to_use = tag_part_splitted_by_add_default_url_to_href.join(' ')
            base_to_use = base
            
            tag_part_splitted_by_repaire_table = tag_part_to_use.split(' repaire_table ')  
            if tag_part_splitted_by_repaire_table.size > 1
              base_to_use = TableParser::Table.new(base_to_use.css(tag_part_splitted_by_repaire_table[0])).to_nokogiri(base_to_use)
              tag_part_to_use = tag_part_splitted_by_repaire_table[1]
            end
            
            tag_part_splitted_by_add_header_to_column_in_table = tag_part_to_use.split(' add_header_to_column_in_table ')
            if tag_part_splitted_by_add_header_to_column_in_table.size > 1
              base_to_use = add_header_to_column_in_table(base_to_use.css(tag_part_splitted_by_add_header_to_column_in_table[0]))
              tag_part_to_use = tag_part_splitted_by_add_header_to_column_in_table[1]
            end

            tag_part_splitted_by_replace_node_on_a_with_href_from_data_href = tag_part_to_use.split(' replace_node_on_a_with_href_from_data_href ')
            if tag_part_splitted_by_replace_node_on_a_with_href_from_data_href.size > 1
              base_to_use = replace_node_on_a_with_href_from_data_href(base_to_use.css(tag_part_splitted_by_replace_node_on_a_with_href_from_data_href[0]))
              tag_part_to_use = tag_part_splitted_by_replace_node_on_a_with_href_from_data_href[1]
            end
                      
            parsed_tag_part = base_to_use.css(tag_part_to_use)

            (parsed_tag_part || []).map do |node_to_add| 
              node_to_add['href'] = add_default_url_to_url_end(default_url, node_to_add['href']) if if_to_add_default_url_to_href and !node_to_add['href'].blank?
              new_node << node_to_add
            end
          end  
          new_node.children.blank? ? nil : new_node        
        else
          base.at_css(tag)
        end
        return temp_result if !temp_result.blank?
      end
      nil
    end
    
    def page_preview_action_tags
      []
    end
    
    def page_special_action_steps
      []
    end
    
    def base_service_processing
      {
        :fixed_month_payment => fixed_month_payment,
        :fixed_day_payment => fixed_day_payment,
      }
    end
    
    def base_page_processing
      {
        :h1 => h1,
        :error_404 => error_404,
      }
    end
    
    def error_404
      search_tag(body, error_404_tags).try(:text)
    end
    
    def h1
      (service_desc || body).try(:at_css, 'h1').try(:text) || (service_desc || body).try(:at_css, 'h2').try(:text)
    end
    
    def fixed_month_payment
      nodes_text = search_tag(service_desc, fixed_month_payment_tags).try(:text)
      text_to_numbers(nodes_text)[0]
    end

    def fixed_day_payment
      nodes_text = search_tag(service_desc, fixed_day_payment_tags).try(:text)
      text_to_numbers(nodes_text)[0]
    end

    def no_link_from_node
      true
    end

    def url_without_domain(url)
      return url if url.blank?
      splitted_by_domain_url = url.split(domain)
      splitted_by_domain_url.size <= 1 ? url : splitted_by_domain_url[1]
    end
    
    def process_node(node, operations = {})
      operations.each do |operation, operation_params|
        node = if operation_params.blank?
          send(operation.to_sym, node)
        else
          send(operation.to_sym, node, *operation_params)
        end        
      end
      node
    end
    
    def add_default_url_to_url_end(default_url, url_end)
      return url_end if url_end.split('/').size > 1
      default_url_to_use = default_url[-1] == '/' ? default_url : default_url + '/'
      url_end_to_use = url_end[0] == '/' ? url_end[1..-1] : url_end
      "#{default_url_to_use}#{url_end_to_use}"
    end
    
    def add_header_to_column_in_table(base_nodes)
      base_nodes.each do |base_node|

        column_header_names = base_node.css("tr:first-of-type th").map{|th| th.text}         
        column_header_names = base_node.css("tr:first-of-type td").map{|th| th.text} if column_header_names.blank?
        
        base_node.css("tr:first-of-type")[0].remove

        original_node = base_node.clone.css("tr")
        column_header_names[1..-1].each_with_index do |column_header_name, column_header_index|
          base_node.css("tr").each_with_index do |tr, row_index|
            td_to_insert = Nokogiri::XML::Node.new('td',doc)
            td_to_insert.content = column_header_name
            
            tr_to_use = column_header_index == 0 ? tr : original_node[row_index]
            tr_to_use.elements[0].previous = td_to_insert if tr_to_use.try(:elements)
            tr.next = tr_to_use if column_header_index != 0
          end
        end
      end
      base_nodes
    end
    
    def add_third_plus_columns_in_table_as_new_rows(base_nodes)
      result = []
      base_nodes.each do |base_node|
        base_node.css("tr:first-of-type")[0].remove
        
        tbl = Nokogiri::XML::Node.new('table',doc)
        tbody = Nokogiri::XML::Node.new('tbody',doc)        

        column_header_names = base_node.css("tr:first-of-type th").map{|th| th.text}
        column_header_names = base_node.css("tr:first-of-type td").map{|th| th.text} if column_header_names.blank?

        column_header_names[1..-1].each_with_index do |column_header_name, column_header_index|
          base_node.css("tr").each_with_index do |tr, row_index|
            new_tr = Nokogiri::XML::Node.new('tr',doc)

            column_header_td = Nokogiri::XML::Node.new('td',doc)
            column_header_td.content = column_header_name
            new_tr.add_child(column_header_td)

            existing_tds = tr.css("td")

            new_td = Nokogiri::XML::Node.new('td',doc)
            new_td.content = existing_tds[0].try(:content)
            new_tr.add_child(new_td)
            
            new_td = Nokogiri::XML::Node.new('td',doc)
            new_td.content = existing_tds[1 + column_header_index].try(:content)
            new_tr.add_child(new_td)

            tbody.add_child(new_tr)
          end
        end
        tbl.add_child(tbody)
        result << tbl
        base_node.replace(tbl)
      end
      result
    end
    
    def transponse_table(base_nodes)
      base_nodes.each do |base_node|
        new_rows = []
        base_node.css("tr").each_with_index do |row, row_index|
          ((row.css("th") || []) + (row.css("td") || [])).each_with_index do |td, column_index|
            new_rows[column_index] ||= []
            new_rows[column_index][row_index] = td || Nokogiri::XML::Node.new('th',doc)
          end
        end
        
        new_row_nodes = []
        new_rows.each do |new_row_tds|
          new_row = Nokogiri::XML::Node.new('tr',doc)
          new_row_tds.each do |td|
            new_row.add_child(td)
          end
          new_row_nodes << new_row
        end
        
        base_node.css("tr")[0].replace(new_row_nodes[0])
        base_node.css("tr")[1..-1].remove
        current_node = base_node.css("tr")[0]
        new_row_nodes[1..-1].each do |new_row_node|
          current_node.next = new_row_node
          current_node = current_node.next
        end
      end
      base_nodes
    end
    
    def repaire_table(base_nodes)
      result = base_nodes.map do |base_node|
        base_node = TableParser::Table.new(base_node).to_nokogiri(base_node)
      end
      result      
    end
    
    def select_only_first_column_and_column_with_chosen_head(base_nodes, chosen_head)
      chosen_head = normailze_name(chosen_head)
      base_nodes.each do |base_node|
        chosen_head_index = 0
        table_head_th_tag = base_node.at_css("tr > th") ? 'th' : 'td'
        (base_node.css("tr")[0].children || []).each_with_index do |td, column_index|
          head_name = normailze_name(td.text)
          if head_name == chosen_head
            chosen_head_index = column_index
            break
          end
        end
        
        base_node.css("tr").each_with_index do |row, row_index|
          new_row = Nokogiri::XML::Node.new('tr', doc)
#          columns = row_index == 0 ? (row.css(table_head_th_tag) || []) : (row.css("td") || [])
          columns = row.children
          new_row.add_child(columns[0])
          new_row.add_child(columns[chosen_head_index])
          row.replace(new_row)
        end
        raise(StandardError, [
          base_node.to_html
        ]) if false
      end
      base_nodes
    end
    
    def replace_node_on_a_with_href_from_data_href(base_nodes)
      base_nodes.each do |base_node|
        base_node.parent.css("[data-href]").each do |node_with_data_href|
          node_with_data_href.name = 'a'
          node_with_data_href['href'] = node_with_data_href['data-href']
        end
      end
      base_nodes
    end
    
    def add_domain(url_without_domain_1, region_id, privacy_id)
      return url_without_domain_1 if url_without_domain_1.blank?
      url_without_domain = url_without_domain_1[0] == '/' ? url_without_domain_1 : '/' + url_without_domain_1
      "http://#{region_privacy_domain(region_id, privacy_id)}#{url_without_domain}"
    end
    
    def region_privacy_domain(region_id, privacy_id)
      region_prefix = Category::Region::Desc.new(region_id, operator_id).subdomain 
      region_prefix_to_use = region_prefix.blank? ? '' : "#{region_prefix}."
      "#{privacy_prefix(privacy_id)}#{region_prefix_to_use}#{domain}"
    end
    
    def privacy_prefix(privacy_id)
      case 
      when [Category::Operator::Const::Tele2, Category::Operator::Const::Beeline, Category::Operator::Const::Megafon].include?(operator_id)
       ''
      when Category::Operator::Const::Mts == operator_id
        privacy_id == 1 ? 'corp.' : ''
      else
      end
    end

    def domain
      case operator_id
      when Category::Operator::Const::Tele2; 'tele2.ru';
      when Category::Operator::Const::Beeline;  'beeline.ru';
      when Category::Operator::Const::Megafon; 'megafon.ru';
      when Category::Operator::Const::Mts;  'mts.ru';
      else
      end
    end
  end

end