module Model exposing (..)

import Json.Decode as Json exposing (..)

type alias Model = {
  session: String 
  -- login
  , username: String
  , password: String
  -- company stuff
  , name: String
  , lat: String
  , lon: String 
  , postcode: String 
  , companies: List Company
  -- misc
  , res : String
  }

initModel = Model "" "" "" "" "" "" "" [] ""

-- json stuff

type alias Technology = {id: String, name: String}
type alias Company = {id: String, name: String, lat: String, lon: String, postcode: String, technologies: Maybe (List Technology)}

decodeCompanies : Json.Decoder (List Company)
decodeCompanies = 
  let comps = Json.list comp
      comp  = Json.object6 Company 
        ("id" := Json.string) 
        ("name" := Json.string) 
        ("lat" := Json.string) 
        ("lon" := Json.string) 
        ("postcode" := Json.string) 
        tlist
      tlist = Json.maybe ("technologies" := Json.list titem)
      titem = Json.object2 Technology ("id" := Json.string) ("name" := Json.string)
  in
    "companies" := comps
