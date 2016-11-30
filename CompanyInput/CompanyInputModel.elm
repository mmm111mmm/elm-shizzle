module CompanyInput.CompanyInputModel exposing (..)

type alias CompanyInputModel = {
  name: String
  , lat: String
  , lon: String
  , postcode: String
  , companyAddShow: Bool
}

initCompanyInputModel = CompanyInputModel "" "0" "0" "" False
