require 'dm-core'
require 'geo_ruby'
module DataMapper
  class Property
    class PostGIS < Object
      include GeoRuby::SimpleFeatures
      
      def primitive?(value)
        value.kind_of? Geometry
      end
      
      def dump(value)
        value.nil? ? nil : value.as_hex_ewkb
      end
      
      def valid?(value, negated = false)
        super || dump(value).kind_of?(::String)
      end
      
      def load(value)
        value.nil? ? nil : Geometry.from_hex_ewkb(value)
      end
      
      def typecast_to_primitive(value)
        load(value)
      end

      def preferred_index
        'GIST'
      end
    end # class PostGIS

    class PostGISGeometry < PostGIS
    end
    class PostGISGeography < PostGIS
    end

  end # class Property
end # module DataMapper
