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


  def classify_transporteurs() : Obj = {
      Obj(
        "compatibles" -> Arr(),
        "partiellement-compatibles" -> Arr(),
        "non-compatibles" -> Arr()
      )
  }

//   @post("/json")
//   def jsonEndpointObj() : Obj = {
//   }

  @get("/")
  def hello(): String = myfunc()



  @post("/reverse")
  def reverse(request: Request): String =
    new String(request.readAllBytes()).reverse + "aaa "

//   @post("/reverse")
//   def reverse(request: Request): String =
//     new String(request.readAllBytes()).reverse + "aaa "


//   @post("/json")
//   def json(request: Request): String = {
//     val json = ujson.read(request.readAllBytes())
//     val json = ujson.read(request.text())
//     "got it"
//   }



  @cask.postJson("/json2")
  def jsonEndpoint(value1: ujson.Value, value2: Seq[Int]) = {
    "OK " + value1 + " " + value2
  }

//   case class MyLivraison(value1: String)

//   @cask.postJson("/json")
//   def jsonEndpointObj(id: String, coordRetrait: ujson.Obj ): String = {
//       "got it"
//   }

//   case class Coord(latitude: Float) {
//   case object Coord(latitude: Float) {
//     def InputParser() : Unit = {
//     }
//   }

  @cask.postJson("/json")
  def jsonEndpointObj(
    id: String,
    coordRetrait: Obj,
    coordLivraison: Obj,
    creneau: Obj,
    VolumeInM3: Value,
    PacketWeightInKg: Value
  ): Obj = {
    classify_transporteurs()
  }

//   @postJson("/test")
//   def jsonEndpointObj(myjson: MyType ): String = {
//     "/test it works"
//   }

  @postJson("/test2")
  def jsonEndpointObj(livraison: Livraison ): String = {
    "/test2: it works"
  }


  initialize()

//   println(Point(50.0, 30.0))

}


case class Coord(from: Float, to: Float)
object Coord {

  import upickle.default._

  implicit val rw: ReadWriter[Coord] = macroRW
}

// case class Livraison(id: String, coordRetrait: String)
case class Livraison(id: String, coordRetrait: Coord)
object Livraison {

  import upickle.default._

  implicit val rw: ReadWriter[Livraison] = macroRW
}



