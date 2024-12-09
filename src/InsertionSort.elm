module InsertionSort exposing (insertionSortStep)

import Array exposing (Array)

-- Access to structs needed for program
import Structs exposing (Model, SortingTrack)


{-  Take element at outerIndex and move it into sorted position of array
    Each step, compare array[comparIndex] with array[compareIndex + 1]
    If they're out of order, swap them and move compareIndex back once toward beginning of array
    Once in order or beginning hit, insert the element and move outerIndex right once
-}

insertionSortStep : SortingTrack -> SortingTrack
insertionSortStep track =
    let
        arr = track.array
        o = track.outerIndex
        c = track.compareIndex
        len = Array.length arr
    in
    -- Array already sorted or end of array reached
    if track.sorted || o >= len then
        { track
            | sorted = True
        }
    else
        if c <= 0 then
            -- Done inserting element at outerIndex, move to next element
            { track
                | outerIndex = o + 1
                , compareIndex = o + 1
                , didSwap = False
            }
        else
            case (Array.get c arr, Array.get (c - 1) arr) of
                (Just cv, Just pv) ->
                    if cv < pv then
                        let
                            -- Swap elements where smaller goes left
                            swappedArray =
                                Array.set (c - 1) cv (Array.set c pv arr)
                        in
                        -- Decrement compareIndex to move to front of array
                        { track
                            | array = swappedArray
                            , compareIndex = c - 1
                            , didSwap = True
                        }
                    else
                        -- No swap needed, so insertion for element is done
                        { track
                            | outerIndex = o + 1
                            , compareIndex = o + 1
                            , didSwap = False
                        }

                -- Default constructor
                _ ->
                    track
