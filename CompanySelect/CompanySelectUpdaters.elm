module CompanySelect.CompanySelectUpdaters exposing (..)

import CompanySelect.CompanySelectModel exposing (..)
import Messages exposing (..)
import Utils exposing (..)

companySelectUpdaters msg model
  = companySelectAfterAdd msg model.companySelect
  |> selectRemoveAfterDel msg

companySelectAfterAdd: Msg -> CompanySelectModel -> CompanySelectModel
companySelectAfterAdd msg selectModel =
  case msg of
    CompanyAddResponse (ValueResponse r) -> { selectModel | id = toString r }
    _                                    -> selectModel

selectRemoveAfterDel: Msg -> CompanySelectModel -> CompanySelectModel
selectRemoveAfterDel msg selectModel =
  case msg of
    CompanyDelResponse (RawResponse r)   -> { selectModel | id = "" }
    _                                    -> selectModel
