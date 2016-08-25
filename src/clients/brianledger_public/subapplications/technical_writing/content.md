# The Algebra and Geometry of Regular Expressions

Often, there is great insight to be found in meditating on subjects which, on their face, may seem completely mundane.
This forms the motivation of the following essay on regular expressions.  Regular expressions, which seem at first to 
conceal very little, turn out to arise from a small algebraic signature, which comes to encompass a broad class of graphs.

## Starting from Scratch

To proceed carefully into this subject, we will start at a primitive notion of sets. Sets have the simplest algebraic
signature, so from that point, we can incrementally build the full description of the class of regular expressions.

### An Abstract Set

An abstract set is a collection of __elements__, each of which possess no internal structure, and all of which, when
taken together, have no special (external) structure.

Abstract sets, by themselves, are not very useful. Their usefulness arises in the construction of __concrete sets__ by
a process called mapping.

A __mapping__ from an abstract set `S` to another abstract set `S'` is a function that takes each element in `S`
to a corresponding element in `S'`. We see that a mapping is an instance of a __surjection__.

Given a mapping, `m: S -> S'`, and an element, `x` in `S`, which maps to `y` in `S'`, we say that 
"`y` is the value of `f` at `x`," or

	y = f(x)

Given a surjection, `mapping`, of an abstract set, `A`, the set, `S`, to which it is mapped is called a concrete set. 
A concrete set has more  structure than an abstract set, due to the fact that it was produced with a surjection. 
This structure is completely defined by the surjection, so we can fully describe the class of concrete sets with the 
signature

	S = (A, mapping)

In fact, this extra information allows us to construct a notion of __equivalence__, which is not available in abstract
sets. Canonically, we say that, for all `m(a)` and `m(a')` in `S`, `m(a) == m(a')` if and only if for all `m'` and `m''` 
from  `S` to `S'`, `m'(m(a)) == m''(m(a')` implies `m'(x) == m''(x)` for all `x` in `S`).

Because the addition of a surjection to our signature grants us a notion of equality, we typically refer to `S` by

	S = (A, eq)

where, `eq` references the equality function that arises from the given surjection. Most often, however, we completely 
dispense with this construction, letting `S` refer to a concrete set, without any further explanation.


### Sets With Additional Structure

We have progressed from abstract, to concrete sets. These form the basis of modern algebra. Now we will discuss some
"sets with additional structure" that lead us closer to the class of regular expressions.

#### Magmas

The first of such sets is called a __magma__, or associative algebra. The full signature of a magma, `Magma` is

	Magma = (A, eq, combine)

where `combine: A -> A -> A` takes two elements of `A` as arguments, and returns a third element, also in `A`.

The `combine` function is called an __operator__ of `A`.  An operator is guaranteed to return a result in `A` so long as
its arguments are also in `A`. Generally functions satisfying this constraint are said to be "closed over `A`".

Note that the signature of a Magma contains, as a part of it, the signature of a concrete set. In fact, it is more 
common to write

	Magma = (ConcreteSet, combine).

or simply
	
	M = (S, *)

by shortening terms, and using multiplication to represent `combine`. This makes it easy to see, a Magma is simply
a Concrete Set, equipped with a binary operation.

#### Semigroups

Along these same lines, we can construct Semigroups (and later, Monoids). A Semigroup is a Magma with a guarantee of
__associativity__:

	Semigroup = (Magma, associativity) = (A, eq, combine, associativity)

`associativity` is a guarantee on the `combine` operator that:

	combine(a, combine(b, c)) == combine(combine(a, b), c)

will hold for all such `a`, `b`, and `c` in `A`.


#### Monoids

A Monoid is a Semigroup with an __identity__.

	Monoid = (Semigroup, identity) = (A, eq, combine, associativity, identity)

The identity is another guarantee on the `combine` operator, this time saying:

	combine(id, x) = combine(x, id) = x

will hold for all such `x` in `A`. Because the identity works on both sides of the combine operation, it is sometimes
called a __two sided identity__.


## Strings as Monoids

You may ask, "What is a monoid?" I feel that this question conceals the correct answer. One should ask, 
"What may be a monoid?" to which the answer is, "Many things may be a monoid."

Take as an example, the class of Strings. Strings are sequences of glyphs. They show up as primitives in all major 
programming languages.

Unlike Monoids, Strings have a variety of functions (slicing, interleaving, prefixing, etc). A string has many, many other
operations as well, that we haven't even bothered to call into context. Therefore, to say that a String is a Monoid is 
too ambiguous. The claimant must say through what operation a String becomes an instance of a Monoid.

One way in which a String is a Monoid is through the operation of **concatenation**.  This operation is associative, and
its identity is the empty string.  Therefore, a String is a Monoid under concatenation.

Another example of a Monoid is the (concrete) set of Natural Numbers under multiplication.  This is so because
multiplication is associative, and the multiplicative identity, 1, is in the set of Natural Numbers.


## Commutative Monoids




## Combining Operators

Thus far, we have proceeded as Mathematicians, carefully, step-by-step, towards our goal. Now, let us proceed like
Computer Scientists! Take it to the limit!

Let's have two operators! After all, the Positive Integers get `addition` and `multiplication`, and those play pretty
well together!

Actually, the Positive Integers under `addition` and `multiplication` form what is called a __Semiring__.  

We'll describe the Semiring, using an extended format for the algebraic signature:

 * `S`: a (concrete) Set
 * `(+, associativity, identity)`: first associative operator on S (with identity in S)
 * `(*, associativity', identity')`: second associative operator on S (with identity' in S)
 * `distributivity`
 
`distributivity` refers to the distributive property of multiplication over addition, i.e.

	a * (b + c) = (a * b) + (a * c) and 
	
	(a + b) * c = (a * c) + (b * c)

One can prove that a Semiring is a Monoid under the addition operator.  One can also prove that a Semiring is a 
Commutative Monoid under the multiplication operator. That is why it is too ambiguous to say simply "A Semiring is a Monoid."

This is the first case we've seen of a algebraic object with two operators. By having the operators share the same
underlying Set, and by establishing the distributive property, we are now at the stage of providing relationships between
functions of a given set.

Semiring is the diminutive name of this class, because Semirings lack a few axioms that allow the formation of a Ring.
Establishing the definition of a Ring is an important milestone, but beside our purpose, which is to discuss Regular
Expressions. Note that Integers, under addition and multiplication, form a Ring.


## Kleene Algebra

We've progressed this far in our development by mapping our way into ever-larger algebras. The ultimate purpose of this
method is to introduce the signature of the __Kleene Algebra__, which is a suitable target for the instantiation of 
Regular Expressions!

We need a few more tools to finish this job though.


#### Idempotence

Kleene Algebra extends the signature of the Semiring with further guarantees and an additional operator. One of the new
guarantees, on the addition-like operator, make the Kleene Algebra unlike the Positive Integers.

The guarantee is called `idempotence`, and to be more precise, idempotence of addition.  Idempotence entails

	x + x = x

for all `x` in `S`.

This is unlike addition over the Positive Integers. To say integer addition is idempotent would be tantamount to saying

	2 + 2 = 2
	
Nevertheless, in order for an object to be an instance of a Kleene Algebra, the addition operator must be idempotent, so
we'll have to find some new examples.


#### An Infinite Limit

If I can be prosaic for a moment...

Let us try to represent all of the positive powers of some element `a` in `S`. We could write something like

	1 + a + aa + aaa + aaaa + ...

However, we really don't want to use the ellipsis. At the same time it's apparent, from our lack of tooling, that
we cannot reduce this term to a finite form. Lastly, the `a` in this term should be abstract.

What's more, we're not just interested in the term of `a`'s! The `a` is supposed to be abstract, so that we can
replace it later to get another term, like

	1 + x + xx + xxx + xxxx + ...

or 

	1 + u + uu + uuu + uuuu + ...

if you're getting my drift. We want something that is parameterized in the repeated variable.

Let's look at the mapping of these types of sequences.  For all variables in the abstract set A, we have
an infinite repeating sequence with a recognizable structure. The sequences are distinguishable by determining from
the terms, the original variables. Therefore, there is an isomorphism between the abstract set, A, and the concrete 
set of terms. This isomorphism induces an equality. Therefore, we have a concrete set of sequences.

We want to make sense of this geometrically. It is suitable to think of the sequences as lines that are approaching
a horizon. As you draw the sequence out further and further, your writing draws closer to the horizon. The points
which you can reach with a finite amount of work correspond to incompletions of the sequence. They are not in the
set of sequences, as analogously, the points on the plane do not set upon the horizon.

So, if we conclude that the points on the plane and the points at our horizon are distinct, so do we also trivially
conclude that the set of incompletions of our sequencse, and the set of complete sequences, are distinct. The
incomplete sequences correspond to the plane, and the complete sequences correspond to the horizon.

If we were to take this analogy to sets, we can imagine the incomplete sequences as being an open set, in the set of
these particular sequences. In this light, the complete sequences form the set that "closes" the open set, in the sense
that their union is the full set of sequences. Nothing else can come in.

Because of this action, the index into this set of complete sequences is sometimes called the __closure operator__.

#### The Signature of a Kleene Algebra

 * `S`: Set
 * `(addition, associativity, identity, idempotence)`: first associative operator on S (with identity in S)
 * `(multiplication, associativity', identity')`: second associative operator on S (with identity' in S)
 * `closure`: a unary operator
 * `distributivity`: multiplication distributes over addition.
 

# A Pragmatic Look at Regular Expressions

One of the common uses of regular expressions is to match patterns found in text. Examples of text can be varied,
but all of them can be seen as part of the same class of structures, known as strings.

The word "string" is a colloquialism. A string is a sequence of elements, called __symbols__, taken from an underlying set,
called an __alphabet__.

This change of names distinguishes the  to show that we've gone from a simpler notion of sets, to a more complicated one. An
alphabet is, in fact, a set, with the additional operation of __concatenation__, which we use to construct strings.


## Textbook Regular Expressions

Regular expressions start with a set of characters, called the alphabet. For simplicity's sake, let's say our alphabet consists of the lowercase letters, from 'a' to 'z'.

**example**

`a` denotes the regular expression that only matches "a".

We can combine letters from the alphabet to form longer patterns.

**example**

`foo` only matches the word "foo".

Regular expressions also have a "repeat" symbol, which matches any number of iterations of the prior letter. By and large, all implementations of regular expressions use the asterisk to denote repetition.

**example**

`a*` matches "", "a", "aa", "aaa", and so on...

`hello*` matches "hell", "hello", "helloo", "hellooo", and so on...

`byee*` matches "bye", "byee", "byeee", "byeeee", and so on...

To designate a sequence for repetition, we "group" the sequence between opening and closing parentheses.

**example**

`(ab)*` matches "", "ab", "abab", "ababab", and so on...

`(ab)*(cd)*` matches "", "ab", "cd", "abcd", "abab", "cdcd", and so on...

Regular expressions also have a "alternative" symbol, which matches the pattern prior to, or following, the symbol itself.  By and large, all implementations of regular expressions use the vertical pipe to denote alternatives.

**example**

`foo|bar` matches either "foo" or "bar".

`foo|bar|baz` matches either "foo" or "bar" or "baz".

`((ab)|(cd))*` matches "", "ab", "cd", "abcd", "abab", "cdcd", and so on...

We typically denote choices between individual characters by enclosing them in square brackets.

**example**

`h[iaou]t` matches "hit", "hat", "hot", and "hut".


The essential parts of a regular expression are,
 a) an alphabet,
 b) a symbol for repetition, and
 c) a symbol for alternatives.

Regular expression libraries usually offer many more symbols than this.

**example**

`.*` matches any sequence of letters

`a+` matches "a", "aa", "aaa", and so on...

`a{3,5}` matches "aaa", "aaaa", and "aaaaa"


This is for convenience, when constructing more complex expressions.  All regular expressions can be constructed from the alphabet, using repetition and alternatives.


## Regular Expressions in Javascript

In Javascript we denote regular expressions by enclosing them in front-slashes.

**example**

`/foo|bar/` matches either "foo" or "bar", anywhere in a sequence of characters.

### Escape Characters

In Javascript, the alphabet is ASCII. This is useful, as we are typically trying to match ASCII strings.  However, this complicates our textbook example, because all of our special symbols are in ASCII.

To solve this, we designate a special "escape" character. Preceding any special character with the backslash replaces the special character with its ASCII equivalent.

**example**

`/brianledger\.net\/index\.html/` matches "brianledger.net/index.html", anywhere in a sequence of characters.

### Input Boundaries

You may have noticed that Javascript regular expressions match anywhere in a sequence. This is unlike our textbook examples, which only matched entire sequences.

We can use the caret and dollar-sign to denote the beginning and ending of input, respectively.

**example**

`/^abc/` matches "abc", "abcd", "abcde", "abcxyz", and etc.

`/xyz$/` matches "xyz", "wxyz", "vwxyz", "abcxyz", and etc.

`/^abcxyz$/` matches only "abcxyz"



## Appendix

### Embedding regular expressions in strings.