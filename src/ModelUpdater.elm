module ModelUpdater exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Utils exposing (..)

updater msg model =
  { model |
    -- session value set after a successful login
    -- session value is never deleted as yet
    session = case msg of
      LoginResponse (ValueResponse s)        -> s
      _                                      -> model.session
    -- closes login after succesful login
    -- open login if we try to add a company without a session
    , loginInput = model.loginInput |> \m -> case msg of
      Login (Username s)                     -> { m | username = s }
      Login (Password s)                     -> { m | password = s }
      Login (LoginPressInvalid)              -> { m | loginPressInvalid = True }
      Login (LoginShow b)                    -> { m | loginShow = b }
      LoginResponse (ValueResponse _)        -> { m | loginShow = False }
      CompanyAdd (CompanyAddShow True)       -> { m | loginShow = blankSession model }
      CompanyDel (CompanyDelShow True)       -> { m | loginShow = blankSession model }
      TechAdd (TechAddToggle _)              -> { m | loginShow = blankSession model }
      _                                      -> m
      -- close company input box on add company reponse
      -- close company input box on login close
    , companyInput  = model.companyInput |> \m -> case msg of
      CompanyAdd (Name s)                    -> { m | name = s }
      CompanyAdd (Lat s)                     -> { m | lat = s }
      CompanyAdd (Lon s)                     -> { m | lon = s }
      CompanyAdd (Postcode s)                -> { m | postcode = s }
      CompanyAdd (CompanyAddShow b)          -> { m | companyAddShow = b }
      Login (LoginShow False)                -> { m | companyAddShow = False }
      CompanyAddResponse (ValueResponse _)   -> { m | companyAddShow = False }
      _                                      -> m
    , companyDel = model.companyDel |> \m -> case msg of
      CompanyDel (CompanyDelShow b)          -> { m | showBox = b }
      CompanyDelResponse (RawResponse r)     -> httpResponse1 r (\_ -> { m | showBox = False } ) (\_ -> m )
      Login (LoginShow False)                -> { m | showBox = False }
      _                                      -> m
    -- company selection set on a company add
    -- company selection removal after a company del
    -- company selection new/next company id on pressing next
    , companySelect = model.companySelect |> \m -> case msg of
      CompanyAddResponse (ValueResponse r)   -> { m | id = toString r }
      CompanyDelResponse (RawResponse r)     -> httpResponse1 r (\_ -> { m | id = "-1" }) (\_ -> m )
      CompanyListResponse (ValueResponse cs) -> if m.id =="" then { m | id = findFirstCompany cs } else m
      CompanyList (CompanySelect id)         -> { m | id = id }
      CompanyList (CompanyNext)              -> { m | id = findNextCompanyToShow m.id model.companies }
      _                                      ->  m
    -- shows companies on a response
    -- we should do something on error
    , companies = case msg of
      CompanyListResponse (Error e)          -> model.companies
      CompanyListResponse (ValueResponse cs) -> cs
      _                                      -> model.companies
    -- closes tech add input box on escape key
    -- closes tech add input box on good response
    , techAddInput = model.techAddInput |> \m -> case msg of
      TechAdd (TechName s)                   -> { m | name = s }
      TechAdd (TechAddToggle num)            -> { m | techAddBox = num }
      TechAdd (TechEnter 27 _)               -> { m | techAddBox = "" }
      TechAddResponse (RawResponse r)        -> httpResponse1 r (\_ -> { m | name = "", techAddBox = "" }) (\_ -> m )
      _                                      -> m
    }
