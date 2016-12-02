module Model exposing (..)

import Json.Decode as Json exposing (..)
import Html exposing (..)

type alias Model = {
  session:      String
  , loginInput:   LoginInputModel
  , companyInput: CompanyInputModel
  , techAddInput: TechAddInputModel
  , companySelect: CompanySelectModel
  , companies:    List Company
}

initModel = Model "" initLoginInputModel initCompanyInputModel initTechAddInput initCompanySelectModel []

type alias CompanyInputModel = {
  name: String
  , lat: String
  , lon: String
  , postcode: String
  , companyAddShow: Bool
}

initCompanyInputModel = CompanyInputModel "" "0" "0" "" False

type alias CompanySelectModel = {
  id : String
}

initCompanySelectModel = CompanySelectModel ""

type alias LoginInputModel = {
  username : String
  , password : String
  , loginPressInvalid: Bool
  , loginShow: Bool
}

initLoginInputModel = LoginInputModel "" "" False False

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
