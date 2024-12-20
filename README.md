# Sorting Algorithm Visualizer in Elm

This project visualizes various sorting algorithms using the **Elm programming language**, a functional programming language designed for building web applications. This project demonstrates how functional programming techniques can be applied to implement and visualize sorting algorithms in an interactive way using bar charts.

## Project Overview

This repository contains the following Elm modules:

- **Main.elm**: The brain of the application, connecting each sorting algorithm with the visualization functions.
- **BubbleSort.elm**: Implements one step of the Bubble Sort algorithm, swapping elements each iteration.
- **InsertionSort.elm**: Implements one step of the Insertion Sort algorithm, walking toward the beginning of the array.
- **SelectionSort.elm**: Implements one step of the Selection Sort algorithm, tracking the minimum element.
- **Visualization.elm**: Renders pieces of the sorting visualizations, combining them into charts.
- **Structs.elm**: Defines custom types used throughout the rest of the application for easy implementation.

## Key Features

- **Functional Programming Paradigm**: All algorithms and visualizations are implemented without mutable states or side effects, adhering to Elm's philosophy of immutability and pure functions.
- **Interactive Visualizations**: Watch sorting algorithms in action as they rearrange arrays step-by-step, allowing users to see the inner workings of sorting algorithms.
- **Modular Design**: Each sorting algorithm is encapsulated in its own module for clarity and reusability, ensuring multiple algorithms may be run in tandem.

## Sorting Algorithms

The following sorting algorithms are included:

1. **Bubble Sort**:
   - A sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.

2. **Insertion Sort**:
   - Builds the sorted array one item at a time by repeatedly picking the next element and inserting it into the correct position.

3. **Selection Sort**:
   - Divides the list into a sorted and unsorted region, repeatedly selecting the smallest element from the unsorted region and moving it to the sorted region.
