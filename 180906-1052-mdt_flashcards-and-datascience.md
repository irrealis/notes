---
title: "180906-1052-mdt_flashcards-and-datascience.Rmd"
---

# Status:

- Yesterday, _180905-1131-mdt_flashcards-and-datascience.Rmd_:
  - Got basic flashcard updates working. This allows me to maintain study statistics in Anki for flashcards under version, even as I edit the flashcard specs in YAML files and then send the updates to Anki. This had previously been a stumbling block, when editing a card's specs and then recreating the cards would result in erasing study statistics.
  - I didn't spend time on data-science studies.

- Today:
  - Primary focus should be datascience review.
  - Second focus should be filling in AFI flashcards, and study for coding interviews.
  - Third focus should be personal projects.


# Thoughts:

My priority stack has become a bit too deep. I'm simplifying and moving stuff to lower priority or to wishlists, or discarding.


# Plans:

- Data science:
  - Transfer and reorganize datascience flashcards to new YAML system under version control.
  - To get self back up to speed, review previous courses.
    - Go over lectures again, taking notes.
    - Try to move quickly on this. Focus on review.

- AFI flashcards:
  - Go over notes, moving answers into recently setup flashcards. Also find roundrobin problem lists, and resume, writing answers into flashcards.
    - Remember, **no rote memorization.** The goal of these flashcards is to pose problems requiring that I **think through the steps of each algorithm/solution/proof**.
  - Set aside time each data to drill on problems in completed flashcards.


# Notes:

- TripleByte:
  - "We help engineers identify high-growth opportunities, get their foot in the door with our recommendation, and negotiate multiple offers."
  - https://triplebyte.com/


# Log:

##### 1052: Start; status/thoughts/plans.

##### 1140: Start data-science review.

- Reviewing courses in the Data Science track by Johns Hopkins University on Coursera.
- Thoughts:
  - I'm finding as I review that there's lots of repetition in these courses.
  - Also lots of proselytizing. Drinking of Kool-Aid.
    - _Reproducible Research_
    - _Tidy Data_
  - Some of these courses are rather nebulous.
  - Skipping most of the following:
    - CLI review
    - Git review
    - Markdown review

- Courses to review:

  - The Data Scientist's Toolbox

  - R Programming
    - Data types
    - Subsetting
    - Reading and writing data
    - Control structures
    - Functions
    - Scoping
    - Vectorized operations
    - Dates and times
    - Debugging
    - Simulation
    - Optimization

  - Getting and Cleaning Data
    - Raw vs. tidy data.
    - Downloading files.
    - Reading data.
      - Excel, XML, JSON, MySQL, HDF5, Web, ...
    - Merging data.
    - Reshaping data.
    - Summarizing data.
    - Finding and replacing.
    - Data resources. **(?)**
      - To augment the data you already have.

  - Exploratory Data Analysis
    - Principles of Analytic Graphics.
    - Exploratory graphs.
    - Plotting systems in R:
      - base
      - lattice
      - ggplot2
    - Hierarchical clustering
    - K-Means clustering
    - Dimension reduction

  - Reproducible Research
    - Structure of a data analysis.
    - Organizing a data analysis.
    - Markdown.
    - LaTeX.
    - R Markdown.
    - Evidence-based data analysis.
    - RPubs.
    - Steps in a data anlaysis: **Substantially identical to section** ***The Data Scientist's Toolbox.***
      - Define the question.
      - Define the ideal data set.
      - Determine what data you can access.
      - Obtain the data.
      - Clean the data.
      - Exploratory data analysis.
      - Statistical prediction/modeling.
      - Interpret results.
      - Challenge results.
      - Synthesize/write up results.
      - Create reproducible code.
    - Data analysis files:
      - Data:
        - Raw data.
        - Processed data.
      - Figures:
        - Exploratory figures.
        - Final figures.
      - R code:
        - Raw scripts.
        - Final scripts.
        - R Markdown files (optional).
      - Text:
        - Readme files.
        - Text of analysis.

- Upcoming courses:

  - Statistical Inference
    - Basic probability.
    - Likelihood.
    - Common distributions.
    - Asymptotics.
    - Confidence intervals.
    - Hypothesis tests.
    - Power.
    - Bootstrapping.
    - Non-parametric tests.
    - Basic Bayesian statistics.

  - Regression Models
    - Linear regression
    - Multiple regression
    - Confounding
    - Residuals and diagnostics
    - Prediction using linear models
    - Scatterplot smoothing and splines
    - Machine learning via regression
    - Resampling inference in regression, bootstrapping, permutation tests
    - Weighted regression
    - Mixed models (random intercepts)

  - Practical Machine Learning
    - Prediction study design
    - Types of Errors
    - Cross validation
    - The caret package
    - Plotting for prediction
    - Preprocessing
    - Predicting with regression
    - Prediction with trees
    - Boosting
    - Bagging
    - Model blending
    - Forecasting

  - Developing Data Products
    - R packages (for the engineers):
      - devtools
      - roxygen
      - testthat
    - rCharts (for marketing)
    - Slidify
    - Shiny (for your users)

  - Data Science Capstone


- Data-science textbooks:
  - By Jeff Leek:
    - Statistics of analyzing genomics data
    - [Elements of Data Analytic Style](https://leanpub.com/datastyle)
  - By Roger Peng:
    - Statistics of analyzing fine particulate matter
    - [R Programming for Data Science](https://leanpub.com/rprogramming?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2)
    - [Exploratory Data Analysis with R](https://leanpub.com/exdata?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2)
    - [Report Writing for Data Science in R](https://leanpub.com/reportwriting?utm_source=DST2&utm_medium=Reading&utm_campaign=DST2)
  - By Brian Caffo
    - Statistics of analyzing brain imaging data
    - [Statistical Inference for Data Science](https://leanpub.com/LittleInferenceBook)
    - [Regression Modeling for Data Science in R](https://leanpub.com/regmods)
    - [Developing Data Products in R](https://leanpub.com/ddp)


##### 1441: Regroup.

Having some trouble here. The first course, TDST, is very scattered and broad. This make sense, as part of its goal is to briefly describe most of the other courses in the track. This also means there's some redundancy. Some of this I've already encountered. For example, the steps of a typical data analysis are listed briefly in TDST, and again in RR (Reproducible Research) where they're covered in greater detail.

There's some material in TDST that I haven't seen elsewhere yet. For example, definitions of true/false positives, type I/II error; I expect to see these in upcoming courses. But I suspect that some material won't be covered anywhere else, e.g., the brief overviews of Git, or the Unix command-line interface.

I don't want to miss anything, but I also don't want to waste time sorting through material multiple times. Since for some of this material I don't yet know whether it will be covered in greater detail, it may be better to skip TDST for now, and come back to it after I've finished the rest of the courses in this track.

That said, I'm now moving on to the second course, RP (R Programming).


Another thought: there's lots of material here that must be rote-memorized. Don't think I can get away from that. Hope to balance with various data-science problems which will require thought.


##### 1702: Pausing, possibly stopping for night.
