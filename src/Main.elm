module Main exposing (main)

import Browser
import Html exposing (Html, div, text, h1, h2, a, img)
import Html.Attributes exposing (class, href, src, alt)
import Html.Events exposing (onClick)
import Lieblingsrezepte
import Einkaufsliste

-- Main program

main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }

-- Model


type alias Model =
    {}


init : Model
init =
    {}


-- Messages


type Msg
    = NoOp

-- View


view : Model -> Html Msg
view model =
    div [class "container"]
        [ a [ href "/index.html" ]
            [ img [ class "img", src "./Bilder/Logo.jpg", alt "Logo" ] [] ]
        , div [] []
        , div [class "header-links"]
            [ a [ href "/index.html" ] [ text "Startseite" ]
            , a [ href "/lieblingsrezepte.html" ] [ text "Lieblingsrezepte" ]
            , a [ href "/einkauflisten.html" ] [ text "Einkaufslisten" ]
            ]
        , div [] []
        , h1 [class "h1"] [ text "Was kochst du heute?" ]
        , h1 [class "h1"] [ text "Klicke auf eine beliebige Kategorie und finde es heraus." ]
        , div [class "svg-container"]
            [ div []
                [ img
                    [ class "svg"
                    , src "./SVGs/breakfast.svg"
                    ]
                    []
                , div [class "svg Unterschrift"] [ text "Frühstück" ]
                ]
            , div []
                [ img
                    [ class "svg"
                    , src "./SVGs/lunch.svg"
                    ]
                    []
                , div [class "svg Unterschrift"] [ text "Mittag-/Abendessen" ]
                ]
            , div []
                [ img
                    [ class "svg"
                    , src "./SVGs/dessert.svg"
                    ]
                    []
                , div [class "svg Unterschrift"] [ text "Dessert/Süßes" ]
                ]
            ]
        ]

-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model