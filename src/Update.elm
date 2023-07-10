module Update exposing (Model, Msg(..), initialModel, update)

import Browser.Navigation as Nav
import Recipe exposing (Recipe)


type alias Model =
    { key : Nav.Key
    , recipes : List Recipe
    , nameInput : String
    , ingredientsInput : String
    , stepsInput : String
    , timeInput : String
    , difficultyInput : String
    , categoryInput : String
    }


initialModel : Nav.Key -> Model
initialModel key =
    { key = key
    , recipes = []
    , nameInput = ""
    , ingredientsInput = ""
    , stepsInput = ""
    , timeInput = ""
    , difficultyInput = ""
    , categoryInput = ""
    }


type Msg
    = AddRecipe
    | ChangeUrl String
    | NoOp
    | UpdateNameInput String
    | UpdateIngredientsInput String
    | UpdateStepsInput String
    | UpdateTimeInput String
    | UpdateDifficultyInput String
    | UpdateCategoryInput String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddRecipe ->
            let
                newRecipe =
                    { name = model.nameInput
                    , ingredients = model.ingredientsInput
                    , steps = model.stepsInput
                    , time = model.timeInput
                    , difficulty = model.difficultyInput
                    , category = model.categoryInput
                    }
            in
            ( { model | recipes = newRecipe :: model.recipes, nameInput = "", ingredientsInput = "", stepsInput = "", timeInput = "", difficultyInput = "", categoryInput = "" }
            , Nav.pushUrl model.key "/recipes"
            )

        ChangeUrl url ->
            ( model, Nav.pushUrl model.key url )

        NoOp ->
            ( model, Cmd.none )

        UpdateNameInput newName ->
            ( { model | nameInput = newName }, Cmd.none )

        UpdateIngredientsInput newIngredients ->
            ( { model | ingredientsInput = newIngredients }, Cmd.none )

        UpdateStepsInput newSteps ->
            ( { model | stepsInput = newSteps }, Cmd.none )

        UpdateTimeInput newTime ->
            ( { model | timeInput = newTime }, Cmd.none )

        UpdateDifficultyInput newDifficulty ->
            ( { model | difficultyInput = newDifficulty }, Cmd.none )

        UpdateCategoryInput newCategory ->
            ( { model | categoryInput = newCategory }, Cmd.none )

