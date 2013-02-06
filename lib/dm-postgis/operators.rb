module DataMapper
  class Query

    module Conditions

      class DistanceComparison < AbstractComparison
        slug :distance
		attr_reader :radius
		def initialize(subject, value)
			@radius=value[1]
			super subject,value[0]
		end
        def comparator_string; "[ST_DWithin #{@radius}]" end     # used only for to_s
      end

      class BboxOverlapsComparison < AbstractComparison
        slug :bbox_overlaps
        def comparator_string; "&&" end
      end

      class BboxContainsComparison < AbstractComparison
        slug :bbox_contains
        def comparator_string; "~" end
      end

      class BboxContainedByComparison < AbstractComparison
        slug :bbox_contained_by
        def comparator_string; "@" end
      end

      class CoversComparison < AbstractComparison
        slug :covers
        def comparator_string; "[ST_Covers]" end
      end

      class CoveredByComparison < AbstractComparison
        slug :covered_by
        def comparator_string; "[ST_CoveredBy]" end
      end

      class CrossesComparison < AbstractComparison
        slug :crosses
        def comparator_string; "[ST_Crosses]" end
      end

      class DisjointComparison < AbstractComparison
        slug :disjoint
        def comparator_string; "[ST_Disjoint]" end
      end

      class IntersectsComparison < AbstractComparison
        slug :intersects
        def comparator_string; "[ST_Intersects]" end
      end

      class OverlapsComparison < AbstractComparison
        slug :overlaps
        def comparator_string; "[ST_Overlaps]" end
      end

      class TouchesComparison < AbstractComparison
        slug :touches
        def comparator_string; "[ST_Touches]" end
      end

    end
  end

  module Adapters
    class DataObjectsAdapter < AbstractAdapter
      chainable do
        def comparison_operator(comparison)
          if comparison.subject.is_a?(DataMapper::Property::PostGISGeometry) ||
             comparison.subject.is_a?(DataMapper::Property::PostGISGeography) then
            case comparison.slug
              when :distance then "ST_DWITHIN(%s,?,#{comparison.radius})"
              when :bbox_overlaps then '&&'
              when :bbox_contains then '~'
              when :bbox_contained_by then '@'
              when :covers then "ST_COVERS(%s,?)"
              when :covered_by then "ST_COVEREDBY(%s,?)"
              when :crosses then "ST_CROSSES(%s,?)"
              when :disjoint then "ST_DISJOINT(%s,?)"
              when :intersects then "ST_INTERSECTS(%s,?)"
              when :overlaps then "ST_OVERLAPS(%s,?)"
              when :touches then "ST_TOUCHES(%s,?)"
              else super(comparison)
            end
          else
            super(comparison)
          end # if
        end # def comparison_operator
      end # chainable
    end # class
  end # module Adapters
end # module DataMapper

class Symbol
  def distance;          DataMapper::Query::Operator.new(self, :distance) end
  def bbox_overlaps;     DataMapper::Query::Operator.new(self, :bbox_overlaps) end
  def bbox_contains;     DataMapper::Query::Operator.new(self, :bbox_contains) end
  def bbox_contained_by; DataMapper::Query::Operator.new(self, :bbox_contained_by) end
  def covers;            DataMapper::Query::Operator.new(self, :covers) end
  def covered_by;        DataMapper::Query::Operator.new(self, :covered_by) end
  def crosses;           DataMapper::Query::Operator.new(self, :crosses) end
  def disjoint;          DataMapper::Query::Operator.new(self, :disjoint) end
  def intersects;        DataMapper::Query::Operator.new(self, :intersects) end
  def overlaps;          DataMapper::Query::Operator.new(self, :overlaps) end
  def touches;           DataMapper::Query::Operator.new(self, :touches) end
end
