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

###### Enumeration:

Difficulties recorded in annotations:
- RoA mtl 7.0: Rewrite the following general form by _completing the square:_
  - Issue: Badly memorized. I tend to drop an $a$ in the first denominator.
- RoA mtl 9: Define _irreducible_.
  - Issue: I should say _having no real roots_, but often instead say _having no **rational** roots_, mixing up _real_ and _rational_. I mean the correct things, but say the wrong thing.
- RoA problem 007: Expand and simplify:
  - Issue: I tend to not perform all multiplications in $4(x^2-x+2)$; the correct result is $4x^2 - 4x + 8$, but I often leave the trailing constant as 2 instead of 8.'
- RoA problem 015: Expand and simplify:
  - Issue: I should write $-3x+2x=-x$, but for some reason have repeatedly
    written $-2x$ on the right hand side. Usually when I'm tired.
  - Fixes: short of not doing math when tired, double check my work.
- RoA problem 035: Factor the expression:
  - Issue: I could factor out $9$ here, although this requirement may be inconsistent in this text. The rule seems to be "factor out constants unless doing so introduces noninteger factors".
- RoA problem 037: Factor the expression:
  - Issue: $\frac{18}{12}=\frac{3}{2}$, not 3.
- RoA problem 059: Complete the square:
  - Issue: I should write $(2x+1)^2 - 3$, but often leave it as $4(x+\frac{1}{2})^2 - 3$, forgetting to remove the internal fraction. I don't think this is a big deal, but it would be better to follow the simplified convention.
- RoA problem 062: Solve the equation:
  - Issue: Need to pay better attention to instructions; I should _solve_, not _factor_, e.g., I should answer $4, -2$ instead of $(x-4)(x+2)$.
- RoA problem 065: Solve the equation:
  - Note: completing the square is probably a quicker way to factor, whereas the quadratic formula is a quicker way to solve.
- RoA problem 071: Is the following quadratic irreducible?
  - Issue: when $4ac$ is positive, the quadratic is reducible. I sometimes mix up this rule.
  - Thoughts: There’s a trick here for quickly analyzing the discriminant: if $ac$ is negative then the discriminant is positive, so the quadratic is reducible.'
- RoA problem 076: Use the Binomial Theorem to expand the expression:
  - To-do:
    - Memorize binomial coefficients for $0 \le n,k \le 20$.
    - Would probably be worthwhile to practice reverse-engineering the question from the answer.
- RoA problem 078: Simplify the radicals:
  - Issue: must copy the negative sign, often forget.
- RoA problem 079: Simplify the radicals:
  - Issue: absolute values when handling even roots of even powers:

    Why $2|x|$ (as opposed to $2x$ or $|2x|?

    $\sqrt{2^2}$ is simply $2$, as is $\sqrt{(-2)}^2.

    But we don’t know the sign of $x$. If $x < 0$ then $\sqrt{x^2} = -x$, whereas if $0 \le x$ then $\sqrt{x^2} = x$. Similarly for $\sqrt[n]{x^n}$.

    This is why $\sqrt{2^2 x^2} = 2|x|$.
- RoA problem 081: Simplify the radicals:
  - Issue: absolute values when handling even roots of even powers:

    The question here would be: why is $\sqrt{b^3}$ equal to $b\sqrt{b}$ instead of $|b|\sqrt{b}$?

    Because $|b|=b$ implicitly, both are true, but the latter is superfluous. This is because if $b < 0$ then $\sqrt{b^3}$ is undefined (if we restrict to $\mathbb{R}$), so $b$ must be nonnegative.
- RoA problem 090: Use the Laws of Exponents to rewrite and simplify the expression:
  - Issues:
    - In this problem, I tend to confuse $2^5$ and $3^5$.
- RoA problem 093: Use the Laws of Exponents to rewrite and simplify the expression:
  - Issues:
    - The order of operations is important here. $x^2$ discards the sign of $x$, hence $(x^2)^{3/2} = |x|^3$, whereas I tend to equate $(x^2)^{3/2} = x^{\frac{2\times 3}{2}} = x^3$.

    The order of operations therefore has higher precedence than rules of simplification. I tend to forget this fact.
- RoA problem 095: Use the Laws of Exponents to rewrite and simplify the expression:
  - Issue/question: this is tricky. The domain of $\sqrt[5]{x}$ is all real numbers, but the sixth power drops the sign. So, I believe, $y^{6/5}=|y|^{6/5}$, and therefore the absolute value operation is superfluous and by convention is removed.
- RoA problem 100: Use the Laws of Exponents to rewrite and simplify the expression:
  - Issue: I should have added the exponents; instead I multiplied.
- RoA problem 101: Rationalize the expression:
  - Issue: I had trouble with the meaning of "rationalize the expression", which I resolved to mean "rationalize the part that isn''t rational (even if the rational part becomes irrational)".
- RoA problem 102: Rationalize the expression:
  - Possible issue: I tend to leave to denominator in the unsimplified form $\sqrt{x}(1+\sqrt{x})$ instead of $\sqrt{x}+x$. Both answers are equivalent, so this is perhaps a matter of convention, and therefore I’ll consider my answer incorrect. But it’s a minor point.
- RoA problem 103: Rationalize the expression:
  - Issue: I forgot how to factor $a^3 - b^3$; I should have written
    $$
    x^3 - 4^3 = (x - 4)(x^2 + 4x + 16),
    $$
    but instead dropped an exponent and wrote
    $$
    x^3 - 4^3 = (x - 4)(x + 4x + 16).
    $$
- CCAC 00.A (Algebra) 04b: Factor.
  - Issue: Directions are to _factor_. When using quadratic formula, I tend to try to _solve_ instead.
- CCAC 00.A (Algebra) 04e: Factor.
  - Note: the domain of this expression is the positive reals, since $x^{-1/2}=\frac{1}{\sqrt{x}}$, in which $\sqrt{x}$ has domain constrained to nonnegatives, and in which the domain of $\frac{1}{x}$ excludes zero. Hence zero cannot be a root of this expression, which therefore has only two roots.
- CCAC 00.A (Algebra) 05a: Simplify.
  - Issues:
    - The denominator factors as $(x+1)(x-2)$, not $(x-1)(x+2)$.
- CCAC 00.A (Algebra) 06a: Rationalize and simplify.
  - Issues:
    - Bad arithmetic: $2\times\sqrt{10}$ is $\sqrt{40}$, not $\sqrt{8}$, although for some reason I thought it was.
    - More bad arithmetic: $2\times\sqrt{10}$ is $\sqrt{40}$, not $\sqrt{20}$. What's going on with my basic algebra?
  - Possible remedies:
    - Show all steps.
- CCAC 00.A (Algebra) 07a: Rewrite by completing the square.
  - Minor issue:
    - The constant terms can be combined to $\frac{3}{4}$, but I've left them uncombined as $1-\frac{1}{4}$.
- CCAC 00.A (Algebra) 07b: Rewrite by completing the square.
  - Issues:
    - I should have written 2 instead of $a$. The source of confusion is the leading $a$ coefficient in the square-completion formula. The reason for confusion is thinking while writing; I substituted 2 for $a$ in other parts of the work, but missed the first substitution, and propagated the spurious $a$ through to the final incorrect answer.
  - Possible remedies:
    - Be more careful when double-checking work. In this case I believe I skipped the step of copying the original formula, and skipped straight ahead to substitution into square-completion.
- CCAC 00.D (Trigonometry) 03: Find the length of an arc with radius $12$ cm if the arc subtends a central angle of $30^\circ$.
  - Issues:
    - I dropped units.
  - Remedies:
    - Double check more carefully; practice being mindful of units in dimensional analysis.
- CCAC 00.D (Trigonometry) 04a: Find the exact value of $\tan(\pi / 3)$.
  - To do: memorize common unit circle ratios and functions (including sin, cos, tan, sec, csc, cot). See CCAC Appendix C.
- CCAC 00.D (Trigonometry) 04c: Find the exact value of $\sec(5 \pi / 3)$.
  - Issues:
    - The correct answer is \(2\), not \(\frac{2}{\sqrt{3}}\). I got the wrong answer by confusing \(\sin\) and \(\cos\).
  - Remedies:
    - Drill on trigonometry definitions and identities.
- CCAC 00.D (Trigonometry) 06: If $\sin x = \frac{1}{3}$ and $\sec y = \frac{5}{4}$,
  - Issues:
    - Flubbed math by mixing up the above identities.
  - Fixes:
    - Memorize:
      - $\cos(a+b) = \cos{a}\cos{b} - \sin{a}\sin{b}$
      - $\sin(a+b) = \sin{a}\cos{b} + \cos{a}\sin{b}$
- CCAC 01.5 21: Find the exponential function $f(x)=Ca^x$ whose graph is given below.
  - Thoughts and to-do: this uses several useful techniques:
    - $C$ and $a$ can be identified by taking the logarithm, which converts from exponential form to linear form. In this form, the slope is $\log(a)$ and the $y$-intercept is $\log(C)$.
    - Use point-point formula for a line to identify the slope and $y$-intercept.
    - How can this be adapted if $f$ has horizontal or vertical offsets, or reflections?
    - It would worthwhile to make some more practice problems incorporating various of these ideas.
- CCAC 01.6 21: Find a formula for the inverse of the function $f(x) = 1 + \sqrt{2 + 3x}$.
  - Issues:
    - Sign flip.
  - Fixes:
    - Verify copies.
    - Work with sample values through transformations.
      - **Seems to work well for simple problems.** As overall check, perform at start and end. If fails, perform step-by-step.
- CCAC 01.7 09:
  - Issues:
    - When imagining the graph, I mentally incorrectly doubled instead of halved $\theta$.
    - I incorrectly assumed $y = \sin{\frac{1}{2}\theta}$, instead of $x$.
  - Fixes:
    - Read and copy full problem, verify all components correct.
- CCAC 01.7 19: Describe the motion of a particle with position $(x,y)$ as $t$ varies in the given interval.
  - Thoughts:
    - This gives a good canonical description of a simple ellipse with axes lengths $a$ and $b$ on $x$ and $y$ axes, centered at $(x_1,y_1)$:
      $$
      \left(\frac{x-x_1}{a}\right)^2 + \left(\frac{y-y_1}{b}\right)^2 = 1.
      $$
- CCAC 01.7 29:
  - Issues:
    - Flubbed part (b). Was supposed to find _parametric_ equations, not _cartesian_ equations.
- CCAC 01.7 31c: Find parametric equations for the path of a particle that moves along
  - Thoughts: there are multiple solutions, so this question is somewhat ambiguous.

- CCAC 01.7 35: Compare the curves represented by the parametric equations. How do they differ?
  - Issues:
    - Partially flubbed (b), assuming curve was odd, when actually $x$ and $y$ are nonnegative.
    - Partially flubbed (c), assuming curve was linear.
  - Fixes:
    - Should have tried to transform to cartesian equations, specifying domains.


###### Analyses:

Troubles:
- Things not fully understood:
  - Absolute values when handling even roots of even powers.
    - RoA problem 079: Simplify the radicals:
      - Issue: absolute values when handling even roots of even powers:

        Why $2|x|$ (as opposed to $2x$ or $|2x|?

        $\sqrt{2^2}$ is simply $2$, as is $\sqrt{(-2)}^2.

        But we don’t know the sign of $x$. If $x < 0$ then $\sqrt{x^2} = -x$, whereas if $0 \le x$ then $\sqrt{x^2} = x$. Similarly for $\sqrt[n]{x^n}$.

        This is why $\sqrt{2^2 x^2} = 2|x|$.

    - RoA problem 081: Simplify the radicals:
      - Issue: absolute values when handling even roots of even powers:

        The question here would be: why is $\sqrt{b^3}$ equal to $b\sqrt{b}$ instead of $|b|\sqrt{b}$?

        Because $|b|=b$ implicitly, both are true, but the latter is superfluous. This is because if $b < 0$ then $\sqrt{b^3}$ is undefined (if we restrict to $\mathbb{R}$), so $b$ must be nonnegative.

    - RoA problem 093: Use the Laws of Exponents to rewrite and simplify the expression:
      - Issues:
        - The order of operations is important here. $x^2$ discards the sign of $x$, hence $(x^2)^{3/2} = |x|^3$, whereas I tend to equate $(x^2)^{3/2} = x^{\frac{2\times 3}{2}} = x^3$.

        The order of operations therefore has higher precedence than rules of simplification. I tend to forget this fact.


- Lack of facility:
  - Monitoring domains:
    - Of even roots:
      - RoA problem 095: Use the Laws of Exponents to rewrite and simplify the expression:
        - Issue/question: this is tricky. The domain of $\sqrt[5]{x}$ is all real numbers, but the sixth power drops the sign. So, I believe, $y^{6/5}=|y|^{6/5}$, and therefore the absolute value operation is superfluous and by convention is removed.

      - CCAC 00.A (Algebra) 04e: Factor.
        - Note: the domain of this expression is the positive reals, since $x^{-1/2}=\frac{1}{\sqrt{x}}$, in which $\sqrt{x}$ has domain constrained to nonnegatives, and in which the domain of $\frac{1}{x}$ excludes zero. Hence zero cannot be a root of this expression, which therefore has only two roots.

  - Identifying even and odd functions.
    - CCAC 01.7 35: Compare the curves represented by the parametric equations. How do they differ?
      - Issues:
        - Partially flubbed (b), assuming curve was odd, when actually $x$ and $y$ are nonnegative.
      - Fixes:
        - Should have tried to transform to cartesian equations, specifying domains.

  - Identifying linear functions.
    - CCAC 01.7 35: Compare the curves represented by the parametric equations. How do they differ?
      - Issues:
        - Partially flubbed (c), assuming curve was linear.
      - Fixes:
        - Should have tried to transform to cartesian equations, specifying domains.

- Things not fully memorized:
  - The general form for _completing the square_.
    - RoA mtl 7.0: Rewrite the following general form by _completing the square:_

  - Factoring $a^3 \\m b^3$:
    - RoA problem 103: Rationalize the expression:
      - Issue: I forgot how to factor $a^3 - b^3$; I should have written
        $$
        x^3 - 4^3 = (x - 4)(x^2 + 4x + 16),
        $$
        but instead dropped an exponent and wrote
        $$
        x^3 - 4^3 = (x - 4)(x + 4x + 16).
        $$

  - Trig identities.
    - CCAC 00.D (Trigonometry) 06: If $\sin x = \frac{1}{3}$ and $\sec y = \frac{5}{4}$,
      - Issues:
        - Flubbed math by mixing up the above identities.
      - Fixes:
        - Memorize:
          - $\cos(a+b) = \cos{a}\cos{b} - \sin{a}\sin{b}$
          - $\sin(a+b) = \sin{a}\cos{b} + \cos{a}\sin{b}$

  - Canonical formulae for conic sections.
    - CCAC 01.7 19: Describe the motion of a particle with position $(x,y)$ as $t$ varies in the given interval.
      - Thoughts:
        - This gives a good canonical description of a simple ellipse with axes lengths $a$ and $b$ on $x$ and $y$ axes, centered at $(x_1,y_1)$:
          $$
          \left(\frac{x-x_1}{a}\right)^2 + \left(\frac{y-y_1}{b}\right)^2 = 1.
          $$

- Common confusions:
  - An _irreducible_ polynomial has no _real_ roots. I often misstate as _rational_ roots.
    - RoA mtl 9: Define _irreducible_.
      - Issue: I should say _having no real roots_, but often instead say _having no **rational** roots_, mixing up _real_ and _rational_. I mean the correct things, but say the wrong thing.
  - Mixing up definitions of _irreducible_ and _reducible_.
    - RoA problem 071: Is the following quadratic irreducible?
      - Issue: when $4ac$ is positive, the quadratic is reducible. I sometimes mix up this rule.

  - Mixing up numbers.
    - RoA problem 090: Use the Laws of Exponents to rewrite and simplify the expression:
      - Issues:
        - In this problem, I tend to confuse $2^5$ and $3^5$.

    - CCAC 00.A (Algebra) 07b: Rewrite by completing the square.
      - Issues:
        - I should have written 2 instead of $a$. The source of confusion is the leading $a$ coefficient in the square-completion formula. The reason for confusion is thinking while writing; I substituted 2 for $a$ in other parts of the work, but missed the first substitution, and propagated the spurious $a$ through to the final incorrect answer.
      - Possible remedies:
        - Be more careful when double-checking work. In this case I believe I skipped the step of copying the original formula, and skipped straight ahead to substitution into square-completion.

  - Mixing up trig definitions.
    - CCAC 00.D (Trigonometry) 04c: Find the exact value of $\sec(5 \pi / 3)$.
      - Issues:
        - The correct answer is \(2\), not \(\frac{2}{\sqrt{3}}\). I got the wrong answer by confusing \(\sin\) and \(\cos\).
      - Remedies:
        - Drill on trigonometry definitions and identities.


- Common arithmetic mistakes:
  - Failing to distribute all multiplications.
    - RoA problem 007: Expand and simplify:
      - Issue: I tend to not perform all multiplications in $4(x^2-x+2)$; the correct result is $4x^2 - 4x + 8$, but I often leave the trailing constant as 2 instead of 8.'

  - Basic addition mistakes.
    - RoA problem 015: Expand and simplify:
      - Issue: I should write $-3x+2x=-x$, but for some reason have repeatedly
        written $-2x$ on the right hand side. Usually when I'm tired.
      - Fixes: short of not doing math when tired, double check my work.

  - Basic fraction mistakes.
    - Reducing to lowest terms.
      - RoA problem 037: Factor the expression:
        - Issue: $\frac{18}{12}=\frac{3}{2}$, not 3.

  - Multiplying instead of dividing.
    - CCAC 01.7 09:
      - Issues:
        - When imagining the graph, I mentally incorrectly doubled instead of halved $\theta$.
        - I incorrectly assumed $y = \sin{\frac{1}{2}\theta}$, instead of $x$.
      - Fixes:
        - Read and copy full problem, verify all components correct.

  - Flipping sign.
    - RoA problem 078: Simplify the radicals:
      - Issue: must copy the negative sign, often forget.

    - CCAC 00.A (Algebra) 05a: Simplify.
      - Issues:
        - The denominator factors as $(x+1)(x-2)$, not $(x-1)(x+2)$.

    - CCAC 01.6 21: Find a formula for the inverse of the function $f(x) = 1 + \sqrt{2 + 3x}$.
      - Issues:
        - Sign flip.
      - Fixes:
        - Verify copies.
        - Work with sample values through transformations.
          - **Seems to work well for simple problems.** As overall check, perform at start and end. If fails, perform step-by-step.

  - Moving into and out of roots:
    - CCAC 00.A (Algebra) 06a: Rationalize and simplify.
      - Issues:
        - Bad arithmetic: $2\times\sqrt{10}$ is $\sqrt{40}$, not $\sqrt{8}$, although for some reason I thought it was.
        - More bad arithmetic: $2\times\sqrt{10}$ is $\sqrt{40}$, not $\sqrt{20}$. What's going on with my basic algebra?
      - Possible remedies:
        - Show all steps.

  - Factoring:
    - Moving factors in and out using distributive law

  - Handling exponents:
    - Products of powers: add powers
      - RoA problem 100: Use the Laws of Exponents to rewrite and simplify the expression:
        - Issue: I should have added the exponents; instead I multiplied.

    - Powers of powers: multiply powers
    - Powers to powers


- Conventions:
  - Factor out constants unless doing so introduces noninteger factors.
    - RoA problem 035: Factor the expression:
      - Issue: I could factor out $9$ here, although this requirement may be inconsistent in this text. The rule seems to be "factor out constants unless doing so introduces noninteger factors".

    - RoA problem 059: Complete the square:
      - Issue: I should write $(2x+1)^2 - 3$, but often leave it as $4(x+\frac{1}{2})^2 - 3$, forgetting to remove the internal fraction. I don't think this is a big deal, but it would be better to follow the simplified convention.

  - "Rationalize the expression":
    - Whether this means to rationalize numerator or denominator:
      - RoA problem 101: Rationalize the expression:
        - Issue: I had trouble with the meaning of "rationalize the expression", which I resolved to mean "rationalize the part that isn''t rational (even if the rational part becomes irrational)".

    - The default:
      - RoA problem 102: Rationalize the expression:
        - Possible issue: I tend to leave to denominator in the unsimplified form $\sqrt{x}(1+\sqrt{x})$ instead of $\sqrt{x}+x$. Both answers are equivalent, so this is perhaps a matter of convention, and therefore I’ll consider my answer incorrect. But it’s a minor point.

  - Combining terms when simplifying:
    - CCAC 00.A (Algebra) 07a: Rewrite by completing the square.
      - Minor issue:
        - The constant terms can be combined to $\frac{3}{4}$, but I've left them uncombined as $1-\frac{1}{4}$.

  - Dimensional analysis:
    - CCAC 00.D (Trigonometry) 03: Find the length of an arc with radius $12$ cm if the arc subtends a central angle of $30^\circ$.
      - Issues:
        - I dropped units.
      - Remedies:
        - Double check more carefully; practice being mindful of units in dimensional analysis.

- Following stated instructions.
  - _Solve_ vs. _factor_:
    - RoA problem 062: Solve the equation:
      - Issue: Need to pay better attention to instructions; I should _solve_, not _factor_, e.g., I should answer $4, -2$ instead of $(x-4)(x+2)$.

    - CCAC 00.A (Algebra) 04b: Factor.
      - Issue: Directions are to _factor_. When using quadratic formula, I tend to try to _solve_ instead.

  - _parametric_ vs. _cartesian_:
    - CCAC 01.7 29:
      - Issues:
        - Flubbed part (b). Was supposed to find _parametric_ equations, not _cartesian_ equations.


Thoughts:
- Tools for factoring quadratics.
  - RoA problem 065: Solve the equation:
    - Note: completing the square is probably a quicker way to factor, whereas the quadratic formula is a quicker way to solve.

- Tools for solving quadratics.
  - RoA problem 065: Solve the equation:
    - Note: completing the square is probably a quicker way to factor, whereas the quadratic formula is a quicker way to solve.

- Quicker irreducibility analysis of discriminant:
  - RoA problem 071: Is the following quadratic irreducible?
    - Thoughts: There’s a trick here for quickly analyzing the discriminant: if $ac$ is negative then the discriminant is positive, so the quadratic is reducible.'

- Techniques for analyzing exponential functions:
  - CCAC 01.5 21: Find the exponential function $f(x)=Ca^x$ whose graph is given below.
    - Thoughts and to-do: this uses several useful techniques:
      - $C$ and $a$ can be identified by taking the logarithm, which converts from exponential form to linear form. In this form, the slope is $\log(a)$ and the $y$-intercept is $\log(C)$.
      - Use point-point formula for a line to identify the slope and $y$-intercept.
      - How can this be adapted if $f$ has horizontal or vertical offsets, or reflections?
      - It would worthwhile to make some more practice problems incorporating various of these ideas.


To do:
- Memorize binomial coefficients for $0 \le n,k \le 20$.
  - RoA problem 076: Use the Binomial Theorem to expand the expression:
    - To-do:
      - Memorize binomial coefficients for $0 \le n,k \le 20$.

- Memorize common unit circle ratios and functions (including sin, cos, tan, sec, csc, cot). See CCAC Appendix C.
  - CCAC 00.D (Trigonometry) 04a: Find the exact value of $\tan(\pi / 3)$.
    - To do: memorize common unit circle ratios and functions (including sin, cos, tan, sec, csc, cot). See CCAC Appendix C.


###### Summaries:

Troubles:
- Things not fully understood / lack of facility:
  - Absolute values when handling even roots of even powers.
  - Monitoring domains:
    - Of even roots.
  - Identifying even and odd functions.
  - Identifying linear functions.

- Things not fully memorized:
  - The general form for _completing the square_.
  - Factoring $a^3 \pm b^3$.
  - Trig identities.
  - Canonical formulae for conic sections.

- Common confusions:
  - An _irreducible_ polynomial has no _real_ roots. I often misstate as _rational_ roots.
  - Mixing up definitions of _irreducible_ and _reducible_.
  - Mixing up numbers.
  - Mixing up trig definitions.

- Common arithmetic mistakes:
  - Failing to distribute all multiplications.
  - Basic addition mistakes.
  - Basic fraction mistakes.
    - Reducing to lowest terms.
  - Multiplying instead of dividing.
  - Flipping sign.
  - Moving into and out of roots.
  - Factoring:
    - Moving factors in and out using distributive law
  - Handling exponents:
    - Products of powers: add powers
    - Powers of powers: multiply powers
    - Powers to powers

- Conventions:
  - Factor out constants unless doing so introduces noninteger factors.
  - "Rationalize the expression":
    - Whether this means to rationalize numerator or denominator.
    - The default.
  - Combining terms when simplifying.
  - Dimensional analysis.

- Following stated instructions.
  - _Solve_ vs. _factor_.
  - _parametric_ vs. _cartesian_.



###### Tactics:

The most important troubles to address tactically:
- Common confusions.
- Common arithmetic mistakes.
- Following stated instructions.

The biggest issue is _detecting_ mistakes.
- Reverse check.
  - This can be unwieldy for complex expressions.
- Plug in values.

Tactics to reduce mistakes:
- Identify key words in problem/question.
- Maintain whitespace for work.
- Keep it neat.
  - Copy partial results to new workspace.
    - Verify copy.
- Don't skip too many steps.
- Use tactics to detect mistakes.
- Use dimensional analysis when units are available.
- Double-check the question before moving on.


###### Procedure to reduce mistakes:

- Read question.
  - ID keywords.
- Place problem.
  - Verify copy.
- Try plugging in values, if not too unwieldy.
  - If dimensions are available, use dimensional analysis.
- Repeat until final results:
  - Perform small number of steps.
    - Monitor domain constraints.
  - Check partial results.
    - Plugged values.
    - Reversal.
  - Copy partial results.
    - Verify copy.
- Double-check question before moving on.
  - Do final results answer question?


###### To do:

- Print out and practice mistake-reduction procedure.
- CCAC appendices:
  - Study.
  - Setup Anki problems.
- Areas of focus:
  - Absolute values when handling even roots of even powers.
  - Monitoring domains:
    - Of even roots.
  - Identifying even and odd functions.
  - Identifying linear functions.
  - The general form for _completing the square_.
  - Factoring $a^3 \pm b^3$.
  - Trig identities.
  - Canonical formulae for conic sections.
  - An _irreducible_ polynomial has no _real_ roots. I often misstate as _rational_ roots.
  - Moving into and out of roots.
  - Factoring:
    - Moving factors in and out using distributive law
  - Handling exponents:
    - Products of powers: add powers
    - Powers of powers: multiply powers
    - Powers to powers


##### 1337: Break. Next: print out mistake-reduction procedure.

Next:
- Print out mistake-reduction procedure.
- Personal things to take care of.
- Scraper.
- CCAC appendices:
  - Setup Anki problems.
  - Study.
- Problems for next chapter.
- Work more problems.


##### 1358: Print out mistake-reduction procedure.
