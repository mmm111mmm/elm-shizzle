module Model exposing (..)

import Json.Decode as Json exposing (..)
import Html exposing (..)

type alias Model = {
  session:      String
  , loginInput:   LoginInputModel
  , companyInput: CompanyInputModel
  , companyDel : CompanyDelModel
  , techAddInput: TechAddInputModel
  , companySelect: CompanySelectModel
  , companies:    List Company
}

initModel = Model "" initLoginInputModel initCompanyInputModel initCompanyDelModel initTechAddInput initCompanySelectModel []

type alias CompanyInputModel = {
  name: String
  , lat: String
  , lon: String
  , postcode: String
  , companyAddShow: Bool
}

initCompanyInputModel = CompanyInputModel "" "0" "0" "" False

type alias CompanyDelModel = {
  showBox: Bool
}

initCompanyDelModel = CompanyDelModel False

type alias CompanySelectModel = {
  id : String
}

initCompanySelectModel = CompanySelectModel ""

type alias LoginInputModel = {
  username : String
  , password : String
  , loginShow : Bool
  , loading : Bool
  , errorResponse : String
}

initLoginInputModel = LoginInputModel "" "" False False ""

type alias TechAddInputModel = {
  techAddBox: String
  , name : String
}

initTechAddInput = TechAddInputModel "" ""

--

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
