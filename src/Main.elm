-- start with elm init
-- elm make src/Main.elm --output elm.js
-- live-server

-- .. means everything is exposed (necessary in main)
module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Array exposing (Array)

-- Timing
import Time
import Task

-- Sorting Algorithms
import BubbleSort exposing (bubbleSortStep)
import SelectionSort exposing (selectionSortStep)

-- Visuals
import Visualization exposing (renderComparison)

-- MAIN

main : Program () Model Msg
main =
    -- .element lets me use subscriptions and timing for the model updates
    Browser.element
        -- Ignore flags and return init with no initial commands
        { init = \_ -> (init, Cmd.none)
        , update = update
        -- External events from model (time)
        , subscriptions = subscriptions
        , view = view
        }


-- TRACK MODEL

-- State of each sorting algorithm
type alias SortingTrack =
    -- Array that's being sorted
    { array : Array Int
    -- Index being looked at
    , index : Int
    -- Is the array sorted
    , sorted : Bool
    -- Were elements swapped during the last pass
    , didSwap : Bool
    }

-- MODEL (list of sorting algorithms and if the program is running)

type alias Model =
    -- List of sorting algorithms all with their own record
    { bubbleSortTrack : SortingTrack
    , selectionSortTrack : SortingTrack
    -- Is the program actively sorting
    , running : Bool
    }


-- INIT

init : Model
init =
    let
        -- First iteration of model and isn't sorted
        initialArray = Array.fromList [9, 5, 3, 1, 6, 7, 10, 2, 4, 8]
        initialTrack =
            { array = initialArray
            , index = 0
            , sorted = False
            , didSwap = False
            }
    -- Pack that content into each sorting algorithm and set running to false
    in
    { bubbleSortTrack = initialTrack
    , selectionSortTrack = initialTrack
    , running = False
    }

-- UPDATE

-- All messages/events that can change the application state
type Msg
    = StepBubbleSort
    | StepSelectionSort
    | Start
    | Tick Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- Do a step of BubbleSort (don't issue any commands)
        StepBubbleSort ->
            ( { model | bubbleSortTrack = updateSortingTrack model.bubbleSortTrack bubbleSortStep }
            , Cmd.none
            )

        -- Do a step of SeclectionSort (don't issue any commands)
        StepSelectionSort ->
            ( { model | selectionSortTrack = updateSortingTrack model.selectionSortTrack selectionSortStep }
            , Cmd.none
            )

        -- Set running flag to true
        Start ->
            ( { model | running = True }
            , Cmd.none
            )

        -- Advance all sorting algorithms if running is true
        Tick _ ->
            if model.running then
                ( { model
                    -- Calls BubbleSort.elm
                    | bubbleSortTrack = updateSortingTrack model.bubbleSortTrack bubbleSortStep
                    -- Calls SelectionSort.elm
                    , selectionSortTrack = updateSortingTrack model.selectionSortTrack selectionSortStep
                  }
                , Cmd.none
                )
            
            -- Don't change model if running isn't true
            else
                (model, Cmd.none)

updateSortingTrack : SortingTrack -> (Array Int -> Int -> (Array Int, Bool)) -> SortingTrack
-- sortStep is the function that does a single step of sorting
updateSortingTrack track sortStep =
    -- Don't update track if already sorted
    if track.sorted then
        track
    else
        let
            -- Get new array and track swaps
            -- (Array Int, Bool)
            (newArray, swapOccurred) =
                -- Run step function for specific sort (Array Int, Int)
                sortStep track.array track.index

            nextIndex =
                -- Next pass of array
                if track.index >= Array.length track.array - 2 then
                    0
                -- Increment index by 1
                else
                    track.index + 1

            -- True if at the end of the array and no swaps occured during pass
            isSorted =
                if track.index >= Array.length track.array - 2 then
                    not (track.didSwap || swapOccurred)
                else
                    False

            -- Reset swap value at the end of each pass
            resetDidSwap =
                if track.index >= Array.length track.array - 2 then
                    False
                else
                    track.didSwap || swapOccurred

        -- Pack into track for next step
        in
        { track
            | array = newArray
            , index = nextIndex
            , sorted = isSorted
            , didSwap = resetDidSwap
        }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    -- Send an update every 0.5 seconds
    if model.running then
        Time.every 500 Tick
    -- Model isn't running
    else
        Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    div []
        -- Render comparisons for all sorting algorithms (calls Visualization.elm)
        [ renderComparison
            model.bubbleSortTrack.array
            "Bubble Sort"
            model.bubbleSortTrack.sorted
            model.bubbleSortTrack.index
            model.selectionSortTrack.array
            "Selection Sort"
            model.selectionSortTrack.sorted
            model.selectionSortTrack.index
        , button [ onClick Start ] [ text "Start" ]
        ]

-- Convert Bool to String
stringFromBool : Bool -> String
stringFromBool value =
    if value then
        "True"
    else
        "False"
