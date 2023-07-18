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

type alias Model =
    { recipes : List Recipe
    , newRecipe : NewRecipe
    }

type alias Recipe =
    { id : Int
    , name : String
    , ingredients : List String
    , category : String
    , preparationTime : Int
    , difficulty : String
    }

type alias NewRecipe =
    { name : String
    , ingredients : String
    , category : String
    , preparationTime : Int
    , difficulty : String
    }


-- Msg

type Msg
    = AddRecipe
    | UpdateNewRecipeName String
    | UpdateNewRecipeIngredients String
    | UpdateNewRecipeCategory String
    | UpdateNewRecipePreparationTime String
    | UpdateNewRecipeDifficulty String


-- Msg Decoders

newRecipeDecoder : Decoder NewRecipe
newRecipeDecoder =
    Json.Decode.map5 NewRecipe
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ingredients" Json.Decode.string)
        (Json.Decode.field "category" Json.Decode.string)
        (Json.Decode.field "preparationTime" Json.Decode.int)
        (Json.Decode.field "difficulty" Json.Decode.string)

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

update : Msg -> Model -> (Model, Cmd Msg)
update msg { recipes, newRecipe } =
    case msg of
        AddRecipe ->
            let
                newId =
                    List.length recipes + 1

                newRecipeItem =
                    { id = newId
                    , name = newRecipe.name
                    , ingredients = String.split "," newRecipe.ingredients
                    , category = newRecipe.category
                    , preparationTime = newRecipe.preparationTime
                    , difficulty = newRecipe.difficulty
                    }
            in
            ( { recipes = newRecipeItem :: recipes, newRecipe = NewRecipe "" "" "" 0 "" }, Cmd.none )

        UpdateNewRecipeName newName ->
            ( { recipes = recipes, newRecipe = { newRecipe | name = newName } }, Cmd.none )

        UpdateNewRecipeIngredients newIngredients ->
            ( { recipes = recipes, newRecipe = { newRecipe | ingredients = newIngredients } }, Cmd.none )

        UpdateNewRecipeCategory newCategory ->
            ( { recipes = recipes, newRecipe = { newRecipe | category = newCategory } }, Cmd.none )

        UpdateNewRecipePreparationTime newPreparationTime ->
            let
                parsedTime =
                    String.toInt newPreparationTime
            in
            ( { recipes = recipes, newRecipe = { newRecipe | preparationTime = Maybe.withDefault 0 parsedTime } }, Cmd.none )

        UpdateNewRecipeDifficulty newDifficulty ->
            ( { recipes = recipes, newRecipe = { newRecipe | difficulty = newDifficulty } }, Cmd.none )


-- View

view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h2 [] [ text "Lieblingsrezepte" ]
        , viewNewRecipeForm model.newRecipe
        , button [ onClick AddRecipe ] [ text "Rezept hinzufügen" ]
        , br [] []
        , viewRecipeList model.recipes
        ]

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

viewRecipeList : List Recipe -> Html Msg
viewRecipeList recipes =
    div []
        [ h3 [] [ text "Hier sind deine gespeicherten Rezepte:" ]
        , ul [] (List.map viewRecipe recipes)
        ]

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

encodeNewRecipe : NewRecipe -> Value
encodeNewRecipe newRecipe =
    Json.Encode.object
        [ ( "name", Json.Encode.string newRecipe.name )
        , ( "ingredients", Json.Encode.string newRecipe.ingredients )
        , ( "category", Json.Encode.string newRecipe.category )
        , ( "preparationTime", Json.Encode.int newRecipe.preparationTime )
        , ( "difficulty", Json.Encode.string newRecipe.difficulty )
        ]

decodeRecipe : Decoder Recipe
decodeRecipe =
    recipeDecoder

decodeNewRecipe : Decoder NewRecipe
decodeNewRecipe =
    newRecipeDecoder


-- Main

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

init : () -> ( Model, Cmd Msg )
init _ =
    ( { recipes = [], newRecipe = NewRecipe "" "" "" 0 "" }, Cmd.none )
