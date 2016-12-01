module CompaniesList.CompaniesListModel exposing (..)

import Model.Company exposing (..)

type alias Company = {
  id: String
  , name: String
  , lat: String
  , lon: String
  , postcode: String
  , technologies: Maybe (List Technology)
}
