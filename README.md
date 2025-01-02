[Visit The Website Here](https://dinosaur-oatmeal.github.io/Sorting-Algorithm-Visualizer/)

# Sorting Algorithm Visualizer in Elm

This project visualizes various sorting algorithms using the **Elm programming language**, a functional programming language designed for building web applications. This project demonstrates how functional programming techniques can be applied to implement and visualize sorting algorithms in an interactive way using bar charts.

## Key Features

- **Functional Programming Paradigm**: All algorithms and visualizations are implemented without mutable states or side effects, adhering to Elm's philosophy of immutability and pure functions.
- **Interactive Visualizations**: Watch sorting algorithms in action as they rearrange arrays step-by-step, allowing users to see the inner workings of sorting algorithms.
- **Modular Design**: Each sorting algorithm is encapsulated in its own module for clarity and reusability, ensuring multiple algorithms may be run in tandem.

## Sorting Algorithms

The following sorting algorithms are included:

### **1. Bubble Sort**  
- A simple sorting algorithm that repeatedly steps through the array, compares adjacent elements, and swaps them if left > right.  
- **Time Complexity**: $O(n^2)$ in the worst case.  
- **Space Complexity**: $O(1)$ (in-place).  

---

### **2. Insertion Sort**  
- Builds a sorted portion of the list incrementally. Starting with the second element, each element is compared to those in the sorted portion (left of the current element) and moved into its correct position.  
- **Time Complexity**: $O(n^2)$ in the worst case.  
- **Space Complexity**: $O(1)$ (in-place).  

---

### **3. Selection Sort**  
- Divides the list into sorted and unsorted parts, finds the smallest element in the unsorted part, and swaps it with the first unsorted element.  
- **Time Complexity**: $O(n^2)$ in all cases.  
- **Space Complexity**: $O(1)$ (in-place).  

---

### **4. Merge Sort**  
- A divide-and-conquer algorithm that recursively divides the list into halves until each sublist contains a single element. It then merges the sublists back together, sorting them when merging.  
- **Time Complexity**: $O(n \log n)$ in all cases.  
- **Space Complexity**: $O(n)$ due to auxiliary arrays being used during merging.  

---

### **5. Quick Sort**  
- A divide-and-conquer algorithm that selects a "pivot" element (rightmost), partitions the list into two sublists (elements less than the pivot and elements greater than the pivot), and recursively sorts the sublists.  
- **Time Complexity**: $O(n \log n)$ on average and $O(n^2)$ in the worst case (bad pivot).  
- **Space Complexity**: $O(\log n)$ on average for recursion stack.  

---

### **6. Shell Sort**  
- Compares and exchanges elements at specific intervals (gaps). The gaps are reduced over iterations, and the algorithm ends with a standard insertion sort (gap = 1). This is an optimization of insertion sort because it allows far-apart elements to be swapped immediately with one another without having to "walk" through the array. The final pass should have little work to do.
- **Time Complexity**: Depends on the gap sequence; $O(n^{3/2})$ or $O(n^{4/3})$ with common sequences; $O(n^2)$ in the worst case.  
- **Space Complexity**: $O(1)$ (in-place).  

