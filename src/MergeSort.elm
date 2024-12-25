module MergeSort exposing (mergeSortStep)

import Array exposing (Array)
import Structs exposing (SortingTrack)

{-  Divide the array into subarrays until each subarray has one element
    Merge adjacent subarrays by comparing elements and sorting them
    Continue merging until the entire array is sorted
-}

-- Custom record to hold all data and tracked indices for merge sort
    -- tuple didn't work with more than 3 items
type alias MergeState =
    { array : Array Int
    , nextStep : Int
    , sorted : Bool
    , currentIndex : Int
    , outerIndex : Int
    }

mergeSortStep : SortingTrack -> SortingTrack
mergeSortStep track =
    let
        array = track.array
        arrayLength = Array.length array

        -- Update custom MergeState record
        state = mergeSortHelper array track.currentStep arrayLength
    in
    -- Update SortingTrack (passed to Main.elm) with updated variables
    { track
        | array = state.array
        , currentStep = state.nextStep
        , sorted = state.sorted
        , outerIndex = state.outerIndex
        , currentIndex = state.currentIndex
    }

-- Perform one step of merge sort on the array
mergeSortHelper : Array Int -> Int -> Int -> MergeState
mergeSortHelper array currentStep arrayLength =
    -- Update MergeState to be sorted if length is 1 or less
    if arrayLength <= 1 then
        { array = array
        , nextStep = currentStep
        , sorted = True
        , currentIndex = 0
        , outerIndex = 0
        }
    else
        let
            -- Find left, mid, and right values
            left = Array.slice 0 mid array
            mid = arrayLength // 2
            right = Array.slice mid arrayLength array

            -- Only sort left if currentStep = 1
            sortedLeft = if currentStep == 0 then left else mergeSortArray left
            -- Only sort right if currentStep = 0 (sorted first)
            sortedRight = if currentStep == 1 then right else mergeSortArray right

            -- Merge subarrays into one
            mergedArray = mergeArrays sortedLeft sortedRight

            -- Left index is 0 if length > 0
            leftIndex = if Array.length left > 0 then 0 else -1
            -- Right index is mid if length > 0
            rightIndex = if Array.length right > 0 then mid else -1

            -- Cheat to check if array is sorted
            isFullySorted = Array.toList mergedArray == List.sort (Array.toList array)

            -- Increment step counter
            nextStep = currentStep + 1
        -- Update MergeState to track variables
        in
        { array = mergedArray
        , nextStep = nextStep
        , sorted = isFullySorted
        , currentIndex = leftIndex
        , outerIndex = rightIndex
        }

-- Recursively sort an array using merge sort
mergeSortArray : Array Int -> Array Int
mergeSortArray array =
    let
        arrayLength = Array.length array
    in
    -- Return array as is because 1 element or less is sorted
    if arrayLength <= 1 then
        array
    else
        let
            -- Find left, mid, and right values for divide
            left = Array.slice 0 mid array
            mid = arrayLength // 2
            right = Array.slice mid arrayLength array
        in
        -- Recursively sorts arrays into 1 greater array
        mergeArrays (mergeSortArray left) (mergeSortArray right)

-- Merge two sorted arrays into a single sorted array
mergeArrays : Array Int -> Array Int -> Array Int
mergeArrays leftArray rightArray =
    let
        mergeHelper leftIndex rightIndex combinedArray =
            case (Array.get leftIndex leftArray, Array.get rightIndex rightArray) of
                (Just leftValue, Just rightValue) ->
                    -- append leftValue to new array and increment leftIndex
                    if leftValue < rightValue then
                        mergeHelper (leftIndex + 1) rightIndex (Array.append combinedArray (Array.fromList [leftValue]))
                    -- append rightValue to new array and increment rightIndex
                    else
                        mergeHelper leftIndex (rightIndex + 1) (Array.append combinedArray (Array.fromList [rightValue]))

                -- Only leftArray has values, so append the rest of leftArray
                (Just leftValue, Nothing) ->
                    mergeHelper (leftIndex + 1) rightIndex (Array.append combinedArray (Array.fromList [leftValue]))

                -- Only rightArray has values, so append the rist of rightArray
                (Nothing, Just rightValue) ->
                    mergeHelper leftIndex (rightIndex + 1) (Array.append combinedArray (Array.fromList [rightValue]))

                -- Both smaller arrays exhausted and return final combinedArray
                (Nothing, Nothing) ->
                    combinedArray
    in
    -- Initial call to mergeHelper
    mergeHelper 0 0 Array.empty
