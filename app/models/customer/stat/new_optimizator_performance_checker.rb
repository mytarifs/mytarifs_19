#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'aspector'

class Customer::Stat::NewOptimizatorPerformanceChecker < Aspector::Base #ServiceHelper::PerformanceChecker  
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
    {:method => :calculate_tarif_cost_by_operator, :name => 'calculate_tarif_cost_by_operator', :level => 1},
    {:method => :init_tarif_cost_calculator_general, :name => 'init_tarif_cost_calculator_general', :level => 2},
    {:method => :init_tarif_cost_calculator_stat, :name => 'init_tarif_cost_calculator_stat', :level => 2},
    {:method => :calculate_tarif_cost_by_operator_by_part, :name => 'calculate_tarif_cost_by_operator_by_part', :level => 2},
    {:method => :calculate_final_tarif_sets, :name => 'calculate_final_tarif_sets', :level => 2},
#    {:method => :calculate_tarif_set, :name => 'Final - calculate_tarif_set', :level => 3},
#    {:method => :init_tarif_set_checker, :name => 'Final - init_tarif_set_checker', :level => 3},
#    {:method => :init_current_value_calculator, :name => 'Final - init_current_value_calculator', :level => 3},
#    {:method => :iterate, :name => 'Final - tarif_set_checker.iterate', :level => 3},
#    {:method => :calculate, :name => 'Final.iterate - value_calculator.calculate', :level => 4},
#    {:method => :min_possible_set, :name => 'Final.iterate - value_calculator.min_possible_set', :level => 5},
#    {:method => :min_possible_value, :name => 'Final.iterate - value_calculator.min_possible_value', :level => 5},
#    {:method => :fixed_value, :name => 'Final.iterate - value_calculator.fixed_value', :level => 5},
#    {:method => :tarif_set_for_service_that_depended_on, :name => 'Final.iterate - value_calculator.tarif_set_for_service_that_depended_on', :level => 6},
#    {:method => :next_part_set, :name => 'Final.iterate - tarif_set_checker.next_part_set', :level => 4},
    {:method => :calculate_detailed_final_tarif_results, :name => 'calculate_detailed_final_tarif_results', :level => 2},
#    {:method => :calculate_tarifs_cost_by_tarif, :name => 'calculate_tarifs_cost_by_tarif', :level => 3},
    {:method => :save_final_tarif_results, :name => 'save_final_tarif_results', :level => 2},
    {:method => :update_call_stat, :name => 'update_call_stat', :level => 2},
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
