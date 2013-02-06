# dm-postgis

Very simple type for datamapper allowing storing GeoRuby Geometries types in Postgis. This uses GeoRuby to do all the hard work. Here's an example:

```ruby

class Foo
  include DataMapper::Resource
  
  property :id, Serial
  property :name, Integer
  property :geom, PostGISGeometry
end

# create a GeoRuby LineString
line = GeoRuby::SimpleFeatures::LineString.new(4236)
# add some points
[[12.12,13.14], [12.13,14.15], [12.15,16.17]].each{|x,y| line.points << GeoRuby::SimpleFeatures::Point.from_x_y(x,y)}
# stick it in the db!
f = Foo.create(:name => "random geometry", :geom => line)
```

## Types

PostGISGeometry and PostGISGeography types are supported. (See the PostGIS docs for the difference. Geometry is the classic PostGIS type; you can set an SRID (projection) for each column, though you'll need to do that directly in the database. Geography is unprojected lat/long and slightly slower.)

If you ask DataMapper to create an index on a PostGISGeometry or PostGISGeography property, dm-postgis will create a GIST index rather than a B-Tree one (much faster for spatial data).

## Operators

dm-postgis provides operators which carry out popular PostGIS functions. You can use them when finding records, like this:

    Road.all( :linestring.crosses=> this_road.linestring )

...will return all roads which cross the `linestring` property of `this_road`.

    Shop.all( :location.distance=>[route.linestring, 0.1] )

...will return all shops within 0.1 degrees of the `linestring` property of `route`.

*In the following definitions, A is the property to the left of the operator, B the property to the right.*

 - **.bbox\_overlaps**: do A and B's bounding boxes overlap? (PostGIS &&.)
 - **.bbox\_contains**: does A's bounding box contain B? (PostGIS ~.)
 - **.bbox\_contained\_by**: is A's bounding box contained by B? (PostGIS @.)
 - **.covers**: does A's area cover B? (PostGIS ST_Covers.)
 - **.covered\_by**: is A covered by B's area? (PostGIS ST_CoveredBy.)
 - **.crosses**: do A and B cross? (PostGIS ST_Crosses.)
 - **.disjoint**: are A and B disjoint (i.e. do not cross)? (PostGIS ST_Disjoint.)
 - **.distance => [B, distance]**: are A and B within `distance` of each other? `distance` is SRID units for PostGISGeometry, metres for PostGISGeography. Note that this operator takes an array with two arguments; the first is geometry/geography B, the second is the distance. (PostGIS ST_DWithin.)
 - **.intersects**: do A and B share any space? (PostGIS ST_Intersects.)
 - **.overlaps**: do A and B overlap without being completely contained by each other? (PostGIS ST_Overlaps.)
 - **.touches**: do A and B have at least one point in common? (PostGIS ST_Touches.)

## Known issues

Lots of this library is new, and the gem and tests haven't been updated yet. So if you're using it, you'll probably need to copy the lib/ folder to somewhere where your path can find it, rather than installing it as a gem.

## Copyright

Copyright (c) 2010 Roman Kamyk jr, 2012 svs, 2013 Richard Fairhurst. See LICENSE for details.
