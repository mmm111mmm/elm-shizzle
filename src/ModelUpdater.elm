module ModelUpdater exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Utils exposing (..)

updater msg model =
  let
    companies = case msg of
      -- add the companies on a response
      CompanyListResponse (Error e)          -> model.companies
      CompanyListResponse (ValueResponse cs) -> cs
      _                                      -> model.companies
    companyInput m = case msg of
      -- close on add company reponse
      -- close on login close
      CompanyAdd (Name s)                    -> { m | name = s }
      CompanyAdd (Lat s)                     -> { m | lat = s }
      CompanyAdd (Lon s)                     -> { m | lon = s }
      CompanyAdd (Postcode s)                -> { m | postcode = s }
      CompanyAdd (CompanyAddShow b)          -> { m | companyAddShow = b }
      Login (LoginShow False)                -> { m | companyAddShow = False }
      CompanyAddResponse (ValueResponse _)   -> { m | companyAddShow = False }
      _                                      -> m
    techAddInput m = case msg of
      -- closes tech add box on escape key
      TechAdd (TechName s)            -> { m | name = s }
      TechAdd (TechAddToggle num)     -> { m | techAddBox = num }
      TechAdd (TechEnter 27 _)        -> { m | techAddBox = "" }
      TechAddResponse (RawResponse r) -> httpResponse1 r (\_ -> { m| name = "", techAddBox = "" }) (\_ -> m )
      _                               -> m
    loginInput m = case msg of
      -- close after succesful login
      -- open if we try to add a company without a session
      Login (Username s)               -> { m | username = s }
      Login (Password s)               -> { m | password = s }
      Login (LoginPressInvalid)        -> { m | loginPressInvalid = True }
      Login (LoginShow b)              -> { m | loginShow = b }
      LoginResponse (ValueResponse _)  -> { m | loginShow = False }
      CompanyAdd (CompanyAddShow True) -> { m | loginShow = (model.session == "") }
      _                                -> m
    companySelect m = case msg of
      -- remove the selection after a del
      CompanyAddResponse (ValueResponse r) -> { m | id = toString r }
      CompanyDelResponse (RawResponse r)   -> { m | id = "" }
      CompanyList (CompanySelect id)       -> { m | id = id }
      CompanyList (CompanyNext)            -> { m | id = findNextCompanyToShow m.id model.companies }
      _                                    ->  m
    session = case msg of
      LoginResponse (ValueResponse s) -> s
      _                               -> model.session
    in
      { model |
        session         = session
        , loginInput    = loginInput model.loginInput
        , companyInput  = companyInput model.companyInput
        , companySelect = companySelect model.companySelect
        , companies     = companies
        , techAddInput  = techAddInput model.techAddInput
      }
