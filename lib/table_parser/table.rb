module TableParser
  class Table
    attr_reader :nodes, :columns
    def initialize(row_table, options={})
      if options.has_key?(:header)
        header = options[:header]
      else
        header = true
      end
      
      if options.has_key?(:dup_rows)
        dup_rows = options[:dup_rows]
      else
        dup_rows = true
      end
      
      if options.has_key?(:dup_cols)
        dup_cols = options[:dup_cols]
      else
        dup_cols = true
      end

      table = Parser.extract_table(row_table)
      @columns = Parser.extract_column_headers(table, dup_rows, dup_cols, header)
      @nodes = Parser.extract_nodes(table, @columns, dup_rows, dup_cols)
    end
  
    def to_s
      "Table<#{@columns.collect{|h| h.to_s }.join(",")}>"
    end
    
    def to_nokogiri(doc)
      table = Nokogiri::XML::Node.new "table", doc
      tbody = Nokogiri::XML::Node.new "tbody", doc

      tr = Nokogiri::XML::Node.new "tr", doc
      columns.each do |column|
        th = Nokogiri::XML::Node.new(column.try(:element).try(:name) || 'th', doc)
        th.content = column.try(:text)
        tr.add_child(th)          
      end
      tbody.add_child(tr)

      max_column_size = columns.map{|c| (c || []).size}.max
      max_column_size.times do |row_index|
        tr = Nokogiri::XML::Node.new "tr", doc
        columns.size.times do |column_index|
          node = nodes[column_index][row_index]
          td = Nokogiri::XML::Node.new((node.try(:element).try(:name) || 'td'), doc)
          td.content = node.try(:text)
          tr.add_child(td)          
        end    
        tbody.add_child(tr)    
      end
      table.add_child(tbody)
      table
    end

    # get column by index
    def [](index)
      @columns[index]
    end
  end
end