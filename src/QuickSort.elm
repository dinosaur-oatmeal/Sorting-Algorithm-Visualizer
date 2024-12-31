module QuickSort exposing (quickSortStep)

import Array exposing (Array)
import Structs exposing (SortingTrack)

{- Pop a subarray range from stack
   Select a pivot (right element) to sort around
   Push indices of left and right subarrays onto stack
   Select a new pivot in each subarray
   Recursively select new pivots until an array with one element is left
-}

quickSortStep : SortingTrack -> SortingTrack
quickSortStep track =
    case track.stack of
        [] ->
            -- Sorted if stack is empty
            { track
                | sorted = True
            }

        (low, high) :: rest ->
            -- Range is valid to be sorted
            if low < high then
                let
                    -- Partition array and get pivot index
                    (pivotIndex, newTrack) = partition low high track

                    -- Push left and right subarrays onto stack
                    newStack =
                        (low, pivotIndex - 1) :: (pivotIndex + 1, high) :: rest
                in
                -- Update track for next pass in
                { newTrack
                    | stack = newStack
                    , currentStep = track.currentStep + 1
                    , outerIndex = pivotIndex
                    , currentIndex = low
                }
            else
                -- Invalid range (already sorted), delete subarrays on stack
                { track
                    | stack = rest
                }

partition : Int -> Int -> SortingTrack -> (Int, SortingTrack)
partition low high track =
    let
        -- Pivot is rightmost element
        pivot = Array.get high track.array |> Maybe.withDefault 0
        
        -- Helper function to process each element in subarray
        loop (currentTrack, partitionIndex) currentIndex =
            let
                -- Get currentElement being processed
                currentElement = Array.get currentIndex currentTrack.array |> Maybe.withDefault 0
            in
            if currentElement < pivot then
                let
                    -- Swap current element with partition index if < pivot value
                    updatedArray = swap currentIndex partitionIndex currentTrack.array
                in
                ( { currentTrack |
                    array = updatedArray }
                    , partitionIndex + 1
                )
            else
                -- Don't do anything if current element >= partition index
                (currentTrack, partitionIndex)

        -- Iterate through range of subarray
        (newTrack, pivotIndex) =
            List.foldl
                (\currentIndex acc -> loop acc currentIndex)
                (track, low)
                (List.range low (high - 1))

        -- Swap pivot element into correct position at end
        finalArray = swap pivotIndex high newTrack.array
    in
    -- Return final pivot index and updated SortingTrack
    ( pivotIndex, { newTrack | array = finalArray } )

-- Helper function to swap two elements in an array
swap : Int -> Int -> Array Int -> Array Int
swap indexOne indexTwo arr =
    let
        -- Grab Elements to be swapped
        elementOne = Array.get indexOne arr |> Maybe.withDefault 0
        elementTwo = Array.get indexTwo arr |> Maybe.withDefault 0
    in
    arr
        -- Swap position of elements in array
        |> Array.set indexOne elementTwo
        |> Array.set indexTwo elementOne
