module Model exposing (..)

import Json.Decode as Json exposing (..)

type alias Model = {
  page:           String
  , session:        String
  , loginInput:   LoginInputModel
  , companyInput: CompanyInputModel
  , techAddInput: TechAddInputModel
  , companies:    List Company
}

initModel = Model "home" "" initLoginInputModel initCompanyInputModel initTechAddInput []

-- input

type alias LoginInputModel = {
  username : String
  , password : String
  , loginPressInvalid: Bool
}

initLoginInputModel = LoginInputModel "" "" False

type alias CompanyInputModel = {
  name: String
  , lat: String
  , lon: String
  , postcode: String
}

initCompanyInputModel = CompanyInputModel "" "0" "0" ""


type alias TechAddInputModel = {
  name : String
}

initTechAddInput = TechAddInputModel ""

-- main display

type alias Company = {
  id: String
  , name: String
  , lat: String
  , lon: String
  , postcode: String
  , technologies: Maybe (List Technology)
}

type alias Technology = {
  id: String
  , name: String
}

-- json stuff

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
