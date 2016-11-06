module Model exposing (..)

import Json.Decode as Json exposing (..)

-- login

type alias LoginInputModel = {
  username : String
  , password : String
  , loginPressInvalid: Bool
}

initLoginInputModel = LoginInputModel "" "" False

-- company add

type alias CompanyInputModel = {
  name: String
  , lat: String
  , lon: String
  , postcode: String
}

initCompanyInputModel = CompanyInputModel "" "" "" ""

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

-- overall

type alias Model = {
  session:        String
  , loginInput:   LoginInputModel
  , companyInput: CompanyInputModel
  , companies:    List Company
  , res:          String
}

initModel = Model "" initLoginInputModel initCompanyInputModel [] ""

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
