module Recipe_Api exposing (getRandomRecipe, view)

import Http
import Json.Decode as Decode exposing (Decoder)
import Update exposing (Msg(..))
import Update exposing (Model)
import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder)
import Html.Events exposing (onClick)



type alias Recipe =
    { name : String
    , ingredients : String
    , steps : String
    , time : String
    , difficulty : String
    , category : String
    }

view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Name", onInput UpdateNameInput ] []
        , input [ placeholder "Ingredients", onInput UpdateIngredientsInput ] []
        , input [ placeholder "Steps", onInput UpdateStepsInput ] []
        , input [ placeholder "Time", onInput UpdateTimeInput ] []
        , input [ placeholder "Difficulty", onInput UpdateDifficultyInput ] []
        , input [ placeholder "Category", onInput UpdateCategoryInput ] []
        , button [ onClick AddRecipe ] [ text "Add Recipe" ]
        ]

getRandomRecipe : String -> Cmd Msg
getRandomRecipe category =
    let
        url =
            "https://www.themealdb.com/api.php" ++ category

        request =
            Http.get
                { url = url
                , expect = Http.expectJson GotRandomRecipe recipeDecoder
                }
    in
    request


recipeDecoder : Decoder Recipe
recipeDecoder =
    Decode.map6 Recipe
        (Decode.field "name" Decode.string)
        (Decode.field "ingredients" Decode.string)
        (Decode.field "steps" Decode.string)
        (Decode.field "time" Decode.string)
        (Decode.field "difficulty" Decode.string)
        (Decode.field "category" Decode.string)




