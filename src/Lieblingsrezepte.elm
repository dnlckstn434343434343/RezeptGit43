module Lieblingsrezepte exposing (..)

import Browser
import Html exposing (Html, div, text, h2, h3, ul, li, label, input, button, select, option)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value, list, object, string, int, bool)
import Url exposing (Url)
import Html exposing (strong)
import Html.Attributes exposing (selected)
import Html.Attributes exposing (type_)
import Maybe exposing (withDefault)
import Html exposing (br)
import Html exposing (p)


-- Model

-- Der Modelltyp `Model` enthält eine Liste von Rezepten (`recipes`) und ein neues Rezept (`newRecipe`).
type alias Model =
    { recipes : List Recipe
    , newRecipe : NewRecipe
    }

-- Der Modelltyp `Recipe` repräsentiert ein einzelnes Rezept mit verschiedenen Eigenschaften wie ID, Name, Zutaten usw.
type alias Recipe =
    { id : Int
    , name : String
    , ingredients : List String
    , category : String
    , preparationTime : Int
    , difficulty : String
    }

-- Der Modelltyp `NewRecipe` repräsentiert ein neues Rezept, das hinzugefügt werden kann. Es enthält ähnliche Eigenschaften wie `Recipe`.
type alias NewRecipe =
    { name : String
    , ingredients : String
    , category : String
    , preparationTime : Int
    , difficulty : String
    }


-- Msg

-- Die verschiedenen Nachrichten (`Msg`), die das Programm empfangen kann.
type Msg
    = AddRecipe
    | UpdateNewRecipeName String
    | UpdateNewRecipeIngredients String
    | UpdateNewRecipeCategory String
    | UpdateNewRecipePreparationTime String
    | UpdateNewRecipeDifficulty String


-- Msg Decoders

-- Der Decoder `newRecipeDecoder` wird verwendet, um JSON-Daten in den `NewRecipe`-Typ zu decodieren.
newRecipeDecoder : Decoder NewRecipe
newRecipeDecoder =
    Json.Decode.map5 NewRecipe
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ingredients" Json.Decode.string)
        (Json.Decode.field "category" Json.Decode.string)
        (Json.Decode.field "preparationTime" Json.Decode.int)
        (Json.Decode.field "difficulty" Json.Decode.string)

-- Der Decoder `recipeDecoder` wird verwendet, um JSON-Daten in den `Recipe`-Typ zu decodieren.
recipeDecoder : Decoder Recipe
recipeDecoder =
    Json.Decode.map6 Recipe
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ingredients" (Json.Decode.list Json.Decode.string))
        (Json.Decode.field "category" Json.Decode.string)
        (Json.Decode.field "preparationTime" Json.Decode.int)
        (Json.Decode.field "difficulty" Json.Decode.string)


-- Update

-- Die Update-Funktion verarbeitet die verschiedenen Nachrichten (`Msg`) und aktualisiert den Modellzustand entsprechend.
update : Msg -> Model -> (Model, Cmd Msg)
update msg { recipes, newRecipe } =
    case msg of
        -- Wenn `AddRecipe` empfangen wird, wird ein neues Rezept zum Modell hinzugefügt.
        AddRecipe ->
            let
                -- Generiere eine neue ID für das Rezept, indem die Länge der vorhandenen Rezepte ermittelt wird.
                newId =
                    List.length recipes + 1

                -- Erstelle ein neues `Recipe`-Objekt mit den Daten aus dem `newRecipe`-Feld des Modells.
                newRecipeItem =
                    { id = newId
                    , name = newRecipe.name
                    , ingredients = String.split "," newRecipe.ingredients
                    , category = newRecipe.category
                    , preparationTime = newRecipe.preparationTime
                    , difficulty = newRecipe.difficulty
                    }
            in
            -- Füge das neue Rezept zum Anfang der Rezeptliste hinzu und setze das `newRecipe`-Feld zurück.
            ( { recipes = newRecipeItem :: recipes, newRecipe = NewRecipe "" "" "" 0 "" }, Cmd.none )

        -- Aktualisiere den Namen des neuen Rezepts im Modell.
        UpdateNewRecipeName newName ->
            ( { recipes = recipes, newRecipe = { newRecipe | name = newName } }, Cmd.none )

        -- Aktualisiere die Zutaten des neuen Rezepts im Modell.
        UpdateNewRecipeIngredients newIngredients ->
            ( { recipes = recipes, newRecipe = { newRecipe | ingredients = newIngredients } }, Cmd.none )

        -- Aktualisiere die Kategorie des neuen Rezepts im Modell.
        UpdateNewRecipeCategory newCategory ->
            ( { recipes = recipes, newRecipe = { newRecipe | category = newCategory } }, Cmd.none )

        -- Aktualisiere die Zubereitungszeit des neuen Rezepts im Modell.
        UpdateNewRecipePreparationTime newPreparationTime ->
            let
                -- Versuche, die eingegebene Zeit in einen Integer-Wert umzuwandeln.
                parsedTime =
                    String.toInt newPreparationTime
            in
            -- Setze die Zubereitungszeit des neuen Rezepts im Modell auf den geparsten Wert oder 0 (falls die Konvertierung fehlschlägt).
            ( { recipes = recipes, newRecipe = { newRecipe | preparationTime = Maybe.withDefault 0 parsedTime } }, Cmd.none )

        -- Aktualisiere die Schwierigkeit des neuen Rezepts im Modell.
        UpdateNewRecipeDifficulty newDifficulty ->
            ( { recipes = recipes, newRecipe = { newRecipe | difficulty = newDifficulty } }, Cmd.none )


-- View

-- Die view-Funktion erzeugt die HTML-Darstellung des Modells.
view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h2 [] [ text "Lieblingsrezepte" ]
        , viewNewRecipeForm model.newRecipe
        , button [ onClick AddRecipe ] [ text "Rezept hinzufügen" ]
        , br [] []
        , viewRecipeList model.recipes
        ]

-- Die viewNewRecipeForm-Funktion erzeugt das HTML-Formular zum Hinzufügen eines neuen Rezepts.
viewNewRecipeForm : NewRecipe -> Html Msg
viewNewRecipeForm newRecipe =
    div []
        [ h3 [] [ text "Füge hier ein neues Rezept hinzu:" ]
        , label [] [ text "Rezeptname:" ]
        , input [ value newRecipe.name, onInput UpdateNewRecipeName ] []
        , label [] [ text "Zutaten (durch Kommas getrennt):" ]
        , input [ value newRecipe.ingredients, onInput UpdateNewRecipeIngredients ] []
        , label [] [ text "Kategorie: " ]
        , select [ onInput UpdateNewRecipeCategory ]
            [ option [ value "", selected (newRecipe.category == "") ] [ text "Auswählen" ]
            , option [ value "Frühstück", selected (newRecipe.category == "Frühstück") ] [ text "Frühstück" ]
            , option [ value "Mittag-/Abendessen", selected (newRecipe.category == "Mittag-/Abendessen") ] [ text "Mittag-/Abendessen" ]
            , option [ value "Dessert/Süßes", selected (newRecipe.category == "Dessert/Süßes") ] [ text "Dessert/Süßes" ]
            ]
        , div [] []
        , div [] []
        , label [] [ text "Zubereitungszeit (in Minuten):" ]
        , input [ type_ "number", value (String.fromInt newRecipe.preparationTime), onInput UpdateNewRecipePreparationTime ] []
        , label [] [ text "Schwierigkeit: " ]
        , select [ onInput UpdateNewRecipeDifficulty ]
            [ option [ value "", selected (newRecipe.difficulty == "") ] [ text "Auswählen" ]
            , option [ value "leicht", selected (newRecipe.difficulty == "leicht") ] [ text "Leicht" ]
            , option [ value "mittel", selected (newRecipe.difficulty == "mittel") ] [ text "Mittel" ]
            , option [ value "schwer", selected (newRecipe.difficulty == "schwer") ] [ text "Schwer" ]
            ]
        ]

-- Die viewRecipeList-Funktion erzeugt die HTML-Liste der gespeicherten Rezepte.
viewRecipeList : List Recipe -> Html Msg
viewRecipeList recipes =
    div []
        [ h3 [] [ text "Hier sind deine gespeicherten Rezepte:" ]
        , ul [] (List.map viewRecipe recipes)
        ]

-- Die viewRecipe-Funktion erzeugt die HTML-Darstellung eines einzelnen Rezepts.
viewRecipe : Recipe -> Html Msg
viewRecipe recipe =
    li []
        [ div []
            [ strong [] [ text "Name: " ]
            , text recipe.name
            ]
        , div []
            [ strong [] [ text "Zutaten: " ]
            , text (String.join ", " recipe.ingredients)
            ]
        , div []
            [ strong [] [ text "Kategorie: " ]
            , text recipe.category
            ]
        , div []
            [ strong [] [ text "Zubereitungszeit: " ]
            , text (String.fromInt recipe.preparationTime ++ " min")
            ]
        , div []
            [ strong [] [ text "Schwierigkeit: " ]
            , text recipe.difficulty
            ]
        ]


-- Encoding and Decoding

-- Die Funktion `encodeRecipe` wandelt ein `Recipe`-Objekt in eine JSON-Darstellung um.
encodeRecipe : Recipe -> Value
encodeRecipe recipe =
    Json.Encode.object
        [ ( "id", Json.Encode.int recipe.id )
        , ( "name", Json.Encode.string recipe.name )
        , ( "ingredients", Json.Encode.list Json.Encode.string recipe.ingredients )
        , ( "category", Json.Encode.string recipe.category )
        , ( "preparationTime", Json.Encode.int recipe.preparationTime )
        , ( "difficulty", Json.Encode.string recipe.difficulty )
        ]

-- Die Funktion `encodeNewRecipe` wandelt ein `NewRecipe`-Objekt in eine JSON-Darstellung um.
encodeNewRecipe : NewRecipe -> Value
encodeNewRecipe newRecipe =
    Json.Encode.object
        [ ( "name", Json.Encode.string newRecipe.name )
        , ( "ingredients", Json.Encode.string newRecipe.ingredients )
        , ( "category", Json.Encode.string newRecipe.category )
        , ( "preparationTime", Json.Encode.int newRecipe.preparationTime )
        , ( "difficulty", Json.Encode.string newRecipe.difficulty )
        ]

-- Der Decoder `decodeRecipe` wird verwendet, um JSON-Daten in den `Recipe`-Typ zu decodieren.
decodeRecipe : Decoder Recipe
decodeRecipe =
    recipeDecoder

-- Der Decoder `decodeNewRecipe` wird verwendet, um JSON-Daten in den `NewRecipe`-Typ zu decodieren.
decodeNewRecipe : Decoder NewRecipe
decodeNewRecipe =
    newRecipeDecoder


-- Main

-- Die `main`-Funktion ist der Einstiegspunkt des Programms.
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

-- Die `init`-Funktion initialisiert den Anfangszustand des Modells.
init : () -> ( Model, Cmd Msg )
init _ =
    ( { recipes = [], newRecipe = NewRecipe "" "" "" 0 "" }, Cmd.none )
