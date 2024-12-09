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

-- Access to structs needed for program
import Structs exposing (Model, SortingTrack)

-- Set up a SortingTrack when given an array
initialTrack : Array Int -> SortingTrack
initialTrack arr =
    { array = arr
    , outerIndex = 0
    , compareIndex = 1
    , minIndex = 0
    , sorted = False
    , didSwap = False
    }

-- Initial state of the application
initialModel : Model
initialModel =
    let
        -- Initial array for all algorithms to sort
        initialArray = Array.fromList [9, 5, 3, 1, 6, 7, 10, 2, 4, 8]
    in
    { bubbleSortTrack = initialTrack initialArray

    -- minIndex initialized to outerIndex for tracking to be correct
    , selectionSortTrack = 
        let
            track = initialTrack initialArray
        in
            { track | minIndex = track.outerIndex }
    , insertionSortTrack = initialTrack initialArray
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
    = StepBubbleSort
    | StepSelectionSort
    | StepInsertionSort
    | Start
    | Reset
    | Tick Time.Posix


-- UPDATE

-- Handles all state changes:
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of

        -- One step of BubbleSort (calls BubbleSort.elm)
        StepBubbleSort ->
            ( { model | bubbleSortTrack = BubbleSort.bubbleSortStep model.bubbleSortTrack }
            , Cmd.none
            )

        -- One step of SelectionSort (calls SelectionSort.elm)
        StepSelectionSort ->
            ( { model | selectionSortTrack = SelectionSort.selectionSortStep model.selectionSortTrack }
            , Cmd.none
            )

        -- One step of InsertionSort (calls InsertionSort.elm)
        StepInsertionSort ->
            ( { model | insertionSortTrack = InsertionSort.insertionSortStep model.insertionSortTrack }
            , Cmd.none
            )

        -- Set model running state to True
        Start ->
            ( { model | running = True }, Cmd.none )

        Reset ->
            ( initialModel, Cmd.none )

        -- See if the algorithm is running and step all algorithms once if so
        Tick _ ->
            if model.running then
                ( { model
                    | bubbleSortTrack = BubbleSort.bubbleSortStep model.bubbleSortTrack
                    , selectionSortTrack = SelectionSort.selectionSortStep model.selectionSortTrack
                    , insertionSortTrack = InsertionSort.insertionSortStep model.insertionSortTrack
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
                model.bubbleSortTrack.outerIndex
                (Just model.bubbleSortTrack.compareIndex)
                Nothing

            , renderComparison
                -- SelectionSort
                model.selectionSortTrack.array
                "Selection Sort"
                model.selectionSortTrack.sorted
                model.selectionSortTrack.outerIndex
                (Just model.selectionSortTrack.compareIndex)
                (Just model.selectionSortTrack.minIndex)

            , renderComparison
                -- InsertionSort
                model.insertionSortTrack.array
                "Insertion Sort"
                model.insertionSortTrack.sorted
                model.insertionSortTrack.outerIndex
                (Just model.insertionSortTrack.compareIndex)
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
