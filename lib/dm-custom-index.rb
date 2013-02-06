# A little monkey-patch to enable different index types to be created
# rather than simply the default (e.g. GIST rather than BTree in Postgres).
#
# TODO: patch create_unique_index_statements too (useful for LTree).

module DataMapper
  module Migrations
    module DataObjectsAdapter
      module SQL
        alias_method :old_create_index_statement, :create_index_statement
        def create_index_statement(model, index_name, fields)
          statement=old_create_index_statement(model, index_name, fields)
          index_type=nil
          fields.each { |field| index_type ||= model.send(field).preferred_index }
          statement.gsub!(' ('," USING #{index_type} (") unless index_type.nil?
        end # def
      end # module SQL
    end # module DataObjectsAdapter
  end # module Migrations
end # module DataMapper
