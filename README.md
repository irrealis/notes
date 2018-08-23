# notes

My notebook. Publicly-viewable, but not very interesting to anyone other than me.

## Status:

- Studies:
  - Completed AFI flashcard fronts through c9.


# To do:

- Top priorities:
    - Study for coding interviews. Setup related drills.
    - Long-term planning.
- Medium priorities:
    - Resume data-science studies.
    - Strategy to build Singularity images to a _SingularityImages/_ directory.
        - _SingularityImages/_ should not be backed up.
        - Move Singularity files to a _SingularityFIles/_ directory.
        - _SingularityFIles/_ should be backed up.
    - Examples of:
        - Packrat with SCIF.
        - Virtualenv with SCIF.
    - Learn more about how Nix/NixOS work. Become more comfortable. Transition to Nix-based containers.
- Low priorities:
  - Explore TopCoder: https://www.topcoder.com/
  - Explort NumFOCUS: https://numfocus.org/


# Brainstorming:

- Possible SCIF approach:
  - For an app in development, bind code and data dirs from the host to the app's code and data dirs in the container.
    - Use a shell script to do this from the host.
  - Revise project structure ideas accordingly,
    - Project structure should now more closely resemble a SCIF app.


# Notes:

- Apparently the following are proven intractable:
  - _check the validity of relationships involving $\exists, +, <, \rightarrow$._
    - Aziz and Prakash; _Algorithms for Interviews_; version 1.0.0 (September 1, 2010); p 56.
- The canonical NP-complete problem is _CNF-SAT_.
  - The subproblem _3-SAT_ is also NP-complete. It serves as a good fallback candidate for reductions.
  - To prove a given problem NP-complete, reduce a known NP-complete problem to the given problem. _Not the other way around._
  - _S. Skiena; _The Algorithm Design Manual_; 2nd ed.; pp 330-1.


# Questions:

- **What is a _union-find_ data structure?**
- **In what ways can graphs be represented?**
  - Builtin adjacency lists
  - Builtin adjacency maps
  - External adjacency lists
  - External adjacency maps
  - Adjacency matrix
  - ... ?
- **What is the formal definition of _NP-complete?_ _NP-hard?_ _NP_?**


# Wishlist:

- Read _R. Karp; 1972; "Reducibility Among Combinatorial Problems"_.
