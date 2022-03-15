// package distances.model
package distances

package object model {

type Latitude  = Double
type Longitude = Double

case class Point(latitude: Latitude, longitude: Longitude) {

  def toRadians: Point = Point(math.toRadians(latitude), math.toRadians(longitude))
}

}
