module Cpanet
  class Base
    include HTTParty
    debug_output
    
    attr_reader :options, :doc
    
    def initialize(options = {})
      @options = match_params(options)
    end
    
    def parsed_catalog
      file_url = options[:file_url]
      file = load_file(file_url)      
      @doc = Nokogiri::XML(file) 
    end
    
    def load_file(file_url)
      file_check = check_load_file(file_url)
      return file_check['error'] if file_check['error']
      
      cache_file(file_url)            
    end
    
    def cache_file(file_url, file = nil)
      cache_key = file_url    
      
      Rails.cache.delete(cache_key) if options[:clean_cache] == 'true'
      
      if Rails.cache.exist?(cache_key)
        Rails.cache.fetch(cache_key)
      else
        result = file || open(file_url).read
        has_no_error = true
        Rails.cache.write(cache_key, result, :expires_in => 1.hours) if has_no_error
        result
      end
    end
    
    def check_load_file(file_url)
      response = HTTParty.head(file_url)
      file_size = response.headers['content-length'] || 0
      file_size = file_size.is_a?(Array) ? file_size[0].try(:to_i) : file_size.try(:to_i)
      raise(StandardError) if false

      file_size > 5000000 ? {'error' => "File to big, size is #{file_size}"} : {'ok' => file_size}
    end
    
    def catalog_with_deeplinks
      run_command(:catalog_with_deeplinks)
    end
    
    def websites
      run_command(:websites)
    end
    
    def my_offers
      run_command(:my_offers)
    end
    
    def offer
      result = run_command(:offer)
      result.is_a?(Array) ? result[0] : result
    end
    
    def landings
      run_command(:landings)
    end
    
    def catalogs
      run_command(:catalogs)
    end
    
    def run_command(command)
      cache_key = command_cache_key(command)    
      
      Rails.cache.delete(cache_key) if options[:clean_cache] == 'true'
      
      if Rails.cache.exist?(cache_key)
        Rails.cache.fetch(cache_key)
      else
        result = run_command_without_processing_result(command)
        if ((options[:run_command_without_processing] || 'false') == 'true')
          result = result.to_xml if result.respond_to?(:to_xml)
        else
          result = process_result(command, result)
        end
                 
        Rails.cache.write(cache_key, result, :expires_in => 1.hours) if !processed_result_has_error?(result)
        result
      end
      
    end
    
    def run_command_without_processing_result(command)
      path, params = generate_url_params(command)
      command_type = default[:commands][command][:command_type] || :get
      self.class.send(command_type, path, params)
    end
    
    def generate_url_params(command)
      path = prepare_path(command)
      command_params = options.slice(*default[:commands][command][:params])
      scope = default[:commands][command][:scope]
      
      params = base_options_with_auth(scope).deep_merge({:query => command_params})
      
      [path, params]
    end
    
    def process_result(command, result)
      result_error = error(result)      
      return result_error if !result_error.nil?
      
      result_to_process = default[:result][command][:without_main_result_key] ? result : result.try(:[], default[:result_key]) 
      result_to_process = result_to_process.try(:[], default[:result][command][:result_sub_key]) if default[:result][command][:result_sub_key] 
      return result if result_to_process.nil?
      
      processed_result = []
      result_to_process = [result_to_process] if !result_to_process.is_a?(Array)

      result_to_process = preproces_result_item_to_process_for_sub_arrays(command, result_to_process)
      result_to_process.each do |result_item|          
        if result_item.is_a?(Array)
          result_item = preproces_result_item_to_process_for_sub_arrays(command, result_item)
          result_item.each do |result_sub_item|
            processed_result << process_result_item(command, result_sub_item)
          end
        else
          processed_result << process_result_item(command, result_item)
        end          
      end

      processed_result
    end
    
    def preproces_result_item_to_process_for_sub_arrays(command, result_to_process)
      result_sub_array_key = default[:result][command][:result_sub_array_key]
      
      return result_to_process if result_sub_array_key.blank?
      
      result = []
      result_to_process.each do |result_item|
        result_item_without_sub_result = result_item.except('result_sub_array_key')

        (result_item.try(:[], result_sub_array_key) || []).each do |sub_result_item|          
          result << result_item_without_sub_result.merge(result_sub_array_key => sub_result_item)
        end
      end      
      result
    end
    
    def process_result_item(command, result_item)
      result = {}
      result_item.each do |original_key, value|        
        next if options[:show_only_command_keys] == 'true' and !(default[:result][command][:keys] || []).include?(original_key)
        next if (default[:result][command][:keys_to_skip_process] || []).include?(original_key)
        processed_key = default[:result][command][:keys][original_key] || original_key
        if processed_key.is_a?(Hash)
          processed_key.each do |original_sub_key, processed_sub_key|
            if processed_sub_key.is_a?(Hash)
              processed_sub_key.each do |original_sub_sub_key, processed_sub_sub_key|
                result[processed_sub_sub_key] = value.try(:[], original_sub_key).try(:[], original_sub_sub_key)
              end              
            else
              result[processed_sub_key] = value.try(:[], original_sub_key)
            end            
          end
        else
          result[processed_key] = value
        end        
      end

      result[:all_keys] = result_item.keys
      result
    end
    
    def base_options_with_auth(scope = [])
      base_options.deep_merge(auth_options(scope))
    end
    
    def command_cache_key(command)
      param_keys = if default[:commands][command][:params].blank?
        (default[:commands][command][:path] || "").scan(/(?<={).*?(?=})/).map do |path_param|
          "#{path_param}=#{options[path_param.to_sym]}" if !options[path_param.to_sym].blank?
        end.compact.join(", ")
      else
        (default[:commands][command][:params] || []).map{|command_param| "#{command_param}=#{options[command_param]}"}.join(", ")
      end
      
      "#{self.class}_#{command}#{param_keys}"
    end
    
    def base_options; {}; end
    def auth_options; {}; end

    def processed_result_has_error?(processed_result)
      processed_result.is_a?(Hash) and processed_result.try(:[], 'error')
    end
    
    def prepare_path(command)
      final_path = default[:commands][command][:path].dup
      final_path.scan(/(?<={).*?(?=})/).each do |path_param|
        final_path.gsub!("{#{path_param}}", options[path_param.to_sym].try(:to_s)) if !options[path_param.to_sym].blank?
      end
      final_path
    end
    
    def match_params(options)
      default[:param_matches].each do |original_key, final_key|
        options[final_key] = options[original_key] if !options[original_key].nil?
      end
      options
    end
        
  end
  
end