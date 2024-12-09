{-  All files need access to the sorting track.
    Keeping it in a separate file removes the potential
        of circular imports.
-}

module Structs exposing (SortingTrack, Model)

import Array exposing (Array)

-- Holds the state for a sorting algorithm at any given step
type alias SortingTrack =
    -- Current array that's being sorted
    { array : Array Int
    -- Loops with an outer pass (Bubble/Insertion/Selection)
    , outerIndex : Int
    -- Position of element that's being compared
    , compareIndex : Int
    -- Minimum index in part of array unsorted (Selection)
    , minIndex : Int
    -- Tells us if the array is sorted
    , sorted : Bool
    -- Indicates if a swap occurred in the current pass through array (Bubble)
    , didSwap : Bool
    }

-- Holds the state of the entire application and gets updated via subscriptions
type alias Model =
    -- Every algorithm gets its own sorting algorithm
        -- Needed to keep everything independent of one another
    { bubbleSortTrack : SortingTrack
    , selectionSortTrack : SortingTrack
    , insertionSortTrack : SortingTrack
    -- Flag to determine if the sorting algorithms are running
        -- needed for start button
    , running : Bool
    }
