module ModelUpdaters exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Utils exposing (..)

companies msg model = case msg of
    CompanyListResponse (Error e)          -> model.companies
    CompanyListResponse (ValueResponse cs) -> cs
    _                                      -> model.companies

companyInput msg model companyAddModel = case msg of
    -- close add company in some cases
    Login (LoginShow False)                -> { companyAddModel | companyAddShow = False }
    CompanyAddResponse (ValueResponse _)   -> { companyAddModel | companyAddShow = False }
    -- user input
    CompanyAdd (Name s)                    -> { companyAddModel | name = s }
    CompanyAdd (Lat s)                     -> { companyAddModel | lat = s }
    CompanyAdd (Lon s)                     -> { companyAddModel | lon = s }
    CompanyAdd (Postcode s)                -> { companyAddModel | postcode = s }
    CompanyAdd (CompanyAddShow b)          -> { companyAddModel | companyAddShow = b }
    _                                      -> companyAddModel

companySelect msg model selectModel = case msg of
    CompanyAddResponse (ValueResponse r) -> { selectModel | id = toString r }
    -- remove the selection after a del
    CompanyDelResponse (RawResponse r)   -> { selectModel | id = "" }
    -- show next company
    CompanyList (CompanySelect id)       -> { selectModel | id = id }
    CompanyList (CompanyNext)            -> { selectModel | id = findNextCompanyToShow selectModel.id model.companies }
    _                                    -> selectModel

loginInput msg model loginModel = case msg of
    Login (Username s)               -> { loginModel | username = s }
    Login (Password s)               -> { loginModel | password = s }
    Login (LoginPressInvalid)        -> { loginModel | loginPressInvalid = True }
    Login (LoginShow b)              -> { loginModel | loginShow = b }
    -- close login after success
    LoginResponse (ValueResponse _)  -> { loginModel | loginShow = False }
    -- open login if add company with no session
    CompanyAdd (CompanyAddShow True) -> { loginModel | loginShow = (model.session == "") }
    _                                -> loginModel

techAddInput msg model techAddModel = case msg of
    TechAdd (TechName s)            -> { techAddModel | name = s }
    TechAdd (TechAddToggle num)     -> { techAddModel | techAddBox = num }
    TechAdd (TechEnter 27 _)        -> { techAddModel | techAddBox = "" }
    TechAddResponse (RawResponse r) -> httpResponse1 r (\_ -> { techAddModel | name = "", techAddBox = "" }) (\_ -> techAddModel)
    _                               -> techAddModel

session msg model = case msg of
    LoginResponse (Error e)         -> model.session
    LoginResponse (ValueResponse s) -> s
    _                               -> model.session
