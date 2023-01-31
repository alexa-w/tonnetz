module Main exposing (..)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class, style)
import Array exposing (fromList, get, Array)

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
    = (Quality, Root, Coords)

init : Model
init = (Major, 0, (-1, -1))

-- UPDATE

type Msg
    = Triad Quality Root Coords
    | Reset

update : Msg -> Model -> Model
update msg _ =
    case msg of
        Triad quality root coords ->
            (quality, root, coords)
        Reset ->
            (Major, 0, (-1, -1))

-- VIEW

view : Model -> Html Msg
view (quality, root, coords) =
    div [class "container"] [
        cell (root, (1, 1))
    ]

cell : (Root, Coords) -> Html Msg

cell (root, coords)
    = div [class "chord", style "grid-area" (coordsToGridArea coords)] [
            div [class "major"] []
            , div [class "minor"] []
        ]

coordsToGridArea : Coords -> String

coordsToGridArea (x, y)
    = String.fromInt(x) ++ " / " ++ String.fromInt(y)

generateRow : Int -> List (Html Msg)

generateRow y
    = [

    ]

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

chordToClass : Model -> String

chordToClass (quality, root, _) =
    rootToClass root ++ "-" ++ qualityToClass quality

coordsToClass : Coords -> Coords -> String

coordsToClass selected node =
    if selected == node then
        "selected"
    else
        ""
