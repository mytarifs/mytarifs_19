module Scraper
   
  class WebScraper
    include Capybara::DSL
    attr_reader :options

    def initialize(options = {})
      @options = options
      if options[:use_selenium] == 'true'
        Capybara.run_server = false
        Capybara.current_driver = :selenium
        Capybara.app_host = nil
        Capybara.default_max_wait_time = 120
        Capybara.javascript_driver = :selenium

        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/xml,application/xml'
      
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(
            app, { browser: :firefox, profile: profile}
          )
        end
      
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, js_errors: false)
        end
      else
        Capybara.default_driver = :poltergeist
    
        Capybara.register_driver :poltergeist do |app|
          options = { 
            js_errors: false,
            timeout: 120,
            headers: { 'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)" } 
          }
          Capybara::Poltergeist::Driver.new(app, options)
        end
      end      
    end
 
    def scrape
      yield page
    end
 
    def self.scrape(&block)
      new.scrape(&block)
    end    
    
    def process_all_modals(page, modal_tags)
      check_modals = []
      begin
        (modal_tags - check_modals).each do |modal_tag|
          result = process_modal(page, modal_tag)
          if result == true
            check_modals << modal_tag
            puts "raise in process_all_modals"
            raise StandardError
          end
        end
      rescue StandardError
        retry
      end
    end

    def process_page_preview_actions(page, page_preview_action_tags) 
      page_preview_action_tags.each do |page_preview_action_tag|
        process_modal(page, page_preview_action_tag)
      end
    end

    def process_page_special_actions(page, page_special_action_steps)
      if page_special_action_steps.blank?
        yield [[], page, []]
      else
        page_special_action_steps[0][:keys].each do |first_level_key|                    
          if !page_special_action_steps[1].blank?
            page_special_action_steps[1][:keys].each do |second_level_key|                            
              if !page_special_action_steps[2].blank?
                page_special_action_steps[2][:keys].each do |third_level_key|                                    
                  if !page_special_action_steps[3].blank?
                    page_special_action_steps[3][:keys].each do |fourth_level_key|      
                      process_page_special_action(page, page_special_action_steps[0], first_level_key)
                      process_page_special_action(page, page_special_action_steps[1], second_level_key)
                      process_page_special_action(page, page_special_action_steps[2], third_level_key)
                      process_page_special_action(page, page_special_action_steps[3], fourth_level_key)
                      process_page_special_action_post_select(page, page_special_action_steps[3], fourth_level_key)   

                      page.has_selector?(page_special_action_steps[3][:scope_to_save_tags][0], :visible => true, :wait => 5.0)          
      
                      yield [[first_level_key, second_level_key, third_level_key, fourth_level_key], page, page_special_action_steps[3][:scope_to_save_tags], page_special_action_steps[3][:my_title]]
                      if page_special_action_steps[3][:page_go_back_after_yield] == true
                        go_back_result = page.go_back 
                        puts "go_back_result #{go_back_result}"
                      end
                    end
                  else
                    process_page_special_action(page, page_special_action_steps[0], first_level_key)
                    process_page_special_action(page, page_special_action_steps[1], second_level_key)
                    process_page_special_action(page, page_special_action_steps[2], third_level_key)
                    process_page_special_action_post_select(page, page_special_action_steps[2], third_level_key)
                    
                    page.has_selector?(page_special_action_steps[2][:scope_to_save_tags][0], :visible => true, :wait => 5.0)
                      
                    yield [[first_level_key, second_level_key, third_level_key], page, page_special_action_steps[2][:scope_to_save_tags], page_special_action_steps[2][:my_title]]
                    if page_special_action_steps[2][:page_go_back_after_yield] == true
                      go_back_result = page.go_back 
                      puts "go_back_result #{go_back_result}"
                    end
                  end
                end
              else       
                process_page_special_action(page, page_special_action_steps[0], first_level_key)
                process_page_special_action(page, page_special_action_steps[1], second_level_key)
                process_page_special_action_post_select(page, page_special_action_steps[1], second_level_key)    
                
                page.has_selector?(page_special_action_steps[1][:scope_to_save_tags][0], :visible => true, :wait => 5.0)
                     
                yield [[first_level_key, second_level_key], page, page_special_action_steps[1][:scope_to_save_tags], page_special_action_steps[1][:my_title]]
                if page_special_action_steps[1][:page_go_back_after_yield] == true
                  go_back_result = page.go_back 
                  puts "go_back_result #{go_back_result}"
                end
              end
            end
          else 
            process_page_special_action(page, page_special_action_steps[0], first_level_key)          
            process_page_special_action_post_select(page, page_special_action_steps[0], first_level_key) 
            
            page.has_selector?(page_special_action_steps[0][:scope_to_save_tags][0], :visible => true, :wait => 5.0)
            
            yield [[first_level_key], page, page_special_action_steps[0][:scope_to_save_tags], page_special_action_steps[0][:my_title]]
            if page_special_action_steps[0][:page_go_back_after_yield] == true
              go_back_result = page.go_back 
              puts "go_back_result #{go_back_result}"
            end
          end
        end
      end
    end
    
    def process_page_special_action(page, action_params, current_key)
      if action_params[:start_select] and process_modal(page, action_params[:start_select]) == false
        puts "no start_select_elements for key #{current_key} and select_params #{select_params}" 
        return false 
      end
      
      select_params = action_params[:select]
      select_params[:element_tags].map{|element_tag| element_tag[:text] = current_key} if select_params[:use_key]
      raise(StandardError) if select_params[:use_key] and select_params[:element_tags][0][:text] != current_key
      
      action_result = process_modal(page, select_params)
            
      if action_result == false
        close_action_result = process_modal(page, action_params[:fail_select])
        if close_action_result == false
          puts "cannot close select window for key #{current_key} and select_params #{select_params}" 
          return false 
        else
          puts "there is no select item for key #{current_key} and select_params #{select_params}" 
          return false 
        end
      else
        puts "processed special_action item for key #{current_key} and select_params #{select_params}"
        return true
      end
      
    end

    def process_page_special_action_post_select(page, action_params, current_key)
      select_params = action_params[:select]
      select_params[:element_tags].map{|element_tag| element_tag[:text] = current_key} if select_params[:use_key]

      if action_params[:post_select]
        post_select_action_result = process_modal(page, action_params[:post_select])
        if post_select_action_result == false
          puts "fail to process special_action item for key #{current_key} and select_params #{select_params} with post_select #{action_params[:post_select]}"
          return false
        else
          puts "processed special_action_post_select item for key #{current_key} and select_params #{select_params} with post_select #{action_params[:post_select]}"
          return true
        end
      end
    end

    def process_modal(page, modal_tag, wait_time = 0.01)
      return false if modal_tag.blank?      
      modal_tag[:scope].each do |scope_tag|
        puts scope_tag
        puts "scope_tag page.has_selector?(#{scope_tag}) #{page.has_selector?(scope_tag, :wait => wait_time)}"
        scope_hash = {:wait => wait_time}
        scope_hash.merge!({:visible => modal_tag[:scope_visible]}) if modal_tag[:scope_visible]
        if page.has_selector?(scope_tag, scope_hash)          
          within(scope_tag) do
            modal_tag[:element_tags].each do |element|
              puts "before page.click_on element=#{element}"
              element_hash = {:text => element[:text], :wait => wait_time}
              element_hash.merge!({:visible => element[:visible]}) if element[:visible]
              if_has_selector = has_selector?(element[:css], element_hash)
              puts "element page.has_selector?(#{element}) #{if_has_selector}"
              if if_has_selector                  
                begin
                  case 
                  when (element[:type] == :find or element[:text].blank?)
                    finded_element = find(element[:css], element_hash.merge!({match: :first}))
                    if options[:use_selenium] == 'true'
                      finded_element.click
                    else
                      finded_element.trigger("click")
                    end                     
                    puts finded_element.try(:attr, 'http')
                    puts "after find.click"
                    return true
                  else
                    click_on(element[:text], :wait => wait_time)
                    puts "after page.click_on"
                    return true
                  end
                end                
              end              
            end
          end
        end
      end
    end

  end

end