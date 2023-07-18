module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, h2, img, text)
import Html.Attributes exposing (alt, class, href, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Url



-- Main program
-- Die Hauptfunktion des Programms


main :
    Program
        ()
        { key : Nav.Key
        , url : Url.Url
        , recipe : Recipe
        , error : String
        }
        Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- Model
-- Der Zustand des Programms


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , recipe : Recipe
    , error : String
    }



-- Die Struktur eines Rezepts


type alias Recipe =
    { id : String, name : String, description : String }



-- Initialisierungsfunktion für das Modell


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key, url = url, recipe = {id = "", name = "", description = ""}, error = ""}
    , Cmd.none
    )



-- Messages
-- View
-- Die Darstellung der Benutzeroberfläche


view : Model -> Browser.Document Msg
view model =
    { title = "Deine RezeptApp"
    , body =
        [ div [ class "container" ]
            [ a [ href "/index.html" ]
                [ img [ class "img", src "./Bilder/Logo.jpg", alt "Logo" ] [] ]
            , div [] []
            , div [ class "header-links" ]
                [ a [ href "/index.html" ] [ text "Startseite" ]
                , a [ href "/lieblingsrezepte.html" ] [ text "Lieblingsrezepte" ]
                , a [ href "/einkauflisten.html" ] [ text "Einkaufslisten" ]
                ]
            , div [] []
            , h1 [ class "h1" ] [ text "Was kochst du heute?" ]
            , h1 [ class "h1" ] [ text "Klicke auf eine beliebige Kategorie und finde es heraus." ]
            , div [ class "svg-container" ]
                [ div []
                    [ img
                        [ class "svg"
                        , src "./SVGs/breakfast.svg"
                        , onClick GETnewRecipe
                        ]
                        []
                    , div [ class "svg Unterschrift" ] [ text "Frühstück" ]
                    ]
                , div []
                    [ img
                        [ class "svg"
                        , src "./SVGs/lunch.svg"
                        , onClick GETnewRecipe
                        ]
                        []
                    , div [ class "svg Unterschrift" ] [ text "Mittag-/Abendessen" ]
                    ]
                , div []
                    [ img
                        [ class "svg"
                        , src "./SVGs/dessert.svg"
                        , onClick GETnewRecipe
                        ]
                        []
                    , div [ class "svg Unterschrift" ] [ text "Dessert/Süßes" ]
                    , div [] []
                    ]
                ]
            ]
        ]
    }



-- Die verschiedenen Nachrichten, die das Programm empfangen kann


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GETnewRecipe
    | GOTnewRecipe (Result Http.Error HTTPSearchResults)



-- Update
-- Die Aktualisierung des Modells basierend auf den empfangenen Nachrichten


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model
                | url = url
              }
            , Cmd.none
            )
        
        GETnewRecipe ->
            ( model
            , Http.request
                { method = "GET"
                , headers = []
                , url = "https://www.themealdb.com/api/json/v1/1/random.php"
                , body = Http.emptyBody
                , expect = Http.expectJson GOTnewRecipe recipeDecoder
                , timeout = Nothing
                , tracker = Nothing
                }
            )

        GOTnewRecipe httpResponse ->
            case httpResponse of
                Ok result ->
                    ( { model | recipe = defaultRecipe }, Cmd.none )

                Err _ ->
                    ( { model | error = "Fehlerhafte Antwort" }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Decoder
-- Decoder für die API-Antworten


type alias HTTPSearchResults =
    { meals : List Recipe }



-- Decoder für ein einzelnes Rezept


recipeDecoder : Json.Decoder HTTPSearchResults
recipeDecoder =
    Json.map HTTPSearchResults
        (Json.field "results" (Json.list mealsDecoder))


mealsDecoder : Json.Decoder Recipe
mealsDecoder =
    Json.map3 Recipe
        (Json.field "idMeal" Json.string)
        (Json.field "strMeal" Json.string)
        (Json.field "strInstructions" Json.string)



-- Default Recipe
-- Ein Standardrezept, das angezeigt wird, wenn kein Rezept gefunden wurde


defaultRecipe : Recipe
defaultRecipe =
    { id = ""
    , name = "No recipe found"
    , description = "Please try again"
    }