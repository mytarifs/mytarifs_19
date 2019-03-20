class Api::V1::FastOptimizationsController < Api::V1::BaseController
  include Comparison::FastOptimizationsHelper
  
  def test
    redirect_to api_v1_fast_optimizations_path(test_params)
  end
  
  def index
    optimization_params = params[:optimization_param]
    result_type = params[:result_type]
    result_number = params[:result_number]
    
    row_results = fast_optimization_presenter.result_presentation(optimization_params, result_type, result_number)
    
    output = [] 
    row_results.each do |result_id, result_value|
      output << result_value.slice(:operator_name, :tarif_name, :option_names, :price)
    end
    
    render json: output
  end
  
  def input_params
    render json: formatted_input_params
  end
  
  def formatted_input_params
    result = []
    fast_optimization_options.each do |part, option|
      param_values = []
      
      option[:options].each do |key, value|
        param_values << {
          :key => key,
          :name => value
        }
      end
      
      result << {
        :param_name => :optimization_param,
        :key => part,
        :values => param_values
      }
    end

    result << {
      :param_name => :result_type,
      :key => :result_type,
      :values => [:best_result]
    }

    result << {
      :param_name => :result_number,
      :key => :result_number,
      :values => (1..10).map{|i| i}
    }

    result << {
      :example_url => "http://www.mytarifs.ru/api/v1/fast_optimizations/test"
    }
    result
  end
  
  def test_params
    test_params = {}

    fast_optimization_options.each do |part, option|     
      test_params[:optimization_param] ||= {}
      test_params[:optimization_param][part] = option[:options].keys[1].to_s
    end

    test_params[:result_type] = :best_result
    test_params[:result_number] = 5    
    test_params
  end
  
end
