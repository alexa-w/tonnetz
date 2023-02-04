module Main exposing (..)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Array exposing (fromList, get, Array)
import List exposing (..)
import Html.Events exposing (onClick)

-- MAIN

main : Program () Model Msg
main = 
    Browser.sandbox 
        { init = init
        , view = view
        , update = update
        }

-- MODEL

{-
    PRL transformations described here: https://open.library.okstate.edu/musictheory/chapter/neo-riemannian-triadic-progressions/ 

    The (P)arallel transformation flips the triangle along the edge belonging to the line of perfect fifths (left to right)
    The (R)elative transformation flips the triangle along the edge belonging to the line of major thirds (top left to bottom right)
    The (L)eading-tone transformation flips the triangle along the edge belonging to the line of minor thirds (top right to bottom left)

-}
type Transformation
    = Parallel
    | Relative
    | Leading

-- Position on the grid as X Y pair
type alias Coords
    = (Int, Int)

type Quality
    = Major
    | Minor

type alias Root = Int

type alias Model
    = {
        quality : Quality
        , root : Root
        , coords : Coords
    }

init : Model
init =
    { quality = Major
    , root = 0
    , coords = (-1, -1)
    }

-- UPDATE

type Msg
    = Triad Quality Root Coords
    | Reset

update : Msg -> Model -> Model
update msg _ =
    case msg of
        Triad quality root coords ->
            { quality = quality
            , root = root
            , coords = coords}
        Reset ->
            init

-- VIEW

view : Model -> Html Msg
view model =
    div [class "container"] (grid 0 0 model)

cell : Root -> Coords -> Model -> Html Msg

cell root coords model
    = div [class "chord", style "grid-area" (coordsToGridArea coords)] [
            div [class "major", class (chordToClass Major root), class (coordsToClass model coords Major), onClick (Triad Major root coords)] []
            , div [class "minor", class (chordToClass Minor root), class (coordsToClass model coords Minor), onClick (Triad Minor root coords)] []
        ]

coordsToGridArea : Coords -> String

coordsToGridArea (x, y)
    = String.fromInt(y + 1) ++ " / " ++ String.fromInt(x + 1)

row : Root -> Int -> Int -> Model -> List (Html Msg)

row root x y model =
    if x > 7 then
        []
    else
        cell root (x, y) model :: row (modBy 12 (root + 4)) (x + 1) y model
    

grid : Root -> Int -> Model -> List (Html Msg)

grid root y model =
    if y > 9 then
        []
    else
        row root 0 y model ++ grid (modBy 12 (root + 3)) (y + 1) model


-- HELPERS

-- deutsch because it seems appropriate to the concept
notes : Array String
notes = fromList
    [ "a"
    , "ais"
    , "b"
    , "c"
    , "cis"
    , "d"
    , "dis"
    , "e"
    , "f"
    , "fis"
    , "g"
    , "gis"
    ]

rootToClass : Root -> String

rootToClass root = Maybe.withDefault "nothing" (get root notes)

qualityToClass : Quality -> String

-- we going deutsch again
qualityToClass quality =
    case quality of
        Major ->
            "dur"
        Minor ->
            "moll"

chordToClass : Quality -> Root -> String

chordToClass quality root =
    rootToClass root ++ "-" ++ qualityToClass quality

coordsToClass : Model -> Coords -> Quality -> String

coordsToClass selected node quality =
    if selected.coords == node && selected.quality == quality then
        "selected"
    else
        ""
