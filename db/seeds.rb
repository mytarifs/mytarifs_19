case ENV["seed_option"]
when "seeds_for_users"
  Dir[Rails.root.join("db/seeds/seeds_for_users.rb")].each { |f| require f }
when "seeds_for_tarif_autoload"
  Dir[Rails.root.join("db/seeds/seeds_for_tarif_autoload.rb")].each { |f| require f }
when "seeds_for_content_related"
  Dir[Rails.root.join("db/seeds/seeds_for_content_related.rb")].each { |f| require f }
when "seeds_for_tarif_related"
  Dir[Rails.root.join("db/seeds/seeds_for_tarif_related.rb")].each { |f| require f }
  optimization_runner = Optimization::Runner.new()
  optimization_runner.clean_cache(optimization_runner.options)
  optimization_runner.reload_general_cache(optimization_runner.options)
when "seeds_for_comparison_related"
  Dir[Rails.root.join("db/seeds/seeds_for_comparison_related.rb")].each { |f| require f }
when "test_load"
  Dir[Rails.root.join("db/seeds/seeds_for_users.rb")].each { |f| require f }
  Dir[Rails.root.join("db/seeds/seeds_for_tarif_related.rb")].each { |f| require f }
end

#to set correct id for new records
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end