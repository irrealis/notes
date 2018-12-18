---
title: "181218-0715-mst_vocab-scraper.md"
---


# Status:

- Yesterday, _181217-1243-mst_vocab-scraper_flashcards.md_:
  - Followed vocab scraper plan up to point of setting up SQLAlchemy ORM.
    - My old ORM code doesn't work with the latest version of SQLAlchemy, and much of my code's functionality is obsolete.
    - Worked out basic SQLAlchemy code to create db and tables, and simple ORM. Should suffice.
    - I'm still debating whether to model sense relationships in the database.


# Thoughts:

- On the fence wrt modeling sense relationships. I'm leaning toward doing it.
  - On one hand, it's increased complexity, both in setup and in studying.
  - On the other hand, I've seen these relationships required in many vocabulary questions.
  - Having these complexities in studies will slow the studies.
  - Not having them will decrease study quality.
- I think I'm going to try modeling the relationships in the database, and see how difficult it will be. If too hard, move on.


# Plans:

- As yesterday, _181217-1243-mst_vocab-scraper_flashcards.md_, except:
  - Try to model sense relationships in database. Watch difficulty. If this turns into a rabbit hole, escape and move on.


# Log:

##### 0715: Start; status/thoughts/plans.

##### 0731: Attempting to model sense relationships in database.
