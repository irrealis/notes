---
title: "181213-1011-mst_math-trouble-analysis_vocab-scraper.md"
---

# Status:

- Past week: studied math, adding annotations to problems that gave me trouble.


# Thoughts:

Time to take a break from math while I work on other things. Stuff to consider working on:
- Analyze problems with which I had some difficulty. What were the specific problems found? How to address? Can I turn lessons learned into a general strategy to improve performance? What holes exist in my knowledge? What can I study to address?
- I'd like to get the revised vocab scraper up and running. This version will save full web pages for further use; and for now will extract synonym clusters, turning them into flashcards.
- I also have so personal things to take care of.


# Plans:

- Analysis of math difficulties.
  - Query for annotations. Save syntax for future use.
  - What book sections correspond to what troubles? What materials can I focus on for more intensive studies?
  - Enumerate thoughts, troubles, and fixes.
  - Are there faster fixes? that is, are there procedures I could master to quickly apply to all problems, that would greatly improve performance quality while minimally reducing performance speed?
  - Assemble such procedures.
    - Treat as draft to be improved in future, so make it easy to find again.
- Web scraper:
  - Look into Scrapy again. Can I use to manage, streamline, cache?
  - Revisit earlier code. I'd previously built a framework for simulating a student studying vocabulary, in order to avoid being banned. Now I want to incorporate this into a scraper.
  - I'll need an initial list of words and hyperlinks. Actually I'll need a few such lists:
    - 800-ish high-frequency words.
    - 3500 list.
    - 5000 list.
  - I'll need to analyze multiple definition pages.
    - The first effort will work for the first page analyzed.
    - Subsequent pages will trigger parsing errors.
      - **Break on parsing errors.**
      - I hope to cache these pages so I won't need to download them a second time.
    - I'm also going to need to revise what I'm parsing and how.
      - **Again, reuse cache for this.**
  - **Be able to resume in the middle of the job.**
    - The simplest way to cope with this is to start over, but quickly process pages that are already cached.
      - **Check if a new page is cached. If so, parse immediately. Otherwise, simulate wait, then download and cache.**
  - Plan next steps.


# Log:

##### 1011: Start; status/thoughts/plans.

##### 1036: Break, then begin analysis of math difficulties.

##### 1134: Back; analysis of math difficulties.
