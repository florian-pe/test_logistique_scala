import scala.io.Source
import cask._
import ujson._
import definitions._
import distances.bird
import distances.model._

object Main extends MainRoutes {

  val json_string = Source.fromFile("tests/transporteurs.json").mkString
  val transporteurs_static = ujson.read(json_string)

//   type EpochTime = Int  // secondes
//   type Distance = Float // kilometres
//   type Volume = Float   // metres cubes
//   type Poids = Float    // kilogrammes
//   case class plage_horaire(debut : EpochTime, fin : EpochTime)
//   case class CoordGPS(x : Float, y : Float)
//   case class ZoneGeo(centre : CoordGPS, rayon : Distance)
//   case class transporteur(
//     id : Int,
//     horaires : plage_horaire,
//     zone : ZoneGeo,
//     volume_max : Volume,
//     poids_max : Poids
//   )


  def classify_transporteurs(livraison: Livraison) : Obj = {
      Obj(
        "compatibles" -> Arr(),
        "partiellement-compatibles" -> Arr(),
        "non-compatibles" -> Arr()
      )
  }

  @postJson("/json")
  def jsonEndpointObj(livraison: Livraison) : Obj = {
    classify_transporteurs(livraison)
  }


  initialize()

}


case class Coord(latitude: Float, longitude: Float)
object Coord {
  import upickle.default._
  implicit val rw: ReadWriter[Coord] = macroRW
}

case class CreneauHoraire(start: String, end: String)
object CreneauHoraire {
  import upickle.default._
  implicit val rw: ReadWriter[CreneauHoraire] = macroRW
}

case class Livraison(
  id: String,
  coordRetrait: Coord,
  coordLivraison: Coord,
  creneau: CreneauHoraire,
  VolumeInM3 : Float,
  PacketWeightInKg: Float
)
object Livraison {
  import upickle.default._
  implicit val rw: ReadWriter[Livraison] = macroRW
}


