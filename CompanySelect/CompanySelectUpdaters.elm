module CompanySelect.CompanySelectUpdaters exposing (..)

import CompanySelect.CompanySelectModel exposing (..)
import Messages exposing (..)
import Utils exposing (..)

companySelectUpdaters msg model
  = companySelectAfterAdd msg model.companySelect
  |> selectRemoveAfterDel msg
  |> showNextCompany msg model.companies

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

showNextCompany msg companies selectModel =
  let
    currentId = selectModel.id
    next      = findNextCompanyToShow currentId companies
  in
    case msg of
      CompanyList (CompanySelect id) -> { selectModel | id = id }
      CompanyList (CompanyNext)      -> { selectModel | id = next }
      _                              -> selectModel

findNextCompanyToShow currentId companies =
  let
    sids = List.sortWith (\c d -> if c.id > d.id then GT else LT ) companies
    ids  = List.filter (\c -> c.id > currentId ) sids
    head = List.head ids
  in
    case head of
      Just v  -> v.id
      Nothing -> case List.head sids of
        Just v  -> v.id
        Nothing -> ""
