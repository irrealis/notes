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

```{python }
%pushd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
```

If you're reading this, skip to "Fourth pass" below. Only read the first three coding passes if you want to see how these ideas developed.


###### First pass.

```{python }
%rm vocab.sqlite

from sqlalchemy import Table, Column, Integer, Float, Numeric, Text, MetaData, ForeignKey, create_engine

from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session


db_url = 'sqlite:///vocab.sqlite'

metadata = MetaData()

Table('vocabs', metadata,
  Column('id', Integer, primary_key = True, autoincrement = False),
  Column('description', Text),
)

Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Float)
)

Table('vocab_words', metadata,
  Column('vocab_id', Integer, ForeignKey('vocabs.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

Table('senses', metadata,
  Column('id', Integer, primary_key = True),
  Column('sense', Text),
)

Table('sense_words', metadata,
  Column('sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

Table('sense_relation_types', metadata,
  Column('id', Integer, primary_key = True),
  Column('type', Text),
)

Table('related_senses', metadata,
  Column('l_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('r_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('relation_type', Integer, ForeignKey('sense_relation_types.id'))
)

engine = create_engine(db_url)
session = Session(engine)
metadata.create_all(engine)

base = automap_base()
base.prepare(engine, reflect=True)

Vocab = base.classes.vocabs
Word = base.classes.words
Sense = base.classes.senses
SenseRelationType = base.classes.sense_relation_types
SenseRelation = base.classes.related_senses

synonym = SenseRelationType(type = 'synonym')
antonym = SenseRelationType(type = 'antonym')
type_of = SenseRelationType(type = 'type_of')
types = SenseRelationType(type = 'types')
session.add_all((synonym, antonym, type_of, types,))

vocab_185604 = Vocab(id = 185604, description = '800 high frequency words GRE',)
abdicate = Word(
  word = 'abdicate',
  short_blurb = '''Sometimes someone in power might decide to give up that power and step down from his or her position. When they do that, they abdicate their authority, giving up all duties and perks of the job.''',
  long_blurb = '''The original meaning of the verb abdicate came from the combination of the Latin ab- "away" and dicare "proclaim." (Note that in the charming relationships between languages with common roots, the Spanish word for "he says" is dice, which comes directly from dicare.) The word came to refer to disowning one's children, and it wasn't until the 17th century that the first use of the word relating to giving up power or public office was recorded.''',
  frequency = 1648.06,
)
vocab_185604.words_collection.append(abdicate)

session.add(vocab_185604)

sense = Sense(
  sense = 'give up, such as power, as of monarchs and emperors, or duties and obligations',
)
sense.words_collection.append(abdicate)
renounce = Word(word = 'renounce')
sense.words_collection.append(renounce)
# dir(sense)

related_sense = Sense(
  sense = 'leave (a job, post, or position) voluntarily'
)
related_sense.words_collection.append(Word(word = 'give_up'))
related_sense.words_collection.append(renounce)
related_sense.words_collection.append(Word(word = 'resign'))
related_sense.words_collection.append(Word(word = 'vacate'))

session.add_all((sense, related_sense,))

sense_relation = SenseRelation()
# sense_relation.l_sense_id = sense.id
# sense_relation.r_sense_id = related_sense.id
# sense_relation.relation_type = type_of
# session.add(sense_relation)


session.commit()
abdicate.vocabs_collection[0].id
dir(sense_relation)
```


###### Second pass.

```{python }
%cd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
%rm vocab.sqlite

from sqlalchemy import Table, Column, Integer, Float, Numeric, Text, MetaData, ForeignKey, create_engine

from sqlalchemy.orm import Session, mapper, relationship


db_url = 'sqlite:///vocab.sqlite'

metadata = MetaData()

vocabs_table = Table('vocabs', metadata,
  Column('id', Integer, primary_key = True, autoincrement = False),
  Column('description', Text),
)

words_table = Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Float)
)

vocab_words_join_table = Table('vocab_words', metadata,
  Column('vocab_id', Integer, ForeignKey('vocabs.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

senses_table = Table('senses', metadata,
  Column('id', Integer, primary_key = True),
  Column('sense', Text),
)

sense_words_join_table = Table('sense_words', metadata,
  Column('sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

sense_relation_types_table = Table('sense_relation_types', metadata,
  Column('id', Integer, primary_key = True),
  Column('type', Text),
)

related_senses_join_table = Table('related_senses', metadata,
  Column('l_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('r_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('relation_type', Integer, ForeignKey('sense_relation_types.id'))
)

class Base(object):
  def __init__(self, **kw):
    self.__dict__.update(kw)
  def __repr__(self):
    return '<{} {}>'.format(type(self).__name__, self.__dict__)

class Vocab(Base):
  pass

class Word(Base):
  pass

class Sense(Base):
  pass

class SenseRelationType(Base):
  pass

class SenseRelation(Base):
  pass

# mapper(Vocab, vocabs_table)
mapper(Word, words_table)
mapper(Vocab, vocabs_table, properties = dict(
  words = relationship(
    Word,
    secondary = vocab_words_join_table,
    back_populates = 'vocabs'
  )
))

engine = create_engine(db_url)
session = Session(engine)
metadata.create_all(engine)
vocab_185604 = Vocab(id = 185604, description = '800 high frequency words GRE',)
# abdicate = Word(
#   word = 'abdicate',
#   short_blurb = '''Sometimes someone in power might decide to give up that power and step down from his or her position. When they do that, they abdicate their authority, giving up all duties and perks of the job.''',
#   long_blurb = '''The original meaning of the verb abdicate came from the combination of the Latin ab- "away" and dicare "proclaim." (Note that in the charming relationships between languages with common roots, the Spanish word for "he says" is dice, which comes directly from dicare.) The word came to refer to disowning one's children, and it wasn't until the 17th century that the first use of the word relating to giving up power or public office was recorded.''',
#   frequency = 1648.06,
# )

```


###### Third pass.

```{python }
%cd '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words'
%rm vocab.sqlite

from sqlalchemy import Table, Column, Integer, Float, Numeric, Text, MetaData, ForeignKey, create_engine

from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session, relationship


db_url = 'sqlite:///vocab.sqlite'

metadata = MetaData()

Table('vocabs', metadata,
  Column('id', Integer, primary_key = True, autoincrement = False),
  Column('description', Text),
)

Table('words', metadata,
  Column('id', Integer, primary_key = True),
  Column('word', Text),
  Column('short_blurb', Text),
  Column('long_blurb', Text),
  Column('frequency', Float)
)

Table('vocab_words', metadata,
  Column('vocab_id', Integer, ForeignKey('vocabs.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

Table('senses', metadata,
  Column('id', Integer, primary_key = True),
  Column('sense', Text),
)

Table('sense_words', metadata,
  Column('sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('word_id', Integer, ForeignKey('words.id'), primary_key = True),
)

Table('sense_relation_types', metadata,
  Column('id', Integer, primary_key = True),
  Column('kind', Text),
)

Table('related_senses', metadata,
  Column('l_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('r_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  Column('relation_type', Integer, ForeignKey('sense_relation_types.id')),
)

engine = create_engine(db_url, echo = True)
session = Session(engine)
metadata.create_all(engine)

Base = automap_base()

class Mixin(object):
  def __repr__(self):
    attr_dict = self.__dict__.copy()
    attr_dict.pop("_sa_instance_state", None)
    return self.pprint(**attr_dict)

  def pprint(self, **kw):
    return "<{name}: {kw}>".format(name=self.__class__.__name__, kw=kw)

# class SenseRelation(Base):
#   __tablename__ = 'related_senses'
#   l_sense_id = Column(Integer, ForeignKey('senses.id'), primary_key = True),
#   r_sense_id = Column(Integer, ForeignKey('senses.id'), primary_key = True),
#   relation_type = Column(Integer, ForeignKey('sense_relation_types.id')),
#   left = relationship(
#     "Sense",
#     primaryjoin = "Sense.id == SenseRelation.l_sense_id",
#     backref = "left_senses",
#   )
#   right = relationship(
#     "Sense",
#     primaryjoin = "Sense.id == SenseRelation.r_sense_id",
#     backref = "right_senses",
#   )
#

class Vocab(Mixin, Base):
  __tablename__ = 'vocabs'

  def __repr__(self):
    return self.pprint(
      id = self.id,
      description = self.description,
    )

class Word(Mixin, Base):
  __tablename__ = 'words'

  def __repr__(self):
    return self.pprint(
      id = self.id,
      word = self.word,
    )


def sense_relationship(foreign_key_col, relation_type):
  return relationship(
    'SenseRelation',
    foreign_keys = '[SenseRelation.{foreign_key_col}]'.format(
      foreign_key_col = foreign_key_col,
    ),
    primaryjoin = 'and_(Sense.id == SenseRelation.{foreign_key_col}, SenseRelation.relation_type == {relation_type})'.format(
      foreign_key_col = foreign_key_col,
      relation_type = relation_type,
    )
  )

def right_sense_relationship(relation_type):
  return sense_relationship(
    foreign_key_col = 'l_sense_id',
    relation_type = relation_type,
  )

def left_sense_relationship(relation_type):
  return sense_relationship(
    foreign_key_col = 'r_sense_id',
    relation_type = relation_type,
  )

def lr(l, r):
  return [x.left for x in l] + [x.right for x in r]

class Sense(Mixin, Base):
  __tablename__ = 'senses'

  left_synonyms = left_sense_relationship(relation_type = 1)
  right_synonyms = right_sense_relationship(relation_type = 1)
  left_antonyms = left_sense_relationship(relation_type = 2)
  right_antonyms = right_sense_relationship(relation_type = 2)
  left_type_relation = left_sense_relationship(relation_type = 3)
  right_type_relation = right_sense_relationship(relation_type = 3)

  @property
  def synonyms(self): return lr(self.left_synonyms, self.right_synonyms)
  @property
  def antonyms(self): return lr(self.left_antonyms, self.right_antonyms)
  @property
  def types(self): return [sr.left for sr in self.left_type_relation]
  @property
  def type_of(self): return [sr.right for sr in self.right_type_relation]

  def create_synonym(self, sense):
    if sense not in synonyms:
      sense_relation = SenseRelation(
        left = sense,
        right = related_sense,
        kind = type_relation,
      )

  def __repr__(self):
    return self.pprint(
      id = self.id,
      sense = self.sense,
    )


class SenseRelationType(Mixin, Base):
  __tablename__ = 'sense_relation_types'

class SenseRelation(Mixin, Base):
  __tablename__ = 'related_senses'
  # Column('l_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  # Column('r_sense_id', Integer, ForeignKey('senses.id'), primary_key = True),
  # left = relationship(Sense, foreign_keys = [l_sense_id])
  left = relationship(Sense, foreign_keys = "SenseRelation.l_sense_id", backref = 'right')
  right = relationship(Sense, foreign_keys = "SenseRelation.r_sense_id", backref = 'left')
  kind = relationship(SenseRelationType, foreign_keys = "SenseRelation.relation_type")
  def __repr__(self):
    return self.pprint(
      kind = self.kind.kind,
      left = self.left,
      right = self.right,
    )

Base.prepare(engine, reflect=True)

# Vocab = Base.classes.vocabs
# Word = Base.classes.words
# Sense = Base.classes.senses
# SenseRelationType = Base.classes.sense_relation_types
# SenseRelation = Base.classes.related_senses


# Vocab.__repr__ = Word.__repr__ = Sense.__repr__ = SenseRelationType.__repr__ = SenseRelation.__repr__ = my_repr

synonym = SenseRelationType(kind = 'synonym')
antonym = SenseRelationType(kind = 'antonym')
type_relation = SenseRelationType(kind = 'type_relation')
session.add_all((synonym, antonym, type_relation,))

vocab_185604 = Vocab(id = 185604, description = '800 high frequency words GRE',)
vocab_185604.__table__.columns.keys()

abdicate = Word(
  word = 'abdicate',
  short_blurb = '''Sometimes someone in power might decide to give up that power and step down from his or her position. When they do that, they abdicate their authority, giving up all duties and perks of the job.''',
  long_blurb = '''The original meaning of the verb abdicate came from the combination of the Latin ab- "away" and dicare "proclaim." (Note that in the charming relationships between languages with common roots, the Spanish word for "he says" is dice, which comes directly from dicare.) The word came to refer to disowning one's children, and it wasn't until the 17th century that the first use of the word relating to giving up power or public office was recorded.''',
  frequency = 1648.06,
)
vocab_185604.word_collection.append(abdicate)

session.add(vocab_185604)

abdicate

sense = Sense(
  sense = 'give up, such as power, as of monarchs and emperors, or duties and obligations',
)

sense.sense
dir(sense.__table__)
sense.__table__.columns.keys()

dir(sense)
sense.word_collection.append(abdicate)
renounce = Word(word = 'renounce')
sense.word_collection.append(renounce)

related_sense = Sense(
  sense = 'leave (a job, post, or position) voluntarily'
)
related_sense.word_collection.append(Word(word = 'give_up'))
related_sense.word_collection.append(renounce)
related_sense.word_collection.append(Word(word = 'resign'))
related_sense.word_collection.append(Word(word = 'vacate'))

dir(related_sense)
related_sense.left
related_sense.right
sense.left
sense.right
sense.left_type_relation
sense.right_type_relation
sense.type_of
sense.types
related_sense.type_of
related_sense.types
# related_sense.related_sense_collection

session.add_all((sense, related_sense,))
session.commit()

sense_relation = SenseRelation(
  # l_sense_id = sense.id,
  # r_sense_id = related_sense.id,
  # relation_type = type_of.id,
  left = sense,
  right = related_sense,
  kind = type_relation,
)
dir(sense_relation)
sense_relation.sense

session.add(sense_relation)

session.commit()

abdicate.vocab_collection[0].id

```


###### Fourth pass.

This version works as I'd hoped.
- The table definitions are separate from the rest of the code, which will allow me to use Alembic for database schema migrations.
- The ORM definitions are separate from the table definitions and the rest of the code, which allows me to move them into a separate Python module.
- Sense relationships are managed in the Sense class.
  - Three kinds of sense relationships are managed and can be queried:
    - Synonyms
    - Antonyms
    - Types/type-of. In this relationship, one sense is a specialized type of another more general sense.
- Unfortunately the Sense and SenseRelation classes are tightly coupled by mutual dependence. However, the latter class is very simple, so I hope the coupling won't cause problems.

I was able to use this code verbatim in Alembic and Scrapy, and later added  functionality.


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
    Returns synonyms senses.
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
    if related_sense not in self.antonym:
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
        right = related_sense,
        left = self,
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


# Here I attach to the database, create the tables, wire up the ORM.
db_url = 'sqlite:///vocab.sqlite'
engine = create_engine(db_url, echo = True)
session = Session(engine)
metadata.create_all(engine)
Base.prepare(engine, reflect=True)

# A mock vocabulary list. Needs to be populated with words.
vocab_185604 = Vocab(id = 185604, description = '800 high frequency words GRE',)

# A word that I'm going to put into the above vocabulary list.
abdicate = Word(
  word = 'abdicate',
  short_blurb = '''Sometimes someone in power might decide to give up that power and step down from his or her position. When they do that, they abdicate their authority, giving up all duties and perks of the job.''',
  long_blurb = '''The original meaning of the verb abdicate came from the combination of the Latin ab- "away" and dicare "proclaim." (Note that in the charming relationships between languages with common roots, the Spanish word for "he says" is dice, which comes directly from dicare.) The word came to refer to disowning one's children, and it wasn't until the 17th century that the first use of the word relating to giving up power or public office was recorded.''',
  frequency = 1648.06,
)
vocab_185604.word_collection.append(abdicate)

session.add(vocab_185604)

# A definition of a sense of 'abdicate'. This is also a sense of the synonym 'renounce'.
sense = Sense(
  sense = 'give up, such as power, as of monarchs and emperors, or duties and obligations',
)
sense.word_collection.append(abdicate)

renounce = Word(word = 'renounce')
sense.word_collection.append(renounce)

# A related and more general sense, of which 'abdicate' is a specific type.
related_sense = Sense(
  sense = 'leave (a job, post, or position) voluntarily'
)
# The related sense is also a sense of synonyms 'give up', 'resign', and 'vacate'.
related_sense.word_collection.append(Word(word = 'give_up'))
related_sense.word_collection.append(renounce)
related_sense.word_collection.append(Word(word = 'resign'))
related_sense.word_collection.append(Word(word = 'vacate'))

session.add_all((sense, related_sense,))
session.commit()

# Here I assert that 'give up, such as power, as of monarchs and emperors, or duties and obligations' is a type of 'leave (a job, post, or position) voluntarily'.
sense_relation = sense.add_type_of(related_sense)
session.commit()

# 'sense' is a type of 'related_sense', so:
# - 'sense' should have no types of its own defined.
sense.types
# - 'related_sense' should not be defined as the type of anything else.
related_sense.type_of
# - 'sense' should be a type of 'related_sense'.
sense.type_of
# - 'related_sense' should have 'sense' as one of its types.
related_sense.types
```



##### 1403: Done setting up db models, for now. Break.

##### 1429: Resume. Setting up database in spider.


- Wkpt: _/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words_
- Setup Alembic:
  ```{bash evaluate = False}
  $ pip3 install alembic
  $ alembic init alembic
    Creating directory /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic ... done
    Creating directory /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic/versions ... done
    Generating /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic.ini ... done
    Generating /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic/env.py ... done
    Generating /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic/README ... done
    Generating /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic/script.py.mako ... done
    Please edit configuration/connection/logging settings in '/mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic.ini'
    before proceeding.
  ```

- Create initial tables:
  ```{bash evaluate = False}
  $ alembic revision -m "Create initial tables"
    Generating /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic/versions/ab13826fb264_create_initial_tables.py ... done
  ```

- Initial migration script:
  ```{python evaluate = False}
  """Create initial tables

  Revision ID: ab13826fb264
  Revises:
  Create Date: 2018-12-18 14:42:44.586982

  """
  from alembic import op
  import sqlalchemy as sa

  import enum


  # revision identifiers, used by Alembic.
  revision = 'ab13826fb264'
  down_revision = None
  branch_labels = None
  depends_on = None


  def upgrade():
  	op.create_table('vocabs',
  	  sa.Column('id', sa.Integer, primary_key = True, autoincrement = False),
  	  sa.Column('description', sa.Text),
  	)

  	op.create_table('words',
  	  sa.Column('id', sa.Integer, primary_key = True),
  	  sa.Column('word', sa.Text),
  	  sa.Column('short_blurb', sa.Text),
  	  sa.Column('long_blurb', sa.Text),
  	  sa.Column('frequency', sa.Float)
  	)

  	op.create_table('vocab_words',
  	  sa.Column('vocab_id', sa.Integer, sa.ForeignKey('vocabs.id'), primary_key = True),
  	  sa.Column('word_id', sa.Integer, sa.ForeignKey('words.id'), primary_key = True),
  	)

  	op.create_table('senses',
  	  sa.Column('id', sa.Integer, primary_key = True),
  	  sa.Column('sense', sa.Text),
  	)

  	op.create_table('sense_words',
  	  sa.Column('sense_id', sa.Integer, sa.ForeignKey('senses.id'), primary_key = True),
  	  sa.Column('word_id', sa.Integer, sa.ForeignKey('words.id'), primary_key = True),
  	)

  	class SenseRelationKind(enum.Enum):
  	  synonym = 1
  	  antonym = 2
  	  type_of = 3

  	op.create_table('sense_relations',
  	  sa.Column('l_sense_id', sa.Integer, sa.ForeignKey('senses.id'), primary_key = True),
  	  sa.Column('r_sense_id', sa.Integer, sa.ForeignKey('senses.id'), primary_key = True),
  	  sa.Column('relation_kind', sa.Enum(SenseRelationKind)),
  	)


  def downgrade():
  	op.drop_table('vocabs')
  	op.drop_table('words')
  	op.drop_table('vocab_words')
  	op.drop_table('senses')
  	op.drop_table('sense_words')
  	op.drop_table('sense_relations')
  ```

- Initial migration:
  ```{bash evaluate = False}
  $ alembic upgrade head
  INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
  INFO  [alembic.runtime.migration] Running upgrade  -> ab13826fb264, Create initial tables
  ```

- Add task-complete columns:
  ```{bash evaluate = False}
  $ alembic revision -m "Add task-complete columns"
    Generating /mnt/Work/Repos/irrealis/flashcards/spiders/gre_words/alembic/versions/f51adb7c4d0d_add_task_complete_columns.py
    ... done
  ```

- Revision script for new columns:
  ```{python evaluate = False}
  """Add task-complete columns

  Revision ID: f51adb7c4d0d
  Revises: ab13826fb264
  Create Date: 2018-12-18 14:53:56.340697

  """
  from alembic import op
  import sqlalchemy as sa


  # revision identifiers, used by Alembic.
  revision = 'f51adb7c4d0d'
  down_revision = 'ab13826fb264'
  branch_labels = None
  depends_on = None


  def upgrade():
    op.add_column('vocabs', sa.Column('is_task_complete', sa.Text))
    op.add_column('words', sa.Column('is_task_complete', sa.Text))


  def downgrade():
    op.drop_column('vocabs', 'is_task_complete')
    op.drop_column('words', 'is_task_complete')
  ```

- Migration to add task-complete columns:
  ```{bash evaluate = False}
  $ alembic upgrade head
  INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
  INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
  INFO  [alembic.runtime.migration] Running upgrade ab13826fb264 -> f51adb7c4d0d, Add task-complete columns
  ```


##### 1647: Got scrape of 800- and 5000-word lists. Break.

Next:
- Cleanup/annotate notes.
- Cleanup/annotate code.
- Setup scheduling system.
