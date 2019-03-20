module RakeHelper
  module General

#to set correct id for new records
    def self.reset_table_ids(table_names = [])
      wrong_table_names = table_names - ActiveRecord::Base.connection.tables
      abort "Wrong table names: [#{wrong_table_names}]" if !wrong_table_names.blank?
      
      table_names_to_reset_ids = table_names.blank? ? ActiveRecord::Base.connection.tables : table_names
      table_names_to_reset_ids.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
    end

  end
end  