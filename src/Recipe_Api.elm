module Recipe_Api exposing (getRandomRecipe, Recipe_Api_Msg(..))

import Http
import Json.Decode as Decode exposing (Decoder)



type alias Recipe =
    { name : String
    , ingredients : String
    , steps : String
    , time : String
    , difficulty : String
    , category : String
    }

type Recipe_Api_Msg
    = GotRandomRecipe (Result Http.Error Recipe)

getRandomRecipe : String -> Cmd Recipe_Api_Msg
getRandomRecipe category =
    let
        url =
            "www.themealdb.com/api/json/v1/1/categories.php" ++ category

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
