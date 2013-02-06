require 'dm-core'
require 'dm-migrations'
require 'dm-postgres-adapter'
require 'dm-postgis/operators'
require 'dm-custom-index'

module DataMapper

  class Property
    autoload :PostGISGeometry,            'dm-postgis/pg_geometry'
    autoload :PostGISGeography,           'dm-postgis/pg_geometry'
  end

  module PostGIS
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def type_map
        super.merge(
                    DataMapper::Property::PostGISGeometry => { :primitive => 'GEOMETRY' },
                    DataMapper::Property::PostGISGeography => { :primitive => 'GEOGRAPHY' }
                    ).freeze
      end # type_map
    end # module ClassMethods
  end # module PostGIS
end # module DataMapper

DataMapper::Adapters::PostgresAdapter.send(:include,DataMapper::PostGIS)
