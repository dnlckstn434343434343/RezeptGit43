module Recipe_Api exposing (getRandomRecipe, view)

import Http
import Json.Decode as Decode exposing (Decoder)
import Update exposing (Msg(..))
import Update exposing (Model)
import Html exposing (Html)



type alias Recipe =
    { name : String
    , ingredients : String
    , steps : String
    , time : String
    , difficulty : String
    , category : String
    }


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



view : Model -> Html Msg
view arg1 =
    Debug.todo "TODO"
