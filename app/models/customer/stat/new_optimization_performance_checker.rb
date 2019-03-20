#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'aspector'

class Customer::Stat::NewOptimizationPerformanceChecker < Aspector::Base #ServiceHelper::PerformanceChecker  
  include Customer::Stat::PerformanceChecker::Helper
  
  attr_reader :name, :start #, :output_model
  attr_accessor :results
  
  def initialize(name = nil)
    @name = name || 'performance_checker'
#    @output_model = Customer::Stat.where(:result_type => 'performance_checker').where(:result_name => @name)
    @start = current
    @results = {}
  end

  check_points = [
    {:method => :calculate_final_tarif_sets_by_tarif_from_prepared_tarif_results, :name => 'calculate_final_tarif_sets_by_tarif_from_prepared_tarif_results', :level => 1},
    {:method => :calculate_tarif_cost_by_tarif, :name => 'calculate_tarif_cost_by_tarif', :level => 1},
    {:method => :init_preloaded_data, :name => 'init_preloaded_data', :level => 2},
    {:method => :init_general_preloaded_data_for_optimization, :name => 'init_general_preloaded_data_for_optimization', :level => 3},
    {:method => :init_general_preloaded_data_for_optimization_for_operator, :name => 'init_general_preloaded_data_for_optimization_for_operator', :level => 3},
    {:method => :init_specific_preloaded_data_for_optimization_for_operator, :name => 'init_specific_preloaded_data_for_optimization_for_operator', :level => 3},
    {:method => :init_general_preloaded_data_for_optimization_for_tarif, :name => 'init_general_preloaded_data_for_optimization_for_tarif', :level => 3},
    {:method => :init_tarif_cost_calculator, :name => 'init_tarif_cost_calculator', :level => 2},
    {:method => :update_call_stat, :name => 'update_call_stat', :level => 2},
    {:method => :calculate_tarifs_results_by_tarif, :name => 'calculate_tarifs_results_by_tarif', :level => 2},
    {:method => :calculate_final_tarif_sets, :name => 'calculate_final_tarif_sets', :level => 2},
#    {:method => :iterate, :name => 'Final - tarif_set_checker.iterate', :level => 3},
#    {:method => :tarif_set_for_service_that_depended_on, :name => 'Final.iterate - value_calculator.tarif_set_for_service_that_depended_on', :level => 6},
    {:method => :calculate_detailed_final_tarif_results, :name => 'calculate_detailed_final_tarif_results', :level => 2},
    {:method => :save_final_tarif_results, :name => 'save_final_tarif_results', :level => 2},
  ]

  check_points.each do  |check_point|
    around check_point[:method] do |proxy, *arg, &block|
      @performance_checker.add_check_point(check_point[:name], check_point[:level]) if @performance_checker
      result = proxy.call(*arg, &block)
      @performance_checker.measure_check_point(check_point[:name]) if @performance_checker
      result
    end
  end
end
