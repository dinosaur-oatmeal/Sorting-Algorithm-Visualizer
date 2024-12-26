-- elm make src/Main.elm --output=elm.js
-- live-server
module Main exposing (main)

-- HTML Elements
import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- Array and Timing
import Array exposing (Array)
import Time

-- Visualization for converting model into charts
import Visualization exposing (renderComparison)

-- Sorting Algorithms
import BubbleSort
import SelectionSort
import InsertionSort
import MergeSort

-- Access to structs needed for program
import Structs exposing (Model, SortingTrack)

-- Set up a SortingTrack when given an array
initialTrack : Array Int -> SortingTrack
initialTrack arr =
    { array = arr
    , outerIndex = 0
    , currentIndex = 1
    , minIndex = 0
    , sorted = False
    , didSwap = False
    , currentStep = 0
    }

-- Initial state of the application
initialModel : Model
initialModel =
    let
        -- Initial array for all algorithms to sort
        initialArray = Array.fromList [9, 5, 3, 1, 6, 7, 10, 2, 4, 8]
    in
    { bubbleSortTrack = initialTrack initialArray
    , selectionSortTrack = initialTrack initialArray
    , insertionSortTrack = initialTrack initialArray
    , mergeSortTrack = initialTrack initialArray

    -- Don't run sorting algorithms until "Start" button pressed
    , running = False
    }

-- Use Browser.element to allow subscriptions (timing)
main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> (initialModel, Cmd.none)
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MESSAGES

-- List of all possible messages that will change our model (application's) state
type Msg
    = Start
    | Reset
    | Tick Time.Posix


-- UPDATE

-- Handles all state changes:
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        -- Set model running state to True
        Start ->
            ( { model | running = True }, Cmd.none )

        -- Reset to initialModel and set set running state to False
        Reset ->
            ( initialModel, Cmd.none )

        -- See if the algorithm is running and step all algorithms once if so
        Tick _ ->
            if model.running then
                ( { model
                    | bubbleSortTrack = BubbleSort.bubbleSortStep model.bubbleSortTrack
                    , selectionSortTrack = SelectionSort.selectionSortStep model.selectionSortTrack
                    , insertionSortTrack = InsertionSort.insertionSortStep model.insertionSortTrack
                    , mergeSortTrack = MergeSort.mergeSortStep model.mergeSortTrack
                  }
                , Cmd.none
                )
            else
                (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    -- Automatically step every 0.5 seconds if the running flag is True
    if model.running then
        Time.every 500 Tick
    else
        Sub.none


-- VIEW

view : Model -> Html Msg
-- Render the charts and buttons onto the screen
view model =
    div []
        [ div
            -- Styling for charts
            [ style "display" "flex"
            , style "justify-content" "space-around"
            , style "align-items" "flex-start"
            , style "flex-wrap" "nowrap"
            , style "gap" "20px"
            , style "padding" "20px"
            ]
            [ renderComparison
                -- BubbleSort
                model.bubbleSortTrack.array
                "Bubble Sort"
                model.bubbleSortTrack.sorted
                -- shows both elements being compared to one another
                (model.bubbleSortTrack.outerIndex + 1)
                model.bubbleSortTrack.currentIndex
                Nothing

            , renderComparison
                -- SelectionSort
                model.selectionSortTrack.array
                "Selection Sort"
                model.selectionSortTrack.sorted
                model.selectionSortTrack.outerIndex
                model.selectionSortTrack.currentIndex
                (Just model.selectionSortTrack.minIndex)

            , renderComparison
                -- InsertionSort
                model.insertionSortTrack.array
                "Insertion Sort"
                model.insertionSortTrack.sorted
                model.insertionSortTrack.outerIndex
                model.insertionSortTrack.currentIndex
                Nothing

            , renderComparison
                -- MergeSort
                model.mergeSortTrack.array
                "Merge Sort"
                model.mergeSortTrack.sorted
                model.mergeSortTrack.outerIndex
                model.mergeSortTrack.currentIndex
                Nothing
            ]

        , div
            -- Styling for buttons
            [ style "text-align" "center"
            , style "margin-top" "20px"
            ]
            -- Buttons to start and reset sorting
            [ button [ onClick Start ] [ text "Start" ]
            , button [ onClick Reset ] [ text "Reset" ]
            ]
        ]
