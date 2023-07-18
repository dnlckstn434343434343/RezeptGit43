module Lieblingsrezepte exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value, list, object, string, int, bool)
import Url exposing (Url)


-- Model

type alias Model =
    { recipes : List Recipe
    , newRecipe : NewRecipe
    }

type alias Recipe =
    { id : Int
    , name : String
    , ingredients : List String
    }

type alias NewRecipe =
    { name : String
    , ingredients : String
    }


-- Msg

type Msg
    = AddRecipe
    | UpdateNewRecipeName String
    | UpdateNewRecipeIngredients String


-- Msg Decoders

newRecipeDecoder : Decoder NewRecipe
newRecipeDecoder =
    Json.Decode.map2 NewRecipe
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ingredients" Json.Decode.string)

recipeDecoder : Decoder Recipe
recipeDecoder =
    Json.Decode.map3 Recipe
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ingredients" (Json.Decode.list Json.Decode.string))


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
                    }
            in
            ( { recipes = newRecipeItem :: recipes, newRecipe = NewRecipe "" "" }, Cmd.none )

        UpdateNewRecipeName newName ->
            ( { recipes = recipes, newRecipe = { newRecipe | name = newName } }, Cmd.none )

        UpdateNewRecipeIngredients newIngredients ->
            ( { recipes = recipes, newRecipe = { newRecipe | ingredients = newIngredients } }, Cmd.none )


-- View

view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Lieblingsrezepte" ]
        , viewNewRecipeForm model.newRecipe
        , button [ onClick AddRecipe ] [ text "Rezept hinzufügen" ]
        , viewRecipeList model.recipes
        ]

viewNewRecipeForm : NewRecipe -> Html Msg
viewNewRecipeForm newRecipe =
    div []
        [ h3 [] [ text "Neues Rezept hinzufügen" ]
        , label [] [ text "Name:" ]
        , input [ value newRecipe.name, onInput UpdateNewRecipeName ] []
        , label [] [ text "Zutaten (durch Kommas getrennt):" ]
        , input [ value newRecipe.ingredients, onInput UpdateNewRecipeIngredients ] []
        ]

viewRecipeList : List Recipe -> Html Msg
viewRecipeList recipes =
    div []
        [ h3 [] [ text "Rezepte" ]
        , ul [] (List.map viewRecipe recipes)
        ]

viewRecipe : Recipe -> Html Msg
viewRecipe recipe =
    li [] [ text (recipe.name ++ ": " ++ String.join ", " recipe.ingredients) ]


-- Encoding and Decoding

encodeRecipe : Recipe -> Value
encodeRecipe recipe =
    Json.Encode.object
        [ ( "id", Json.Encode.int recipe.id )
        , ( "name", Json.Encode.string recipe.name )
        , ( "ingredients", Json.Encode.list Json.Encode.string recipe.ingredients )
        ]

encodeNewRecipe : NewRecipe -> Value
encodeNewRecipe newRecipe =
    Json.Encode.object
        [ ( "name", Json.Encode.string newRecipe.name )
        , ( "ingredients", Json.Encode.string newRecipe.ingredients )
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
    ( { recipes = [], newRecipe = NewRecipe "" "" }, Cmd.none )
