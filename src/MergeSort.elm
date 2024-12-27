module MergeSort exposing (mergeSortStep)

import Array exposing (Array)
import Structs exposing (SortingTrack)

{-  Divide the array into subarrays until each subarray has one element
    Merge adjacent subarrays by comparing elements and sorting them
    Continue merging until the entire array is sorted
    Track process with currentStep
-}

mergeSortStep : SortingTrack -> SortingTrack
mergeSortStep track =
    let
        array = track.array
        arrayLength = Array.length array
        currentStep = track.currentStep
        outerIndex = track.outerIndex

        -- Track steps to know when sorting is complete (log2 array length)
        totalSteps = ceiling (logBase 2 (toFloat arrayLength))

        -- Check if sorting is complete
        isSorted = currentStep > totalSteps

        -- Calculate halfStep (midpoint of current step)
        halfStep = 2 ^ currentStep // 2
        
        updatedArray =
            -- Perform one step of merging
            if not isSorted then
                -- One step of MergeSort
                processMergeStep currentStep halfStep array
            -- Don't update array if sorted
            else
                array

    -- Update track with necessary info for next step
    in
    { track
        | array = updatedArray
        -- Current step updates to know if sorting complete
        , currentStep =
            if isSorted then
                currentStep
            else
                currentStep + 1
        , outerIndex = halfStep
        , sorted = isSorted
    }

-- Process one step of merging based on the current step
processMergeStep : Int -> Int -> Array Int -> Array Int
processMergeStep currentStep halfStep array =
    let
        arrayLength = Array.length array
        -- Size of arrays being merged
        stepSize = 2 ^ currentStep

        -- Recursively process each segment pair and merge them
        processSegments start acc =
            if start >= arrayLength then
                acc
            else
                let
                    -- Left: start to (start + halfStep)
                    left = Array.slice start (start + halfStep) array
                    -- Right: (start + halfStep) to (start + stepSize)
                    right = Array.slice (start + halfStep) (start + stepSize) array
                    -- Call mergeArrays function with subarrays
                    merged = mergeArrays left right
                in
                -- Recursively call processSegments (Divide)
                processSegments (start + stepSize) (Array.append acc merged)
    in
    -- Initial call to processSegments
    processSegments 0 Array.empty

-- Merge two sorted arrays into a single sorted array (Conquer)
mergeArrays : Array Int -> Array Int -> Array Int
mergeArrays leftArray rightArray =
    let
        -- Recursively merges elements
        mergeHelper leftIndex rightIndex combinedArray =
            case (Array.get leftIndex leftArray, Array.get rightIndex rightArray) of
                (Just leftValue, Just rightValue) ->
                    -- Append leftValue to new array if smaller and increment leftIndex
                    if leftValue < rightValue then
                        mergeHelper (leftIndex + 1) rightIndex (Array.append combinedArray (Array.fromList [leftValue]))
                    -- Append rightValue to new array if smaller and increment rightIndex
                    else
                        mergeHelper leftIndex (rightIndex + 1) (Array.append combinedArray (Array.fromList [rightValue]))

                -- Only leftArray has values, so apped the rest of leftArray
                (Just leftValue, Nothing) ->
                    mergeHelper (leftIndex + 1) rightIndex (Array.append combinedArray (Array.fromList [leftValue]))

                -- Only rightArray has values, so append the rest of rightArray
                (Nothing, Just rightValue) ->
                    mergeHelper leftIndex (rightIndex + 1) (Array.append combinedArray (Array.fromList [rightValue]))

                -- Both smaller arrays are empty, so return final array
                (Nothing, Nothing) ->
                    combinedArray
    in
    -- Initial call to mergeHelper
    mergeHelper 0 0 Array.empty
