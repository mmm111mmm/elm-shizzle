module Model.Model exposing (..)

import Json.Decode as Json exposing (..)
import Html exposing (..)
import Model.Company exposing (..)
import LoginInput.LoginInputModel exposing (..)
import CompanyInput.CompanyInputModel exposing (..)
import CompanySelect.CompanySelectModel exposing (..)

type alias Model = {
  page:           String
  , session:      String
  , loginInput:   LoginInputModel
  , companyInput: CompanyInputModel
  , techAddInput: TechAddInputModel
  , companySelect: CompanySelectModel
  , companies:    List Company
}

initModel = Model "home" "" initLoginInputModel initCompanyInputModel initTechAddInput initCompanySelectModel []

-- input


type alias TechAddInputModel = {
  techAddBox: String
  , name : String
}

initTechAddInput = TechAddInputModel "" ""


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
