module SelectionSort exposing (selectionSortStep)

import Array exposing (Array)

-- Access to structs needed for program
import Structs exposing (Model, SortingTrack)

{-  Move through the array with outerIndex
    For each outerIndex, find the smallest element in the rest of array
    When compareIndex reaches the end of the array, swap outerIndex with compareIndex
    Increment outerIndex and repeat until the end of the array is hit
-}

selectionSortStep : SortingTrack -> SortingTrack
selectionSortStep track =
    let
        arr = track.array
        o = track.outerIndex
        c = track.compareIndex
        m = track.minIndex
        len = Array.length arr
    in
    -- Array already sorted or end of array reached
    if track.sorted || o >= len then
        { track
            | sorted = True
        }
    else
        if c < len then
            -- Compare element at c with element at m
            case (Array.get c arr, Array.get m arr) of
                (Just cv, Just mv) ->
                    if cv < mv then
                        -- Found a new minimum
                        { track
                            | compareIndex = c + 1, minIndex = c
                        }
                    else
                        -- Current element isn't smaller than min
                        { track
                        | compareIndex = c + 1
                        }

                -- Default constructor
                _ ->
                    track

        else
            -- CompareIndex reached end so swap minIndex with outerIndex
            case (Array.get o arr, Array.get m arr) of
                (Just ov, Just mv) ->
                    let
                        -- Update array to reflect swap
                        newArray =
                            if m /= o then
                                Array.set o mv (Array.set m ov arr)
                            else
                                arr

                        didSwap = (m /= o)
                    in
                    -- Update track to reflect new array
                    { track
                        | array = newArray
                        , outerIndex = o + 1
                        , compareIndex = o + 2
                        , minIndex = o + 1
                        , didSwap = didSwap
                    }

                -- Default constructor
                _ ->
                    track
