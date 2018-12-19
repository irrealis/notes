---
title: "181219-0957-mst_vocab-scraper.md"
---

# Status:

Yesterday, _181218-0715-mst_vocab-scraper.md_:
- Vocab scraper:
  - Built and tested database tables and interface.
    - Uses SQLAlchemy ORM.
      - Tables:
        - `vocabs`: vocabulary lists.
        - `words`
          - Associated with `vocabs` via `vocab_words` many-to-many join table.
        - `senses`: word-meaning senses.
          - Associated with `words` via `sense_words` many-to-many join table.
          - Associated with self via `related_senses` many-to-many join table.
            - This table aso carries a `relation_type` field, containing one of `synonym`, `antonym`, `type-of`.
      - Verified all tables using dummy data.
        - Only verified `type-of` relationship.
        - **To do: verify `synonym` and `antonym` relationships.**
    - Uses Alembic for db migrations.
  - Used Selenium/Chrome to scrape data from vocab site.
    - Limited to two vocabulary lists:
      - "800 high frequency words GRE"
      - "5000 GRE Words 1"
    - Did not scrape definitions or sense relationships.
    - **To do: annotate code not in notes.**
    - **To do: record in notes the locations of code.**
  - Used database interface to store scraped data.
    - **To do: record in notes the locations of database.**


# Thoughts:

- I need to mock up some vocab flashcards using this data. Don't need to generate actual flashcards, but do need to make sure I have the data I need.
- I might in future want to know the order of senses for a word.
  - This might capture primary meaning.
  - **Is this already encoded in the database, via the join tables?**
    - _No, because I don't use autoincrementing IDs in these tables._
    - **Could I add an autoincrementing ID to capture this?**
      - Not sure. Doing this might change how SQLAlchemy sets up mapping.


# Plans:

- As yesterday, _181218-0715-mst_vocab-scraper.md_ except:
  - Handle to-do items:
    - Verify `synonym` and `antonym` relationships.
    - Annotate code not in notes.
    - Record in notes the locations of code.
    - Record in notes the locations of database.
  - Skip or defer scheduling system.
  - On to setup.


# To do:

- **Convert manual tests into automated.**

# Log:

##### 0957: Status/thoughts/plans.

##### 1041: Verify `synonym` and `antonym` relationships.

- Errors found:
  - In `add_antonym` method, should be checking in `self.antonyms`, not `self.antonym`.
  - In `add_type` method, `left` and `right` arguments should be swapped.
- Propagated fixes to code in _gre_words/db_interface.py_.


```{python }
%cd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
%rm vocab.sqlite

from sqlalchemy import Table, Column, Integer, Float, Numeric, Text, Enum, MetaData, ForeignKey, create_engine

from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session, relationship

import enum

metadata = MetaData()

# Vocabulary lists.
Table('vocabs', metadata,
  Column('id', Integer, primary_key = True, autoincrement = False),
  Column('description', Text),
)

# Words and definitions.
Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Float)
)

# Vocabulary-Word join table, many-to-many.
Table('vocab_words', metadata,
  Column('vocab_id', Integer, ForeignKey('vocabs.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

# Word-definition/-synonym senses.
Table('senses', metadata,
  Column('id', Integer, primary_key = True),
  Column('sense', Text),
)

# Sense-Word join table, many-to-many.
Table('sense_words', metadata,
  Column('sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

# Sense-Sense association table, many-to-many.
class SenseRelationKind(enum.Enum):
  synonym = 1
  antonym = 2
  type_of = 3

Table('sense_relations', metadata,
  Column('l_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('r_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('relation_kind', Enum(SenseRelationKind)),
)

Base = automap_base()

# I use this class mainly to simplify pretty-printing database entries.
class Mixin(object):
  def __repr__(self):
    attr_dict = self.__dict__.copy()
    attr_dict.pop("_sa_instance_state", None)
    return self.pprint(**attr_dict)

  def pprint(self, **kw):
    return "<{name}: {kw}>".format(name=self.__class__.__name__, kw=kw)

class Vocab(Mixin, Base):
  '''
  Vocabulary-list object.
  '''
  __tablename__ = 'vocabs'

  def __repr__(self):
    return self.pprint(
      id = self.id,
      description = self.description,
    )

class Word(Mixin, Base):
  '''
  Word/definition object.
  '''
  __tablename__ = 'words'

  def __repr__(self):
    return self.pprint(
      id = self.id,
      word = self.word,
    )


# Helper functions to simplify using SQLALchemy to define sense-sense
# relationship types. This gets tricky, because...
#
# I model these relationships as a graph. Some parts of the graph need to be
# treated as undirected, and others parts need to be treated as directed.
#
# Because the "synonym" relation is symmetric (if A is a synonym of B, then B is
# a synonym of A), the graph representation of the relation is undirected.
#
# Similarly for the "antonym" relation.
#
# The graph representation of the "type-of" relation must be directed, because
# the relationship is not symmetric: if A is a type of B, then words having
# sense A also have sense B, but there may be words of sense B that do not have
# sense A. As a specific example, one sense of 'abdicate' is to give up power,
# which is a type of 'quit'; but one can 'quit' a position that has no power.
#
# Directed graphs are easier to model in SQL than undirected graphs, and both
# are easier to model than a graph with both directed subgraphs and undirected
# subgraphs. So I use some helper functions and methods to simplify things.

def sense_relationship(foreign_key_col, relation_kind):
  '''
  foreign_key_col: either 'l_sense_id' or 'r_sense_id'
  relation_kind: one of 'synonym', 'antonym', or 'type_of'

  This defines a SQLAlchemy join query that finds a sense's right or left
  related senses, where the relation is of kind 'synonym', 'antonym', or
  'type_of'.
  '''
  return relationship(
    'SenseRelation',
    foreign_keys = '[SenseRelation.{foreign_key_col}]'.format(
      foreign_key_col = foreign_key_col,
    ),
    primaryjoin = 'and_(Sense.id == SenseRelation.{foreign_key_col}, SenseRelation.relation_kind == "{relation_kind}")'.format(
      foreign_key_col = foreign_key_col,
      relation_kind = relation_kind,
    )
  )

def right_sense_relationship(relation_kind):
  '''
  relation_kind: one of 'synonym', 'antonym', or 'type_of'

  This defines a SQLAlchemy join query that finds a sense's right related
  senses, where the relation is of kind 'synonym', 'antonym', or 'type_of'.

  Note that 'l_sense_id' is used to find right-related senses. I'm not sure how
  that happened, but whatever, I'll look at fixing it sometime in the future.
  '''
  return sense_relationship(
    foreign_key_col = 'l_sense_id',
    relation_kind = relation_kind,
  )

def left_sense_relationship(relation_kind):
  '''
  relation_kind: one of 'synonym', 'antonym', or 'type_of'

  This defines a SQLAlchemy join query that finds a sense's left related senses,
  where the relation is of kind 'synonym', 'antonym', or 'type_of'.

  Note that 'r_sense_id' is used to find left-related senses. I'm not sure how
  that happened, but whatever, I'll look at fixing it sometime in the future.
  '''
  return sense_relationship(
    foreign_key_col = 'r_sense_id',
    relation_kind = relation_kind,
  )

def lr(l, r):
  '''
  l: a list of left-related sense associations.
  r: a list of right-related sense associations.

  This helper function does four things:
  - It extracts the left sense from each left association.
  - It extracts the right sense from each right association.
  - It combines the resulting left and right senses into one list.
  - It returns the combined list of senses.
  '''
  return [x.left for x in l] + [x.right for x in r]


class Sense(Mixin, Base):
  '''
  Word/definition sense object.

  A word's typically has lots of different definitions, each defining a 'sense'
  of a word. Synonyms, antonyms, specializations, and generalizations are
  related via these definition senses.
  '''
  __tablename__ = 'senses'

  # SQLAlchemy join queries used to find left/right synonyms/antonyms/type/type-of related senses.
  left_synonyms = left_sense_relationship(relation_kind = 'synonym')
  right_synonyms = right_sense_relationship(relation_kind = 'synonym')
  left_antonyms = left_sense_relationship(relation_kind = 'antonym')
  right_antonyms = right_sense_relationship(relation_kind = 'antonym')
  left_types_of = left_sense_relationship(relation_kind = 'type_of')
  right_types_of = right_sense_relationship(relation_kind = 'type_of')

  @property
  def synonyms(self):
    '''
    Returns synonyms senses.
    '''
    return lr(self.left_synonyms, self.right_synonyms)
  @property
  def antonyms(self):
    '''
    Returns antonyms senses.
    '''
    return lr(self.left_antonyms, self.right_antonyms)
  @property
  def types(self):
    '''
    Returns senses that are types of this sense.
    '''
    return [sr.left for sr in self.left_types_of]
  @property
  def type_of(self):
    '''
    Returns the sense of which this sense is a type.

    Ideally there's at most one of these, but I don't try to enforce this.
    '''
    return [sr.right for sr in self.right_types_of]

  def __repr__(self):
    return self.pprint(
      id = self.id,
      sense = self.sense,
    )


  def add_synonym(self, related_sense):
    '''
    Helper method to add related sense to the list of this sense's synonyms.
    '''
    if related_sense not in self.synonyms:
      return SenseRelation(
        left = self,
        right = related_sense,
        relation_kind = 'synonym',
      )

  def add_antonym(self, related_sense):
    '''
    Helper method to add related sense to the list of this sense's antonyms.
    '''
    if related_sense not in self.antonyms:
      return SenseRelation(
        left = self,
        right = related_sense,
        relation_kind = 'antonym',
      )

  def add_type_of(self, related_sense):
    '''
    Helper method to assert that this sense is a type of the related sense.
    '''
    if related_sense not in self.type_of:
      return SenseRelation(
        left = self,
        right = related_sense,
        relation_kind = 'type_of',
      )

  def add_type(self, related_sense):
    '''
    Helper method to add related sense as a type of this sense.
    '''
    if related_sense not in self.types:
      return SenseRelation(
        left = related_sense,
        right = self,
        relation_kind = 'type_of',
      )


class SenseRelation(Mixin, Base):
  '''
  Object encapsulating the kind of a sense-sense relationship.

  The relationship kind is one of 'synonym', 'antonym', or 'type-of'.
  '''
  __tablename__ = 'sense_relations'
  left = relationship(Sense, foreign_keys = "SenseRelation.l_sense_id", backref = 'right')
  right = relationship(Sense, foreign_keys = "SenseRelation.r_sense_id", backref = 'left')
  def __repr__(self):
    return self.pprint(
      kind = self.relation_kind,
      left = self.left,
      right = self.right,
    )


def get_or_create(session, model, **kwargs):
  '''
  Helper function to find or create instance of model, specified by keyword arguments.

  Based on Stack Overflow question "Does SQLAlchemy have an equivalent of
  Django's get_or_create?"
  - https://stackoverflow.com/questions/2546207/does-sqlalchemy-have-an-equivalent-of-djangos-get-or-create

  This version does not commit changes to the database.
  '''
  instance = session.query(model).filter_by(**kwargs).first()
  if instance:
    return instance
  else:
    instance = model(**kwargs)
    session.add(instance)
    return instance


# Here I attach to the database, create the tables, wire up the ORM.
db_url = 'sqlite:///vocab.sqlite'
# engine = create_engine(db_url, echo = True)
engine = create_engine(db_url, echo = False)
session = Session(engine)
metadata.create_all(engine)
Base.prepare(engine, reflect=True)

# A mock vocabulary list. Needs to be populated with words.
vocab_185604 = get_or_create(session, Vocab, id = 185604)
vocab_185604.description = '800 high frequency words GRE'

# A word that I'm going to put into the above vocabulary list.
antecedent = get_or_create(session, Word, word = 'antecedent')
antecedent.short_blurb = '''An antecedent is a thing that comes before something else. You might think rap music has no historical antecedent, but earlier forms of African-American spoken verse go back for centuries.'''
antecedent.long_blurb = '''In logic, mathematics, and grammar, the word antecedent (from Latin ante-, "before" + cedere, "to yield") has the meaning "the first part of a statement." More generally, it means "something that came before, and perhaps caused, something else." The word is also an adjective: a lawyer or judge might talk about the "antecedent events" leading up to someone committing a crime.'''
antecedent.frequency = 1648.06

vocab_185604.word_collection.append(antecedent)
session.commit()


sense_39652 = get_or_create(session, Sense,
  sense = 'a preceding occurrence or cause or event'
)
sense_39652.word_collection.append(antecedent)

related_sense_1 = get_or_create(session, Sense,
  sense = 'events that provide the generative force that is the origin of something'
)
session.commit()
sense_39652.add_type_of(related_sense_1)
related_sense_1.word_collection.append(get_or_create(session, Word, word = 'cause'))


sense_74130 = get_or_create(session, Sense,
  sense = 'anything that precedes something similar in time'
)
sense_74130.word_collection.append(antecedent)
sense_74130.word_collection.append(get_or_create(session, Word, word = 'forerunner'))

related_sense_2 = get_or_create(session, Sense,
  sense = 'a relation involving time'
)
session.commit()
sense_74130.add_type_of(related_sense_2)
related_sense_2.word_collection.append(get_or_create(session, Word, word = 'temporal relation'))


sense_52663 = get_or_create(session, Sense,
  sense = 'someone from whom you are descended (but usually more remote than a grandparent)'
)
sense_52663.word_collection.append(antecedent)
sense_52663.word_collection.append(get_or_create(session, Word, word = 'ancestor'))
sense_52663.word_collection.append(get_or_create(session, Word, word = 'ascendant'))
sense_52663.word_collection.append(get_or_create(session, Word, word = 'ascendent'))
sense_52663.word_collection.append(get_or_create(session, Word, word = 'root'))

related_sense_3 = get_or_create(session, Sense,
  sense = 'a person considered as descended from some ancestor or race'
)
session.commit()
sense_52663.add_antonym(related_sense_3)
related_sense_3.word_collection.append(get_or_create(session, Word, word = 'descendant'))
related_sense_3.word_collection.append(get_or_create(session, Word, word = 'descendent'))

related_sense_4 = get_or_create(session, Sense,
  sense = 'a woman ancestor'
)
session.commit()
sense_52663.add_type(related_sense_4)
related_sense_4.word_collection.append(get_or_create(session, Word, word = 'ancestress'))
related_sense_4.word_collection.append(get_or_create(session, Word, word = 'foremother'))

related_sense_5 = get_or_create(session, Sense,
  sense = 'a person from whom you are descended'
)
session.commit()
sense_52663.add_type(related_sense_5)
related_sense_5.word_collection.append(get_or_create(session, Word, word = 'forbear'))
related_sense_5.word_collection.append(get_or_create(session, Word, word = 'forebear'))

related_sense_6 = get_or_create(session, Sense,
  sense = 'the founder of a family'
)
session.commit()
sense_52663.add_type(related_sense_6)
related_sense_6.word_collection.append(get_or_create(session, Word, word = 'father'))
related_sense_6.word_collection.append(get_or_create(session, Word, word = 'forefather'))
related_sense_6.word_collection.append(get_or_create(session, Word, word = 'sire'))

related_sense_7 = get_or_create(session, Sense,
  sense = 'an ancestor in the direct line'
)
session.commit()
sense_52663.add_type(related_sense_7)
related_sense_7.word_collection.append(get_or_create(session, Word, word = 'primogenitor'))
related_sense_7.word_collection.append(get_or_create(session, Word, word = 'progenitor'))

related_sense_8 = get_or_create(session, Sense,
  sense = 'a natural father or mother'
)
session.commit()
sense_52663.add_type(related_sense_8)
related_sense_8.word_collection.append(get_or_create(session, Word, word = 'genitor'))

related_sense_9 = get_or_create(session, Sense,
  sense = 'a parent of your father or mother'
)
session.commit()
sense_52663.add_type(related_sense_9)
related_sense_9.word_collection.append(get_or_create(session, Word, word = 'grandparent'))

related_sense_10 = get_or_create(session, Sense,
  sense = 'a parent of your grandparent'
)
session.commit()
sense_52663.add_type(related_sense_10)
related_sense_10.word_collection.append(get_or_create(session, Word, word = 'great grandparent'))

related_sense_11 = get_or_create(session, Sense,
  sense = 'any of the early biblical characters regarded as fathers of the human race'
)
session.commit()
sense_52663.add_type(related_sense_11)
related_sense_11.word_collection.append(get_or_create(session, Word, word = 'patriarch'))

related_sense_12 = get_or_create(session, Sense,
  sense = 'a person related by blood or marriage'
)
session.commit()
sense_52663.add_type_of(related_sense_12)
related_sense_12.word_collection.append(get_or_create(session, Word, word = 'relation'))
related_sense_12.word_collection.append(get_or_create(session, Word, word = 'relative'))



sense_96527 = get_or_create(session, Sense,
  sense = 'preceding in time or order'
)
sense_96527.word_collection.append(antecedent)

related_sense_13 = get_or_create(session, Sense,
  sense = 'earlier in time'
)
session.commit()
sense_96527.add_synonym(related_sense_13)
related_sense_13.word_collection.append(get_or_create(session, Word, word = 'anterior'))
related_sense_13.word_collection.append(get_or_create(session, Word, word = 'prior'))

related_sense_14 = get_or_create(session, Sense,
  sense = 'in anticipation'
)
session.commit()
sense_96527.add_synonym(related_sense_14)
related_sense_14.word_collection.append(get_or_create(session, Word, word = 'anticipatory'))
related_sense_14.word_collection.append(get_or_create(session, Word, word = 'prevenient'))

related_sense_15 = get_or_create(session, Sense,
  sense = 'existing previously or before something'
)
session.commit()
sense_96527.add_synonym(related_sense_15)
related_sense_15.word_collection.append(get_or_create(session, Word, word = 'pre-existent'))
related_sense_15.word_collection.append(get_or_create(session, Word, word = 'pre-existing'))
related_sense_15.word_collection.append(get_or_create(session, Word, word = 'preexistent'))
related_sense_15.word_collection.append(get_or_create(session, Word, word = 'preexisting'))

related_sense_16 = get_or_create(session, Sense,
  sense = 'existing or coming before'
)
session.commit()
sense_96527.add_synonym(related_sense_16)
related_sense_16.word_collection.append(get_or_create(session, Word, word = 'preceding'))

related_sense_17 = get_or_create(session, Sense,
  sense = 'following in time or order'
)
session.commit()
sense_96527.add_antonym(related_sense_17)
related_sense_17.word_collection.append(get_or_create(session, Word, word = 'subsequent'))

related_sense_18 = get_or_create(session, Sense,
  sense = 'following or accompanying as a consequence'
)
session.commit()
sense_96527.add_antonym(related_sense_18)
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'accompanying'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'attendant'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'concomitant'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'consequent'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'ensuant'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'incidental'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'resultant'))
related_sense_18.word_collection.append(get_or_create(session, Word, word = 'sequent'))

related_sense_19 = get_or_create(session, Sense,
  sense = 'coming at a subsequent time or stage'
)
session.commit()
sense_96527.add_antonym(related_sense_19)
related_sense_19.word_collection.append(get_or_create(session, Word, word = 'later'))
related_sense_19.word_collection.append(get_or_create(session, Word, word = 'posterior'))
related_sense_19.word_collection.append(get_or_create(session, Word, word = 'ulterior'))

related_sense_20 = get_or_create(session, Sense,
  sense = 'coming after or following'
)
session.commit()
sense_96527.add_antonym(related_sense_20)
related_sense_20.word_collection.append(get_or_create(session, Word, word = 'succeeding'))


sense_35617 = get_or_create(session, Sense,
  sense = 'the referent of an anaphor; a phrase or clause that is referred to by an anaphoric pronoun'
)
sense_35617.word_collection.append(antecedent)

related_sense_21 = get_or_create(session, Sense,
  sense = 'something referred to; the object of a reference'
)
session.commit()
sense_35617.add_type_of(related_sense_21)
related_sense_21.word_collection.append(get_or_create(session, Word, word = 'referent'))


session.commit()

vocab_185604.word_collection
"""
[<Word: {'id': 1, 'word': 'antecedent'}>]
"""

antecedent.sense_collection
"""
[<Sense: {'id': 1, 'sense': 'a preceding occurrence or cause or event'}>,
 <Sense: {'id': 3, 'sense': 'anything that precedes something similar in time'}>,
 <Sense: {'id': 5, 'sense': 'someone from whom you are descended (but usually more remote than a grandparent)'}>,
 <Sense: {'id': 16, 'sense': 'preceding in time or order'}>,
 <Sense: {'id': 25, 'sense': 'the referent of an anaphor; a phrase or clause that is referred to by an anaphoric pronoun'}>]
"""

antecedent.vocab_collection
"""
[<Vocab: {'id': 185604, 'description': '800 high frequency words GRE'}>]
"""

# Should be empty.
sense_39652.types
sense_39652.synonyms
sense_39652.antonyms
"""
[]
"""
sense_39652.word_collection
"""
[<Word: {'id': 1, 'word': 'antecedent'}>]
"""
sense_39652.type_of
"""
[<Sense: {'id': 2, 'sense': 'events that provide the generative force that is the origin of something'}>]
"""
sense_39652.type_of[0].word_collection
"""
[<Word: {'id': 2, 'word': 'cause'}>]
"""

sense_74130.types
sense_74130.antonyms
sense_74130.synonyms
"""
[]
"""
sense_74130.word_collection
"""
[<Word: {'id': 1, 'word': 'antecedent'}>,
 <Word: {'id': 3, 'word': 'forerunner'}>]
"""
sense_74130.type_of
"""
[<Sense: {'id': 4, 'sense': 'a relation involving time'}>]
"""
sense_74130.type_of[0].word_collection
"""
[<Word: {'id': 4, 'word': 'temporal relation'}>]
"""

sense_52663.synonyms
"""
[]
"""
sense_52663.word_collection
"""
[<Word: {'id': 1, 'word': 'antecedent'}>,
 <Word: {'id': 5, 'word': 'ancestor'}>,
 <Word: {'id': 6, 'word': 'ascendant'}>,
 <Word: {'id': 7, 'word': 'ascendent'}>,
 <Word: {'id': 8, 'word': 'root'}>]
"""
sense_52663.antonyms
"""
[<Sense: {'id': 6, 'sense': 'a person considered as descended from some ancestor or race'}>]
"""
sense_52663.types
"""
[<Sense: {'id': 7, 'sense': 'a woman ancestor'}>,
 <Sense: {'id': 8, 'sense': 'a person from whom you are descended'}>,
 <Sense: {'id': 9, 'sense': 'the founder of a family'}>,
 <Sense: {'id': 10, 'sense': 'an ancestor in the direct line'}>,
 <Sense: {'id': 11, 'sense': 'a natural father or mother'}>,
 <Sense: {'id': 12, 'sense': 'a parent of your father or mother'}>,
 <Sense: {'id': 13, 'sense': 'a parent of your grandparent'}>,
 <Sense: {'id': 14, 'sense': 'any of the early biblical characters regarded as fathers of the human race'}>]
"""
sense_52663.types[7].word_collection
"""
[<Word: {'id': 23, 'word': 'patriarch'}>]
"""
sense_52663.type_of
"""
[<Sense: {'id': 15, 'sense': 'a person related by blood or marriage'}>]
"""

sense_96527.types
sense_96527.type_of
"""
[]
"""
sense_96527.word_collection
"""
[<Word: {'id': 1, 'word': 'antecedent'}>]
"""
sense_96527.synonyms
"""
[<Sense: {'id': 17, 'sense': 'earlier in time'}>,
 <Sense: {'id': 18, 'sense': 'in anticipation'}>,
 <Sense: {'id': 19, 'sense': 'existing previously or before something'}>,
 <Sense: {'id': 20, 'sense': 'existing or coming before'}>]
"""
sense_96527.antonyms
"""
[<Sense: {'id': 21, 'sense': 'following in time or order'}>,
 <Sense: {'id': 22, 'sense': 'following or accompanying as a consequence'}>,
 <Sense: {'id': 23, 'sense': 'coming at a subsequent time or stage'}>,
 <Sense: {'id': 24, 'sense': 'coming after or following'}>]
"""
sense_96527.antonyms[1].word_collection
"""
[<Word: {'id': 36, 'word': 'accompanying'}>,
 <Word: {'id': 37, 'word': 'attendant'}>,
 <Word: {'id': 38, 'word': 'concomitant'}>,
 <Word: {'id': 39, 'word': 'consequent'}>,
 <Word: {'id': 40, 'word': 'ensuant'}>,
 <Word: {'id': 41, 'word': 'incidental'}>,
 <Word: {'id': 42, 'word': 'resultant'}>,
 <Word: {'id': 43, 'word': 'sequent'}>]
"""

sense_35617.synonyms
sense_35617.antonyms
sense_35617.types
"""
[]
"""
sense_35617.word_collection
"""
[<Word: {'id': 1, 'word': 'antecedent'}>]
"""
sense_35617.type_of
"""
[<Sense: {'id': 26, 'sense': 'something referred to; the object of a reference'}>]
"""
sense_35617.type_of[0].word_collection
"""
[<Word: {'id': 48, 'word': 'referent'}>]
"""
```


##### 1228: Notes on scraper code.
