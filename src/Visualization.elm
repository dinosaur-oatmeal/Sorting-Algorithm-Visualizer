module Visualization exposing (renderComparison)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Array exposing (Array)
import String


-- Render comparison for sorting algorithms
renderComparison : 
    Array Int -> String -> Bool -> Int -> 
    Array Int -> String -> Bool -> Int ->
    Array Int -> String -> Bool -> Int -> 
    Html msg
renderComparison 
    array1 title1 sorted1 currentIndex1 
    array2 title2 sorted2 currentIndex2
    array3 title3 sorted3 currentIndex3 =
    
    div 
        [ style "display" "flex"
        , style "justify-content" "space-around"
        , style "width" "100%"
        , style "padding" "20px"
        ]
        -- Render charts for each sorting algorithm
        [ renderBarChart array1 title1 sorted1 currentIndex1
        , renderBarChart array2 title2 sorted2 currentIndex2
        , renderBarChart array3 title3 sorted3 currentIndex3
        ]


-- Render bar chart for each sorting algorithm
renderBarChart : 
    Array Int -> String -> Bool -> Int -> 
    Html msg
renderBarChart array title sorted currentIndex =
    div 
        [ style "margin" "20px"
        , style "text-align" "center"
        , style "flex" "1"
        ]
        [ div 
            [ style "font-size" "20px"
            , style "margin-bottom" "10px"
            , style "font-weight" "bold"
            ]
            [ text title ]
        , div 
            [ style "display" "flex"
            , style "align-items" "flex-end"
            , style "justify-content" "center"
            , style "height" "300px"
            , style "border" "1px solid #ccc"
            , style "padding" "10px"
            ]
            (Array.toList array |> List.indexedMap (renderBar sorted currentIndex))
        ]


-- Render individual bar
renderBar : Bool -> Int -> Int -> Int -> Html msg
renderBar sorted currentIndex position value =
    let
        -- Find current index to color it differently
        isCurrent = position == currentIndex

        barColor =
            if sorted then
                "#4CAF50" -- Green when sorted
            else if isCurrent then
                "#FF5722" -- Red for current element
            else
                "#2196F3" -- Blue otherwise
    in
    div 
        [ style "width" "30px"
        , style "height" (String.fromInt (value * 10) ++ "px")
        , style "background-color" barColor
        , style "margin" "2px"
        , style "transition" "height 0.5s ease, background-color 0.5s ease"
        ]
        []
