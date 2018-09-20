# Notes

This is my public notebook. It's under version control for my own benefit, although anyone is welcome to read it. However, it's generally of use and interest only to me.


## Status:

- Studies:
  - Working on data-science review.
  - Working on flashcards for recently-studied data structures and algorithms.
  - Recently setup code to update existing flashcards from YAML spec files.
  - Completed AFI flashcard fronts.


## To do:

- Top priorities:
  - Long-term planning.

  - Data science:
    - Review.
    - Transfer existing data-science flashcards to YAML spec files in new version-controlled repo.
    - After review of previous studies, resume current studies.

  - Study for coding interviews. Setup related drills.
    - I need to do a detailed study of heap sort and heap properties.
    - I'll need to review basics of each language, and make flashcards for these.
      - Basic types
      - Representations of basic types in memory
      - Representations of composite in memory
      - Memory management, e.g., garbage collection approaches
      - Call stack layout
      - Ways for memory leaks to occur
      - Program representation in memory
      - Commonly-used libraries
        - System
        - Third-party
    - Debugging and testing:
      - Techniques for distributed programs
      - Challenges and approaches to debugging/testing concurrent code
      - Tools:
        - Debuggers
        - Profilers
        - Leak detection and analysis
        - Testing frameworks

- Medium priorities:
  - Flashcard code:
    - Wishlist, per notes in [180905-1131-mdt](180905-1131-mdt_flashcards-and-datascience.Rmd):
      - Code review
      - Testing and refactoring
    - Low-priority wishlist:
      - Expand _anki_connect_client.py_:
        - Add methods corresponding to full Anki-Connect API.
        - Add commands calling corresponding methods.
          - Accept args in JSON or YAML files.
          - Accept args from command line?
        - Interpreter?

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


## Thoughts:

- **No rote memorization.**
  - The flashcard goal: pose problem whose solutions require that I **think through the steps of algorithms and proofs.**
- Possible SCIF approach:
  - For an app in development, bind code and data dirs from the host to the app's code and data dirs in the container.
    - Use a shell script to do this from the host.
  - Revise project structure ideas accordingly,
    - Project structure should now more closely resemble a SCIF app.


## Notes:

- Apparently the following are proven intractable:
  - _check the validity of relationships involving $\exists, +, <, \rightarrow$._
    - Aziz and Prakash; _Algorithms for Interviews_; version 1.0.0 (September 1, 2010); p 56.
- The canonical NP-complete problem is _CNF-SAT_.
  - The subproblem _3-SAT_ is also NP-complete. It serves as a good fallback candidate for reductions.
  - To prove a given problem NP-complete, reduce a known NP-complete problem to the given problem. _Not the other way around._
  - _S. Skiena; _The Algorithm Design Manual_; 2nd ed.; pp 330-1.


## Questions:

- **What is a _union-find_ data structure?**
- **In what ways can graphs be represented?**
  - Builtin adjacency lists
  - Builtin adjacency maps
  - External adjacency lists
  - External adjacency maps
  - Adjacency matrix
  - ... ?
- **What is the formal definition of _NP-complete?_ _NP-hard?_ _NP_?**
- What is the _simplex algorithm for linear programming_?
- What is the _AKS primality-checking algorithm_?
- What is the _KMP string-matching algorithm_?


## Wishlist:

- Study how Thomas Hertog speaks: https://www.youtube.com/watch?v=Ry_pILPr7B8

- Look into API Blueprint: https://apiblueprint.org/

- Algorithms and software development:
  - _R. Karp; 1972; "Reducibility Among Combinatorial Problems"_.
  - _Kernighan and Ritchie; "The C Programming Language"_
  - _Sestoft; "Java Precisely"_
  - _Bloch; "Effective Java"_
  - _Meyer; "Effective C++"_
  - _Gamma et al.; "Design Patterns: Elements of Reusable Object-Oriented Software"_
  - _Scott; "Programming Languages Pragmatics"_
  - _Tanenbaum; "Modern Operating Systems"_
  - _Zeller and Krinke; "Essential Open Source Toolset"_
  - _Natarajan; "Linux 101 Hacks"_

- Data-science:
  - Textbooks:
    - Leek: [Elements of Data Analytic Style](https://leanpub.com/datastyle): Statistics of analyzing genomics data
    - Peng: [R Programming for Data Science](https://leanpub.com/rprogramming?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2): Statistics of analyzing fine particulate matter
    - Peng: [Exploratory Data Analysis with R](https://leanpub.com/exdata?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2)
    - Peng: [Report Writing for Data Science in R](https://leanpub.com/reportwriting?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2)
    - Caffo: [Statistical Inference for Data Science](https://leanpub.com/LittleInferenceBook): Statistics of analyzing brain imaging data
    - Caffo: [Regression Modeling for Data Science in R](https://leanpub.com/regmods)
    - Caffo: [Developing Data Products in R](https://leanpub.com/ddp)
    - Peng: [The Art of Data Science](https://leanpub.com/artofdatascience?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2)
    - Leek: [How to Be A Modern Scientist](https://leanpub.com/modernscientist)

  - Further reading:

    - The Economist, *The data deluge*, http://www.economist.com/node/15579717
    - McKinsey Global Institute: *Big data: The next frontier for innovation, competition, and productivity*: http://www.mckinsey.com/insights/business_technology/big_data_the_next_frontier_for_innovation
    - The New York Times: *For Today's Graduate, Just One Word: Statistics*: http://www.nytimes.com/2009/08/06/technology/06stats.html
    - The New York Times: *Data Analysts Captivated by R's Power*: http://www.nytimes.com/2009/01/07/technology/business-computing/07program.html
    - DJ Patil, O'Reilly Radar: *Building data science teams*: http://radar.oreilly.com/2011/09/building-data-science-teams.html
    - The New York Times: *In Head-Hunting, Big Data May Not Be Such a Big Deal*: http://www.nytimes.com/2013/06/20/business/in-head-hunting-big-data-may-not-be-such-a-big-deal.html
    - Dataists: http://www.dataists.com/
    - Alluvium: http://www.alluvium.io/
