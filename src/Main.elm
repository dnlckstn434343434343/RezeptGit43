module Main exposing (main)

import Base
import Browser
import Browser.Navigation
import Page.Lieblingsrezepte exposing (..)
import Page.Einkaufslisten exposing (..)
import Page.Startseite exposing (..)
import Url
import Url.Builder
import Url.Parser exposing ((</>))
import Html exposing (text, img, ul)
import Html.Attributes exposing (src, alt, class)




-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Page
    = Startseite
    | Lieblingsrezepte
    | Einkaufslisten
    | NotFound


type alias Model =
    { key : Browser.Navigation.Key
    , url : Url.Url
    , page : Page
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , url = url
      , page = toPage url
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Browser.Navigation.load href
                    )

        UrlChanged url ->
            ( { model | url = url, page = toPage url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- ROUTE


route : Url.Parser.Parser (Page -> a) a
route =
    Url.Parser.oneOf
        [ Url.Parser.map Startseite Url.Parser.top
        , Url.Parser.map Startseite (Url.Parser.s Base.base)
        , Url.Parser.map Lieblingsrezepte (Url.Parser.s Base.base </> Url.Parser.s "Lieblingsrezepte")
        , Url.Parser.map Einkaufslisten (Url.Parser.s Base.base </> Url.Parser.s "Einkaufslisten")
        ]


toPage : Url.Url -> Page
toPage url =
    case Url.Parser.parse route url of
        Just answer ->
            answer

        Nothing ->
            NotFound



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Deine RezeptApp"
    , body = 
    [ img [ class "img", src "./Bilder/Logo.jpg", alt "Logo" ] []
        , Html.ul [class "ul"]
            [ internalLinkView "/Startseite"
            , internalLinkView "/Lieblingsrezepte"
            , internalLinkView "/Einkaufslisten"
            ]
        , Html.hr [] []
        , case model.page of
            Startseite ->
                Page.Startseite.view

            Lieblingsrezepte ->
                Page.Lieblingsrezepte.view

            Einkaufslisten ->
                Page.Einkaufslisten.view

            NotFound ->
                notFoundView
        , text "test" 
        ]
    }


internalLinkView : String -> Html.Html msg
internalLinkView path =
    Html.li []
        [ Html.a
            [ Html.Attributes.href <|
                Url.Builder.absolute [ Base.base, String.dropLeft 1 path ] []
            ]
            [ Html.text path ]
        ]


externalLinkView : String -> Html.Html msg
externalLinkView href =
    Html.li []
        [ Html.a
            [ Html.Attributes.href href ]
            [ Html.text href ]
        ]


blogView : Int -> Html.Html msg
blogView number =
    case number of
        0 ->
            Page.Einkaufslisten.view

        _ ->
            notFoundView


notFoundView : Html.Html msg
notFoundView =
    Html.text "Not found"