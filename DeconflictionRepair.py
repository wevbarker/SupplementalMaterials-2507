#!/usr/bin/env python3
"""Audit and repair the deconfliction column of AllModels<Theory>.csv.

This is the Python companion to DeconflictionRepair.m in the same directory.
The two are deliberately independent implementations of the same audit: this
one parses the Wolfram expressions with sympy and works in exact rational
linear algebra, while the .m file lets the Wolfram kernel parse its own syntax
and uses MatrixRank. Agreement between them is the check that neither has a
parsing or algebra bug of its own.

WHAT IT READS

Only AllModels<Theory>.csv, the table emitted by MakeSurvey. Nothing else: no
PSALTer, no Lagrangians, no spectra. Every conclusion below is therefore
downstream of the survey's own model discovery and definitions. In particular
this script CANNOT detect a model the survey never found, and if a model's
DEFINITION were wrong the deconfliction derived from it would inherit the
error. The unitarity column is read only to classify results, never checked.

WHAT IT CHECKS

Each row records a DEFINITION (linear forms which must vanish to reach the
model, holding simultaneously) and a DECONFLICTION (alternative ways of
falling into a deeper model, any one of which must be avoided).

A conjunction of vanishing linear forms is a linear subspace, so:

  X lies BELOW P        <=>  rowspace(P) is contained in rowspace(X)
                             and rank(X) > rank(P)
  X is guarded by A     <=>  rowspace(A) is contained in rowspace(X)

COMPLETENESS  every X below P satisfies at least one recorded alternative of P
SOUNDNESS     every recorded alternative of P is satisfied by some X below P

Two answers are compared by equality of the UNION of their subspaces: each
alternative of one must lie inside some alternative of the other, and vice
versa. Over an infinite field a subspace contained in a finite union of
subspaces lies wholly inside one of them, so the test is exact. Comparing
alternative-by-alternative is the WRONG test -- a re-partitioned answer denotes
the same conditions while pairing up differently, and which deeper model a
given alternative guards against is not recorded in the table and is not needed
by the reader.

Completeness matters because a model below P that satisfies no listed
alternative can be reached from P without violating anything the table warns
about. Chaining cannot rescue it: if X sits below an intermediate Y that is
guarded, then X inherits Y's conditions and is guarded too.

No tree structure is assumed anywhere. The relation is evaluated for every
ordered pair, so a model with several ancestors at the same level -- and most
of them have several -- is counted under each. The bifurcation tree used to
discover the models is irrelevant here and is not consulted.

REPAIR

The conditions carrying P into X are the quotient of X's subspace by P's, which
is uniquely determined; only the choice of basis is free. Alternatives are then
pruned, keeping one unless some DIFFERENT alternative is strictly weaker. Every
comparison is made modulo P's own conditions -- comparing the extra-condition
sets directly is wrong, since two extras can look incomparable while the spaces
they generate on top of P are nested.

USAGE

    python3 DeconflictionRepair.py            # audit, then propose repairs
    python3 DeconflictionRepair.py --quiet    # summary only

Self-tests run on every invocation, including a NEGATIVE one: a comparison that
cannot fail proves nothing, and an earlier version of this audit reported a
clean result from a test that was silently returning the same answer
throughout.
"""

import csv
import os
import re
import sys
from fractions import Fraction
from math import gcd

import sympy

THEORY = "A23"
HERE = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(HERE, "AllModels%s.csv" % THEORY)


def split_wolfram_list(text):
    """Split a Wolfram list "{a, {b,c}, d}" into ["a", "{b,c}", "d"]."""
    text = text.strip()
    if not (text.startswith("{") and text.endswith("}")):
        return [text]
    inner = text[1:-1].strip()
    if not inner:
        return []
    items, current, depth = [], "", 0
    for ch in inner:
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
        if ch == "," and depth == 0:
            items.append(current.strip())
            current = ""
        else:
            current += ch
    if current.strip():
        items.append(current.strip())
    return items


def load(path):
    """Return (couplings, definitions, alternatives, unitarity).

    Expressions are parsed by sympy, never by regular expression. An earlier
    regex parser silently misread a leading rational coefficient such as
    "-1/4*K4" as "+4*K4"; that form occurs in A23 but not in S123, so the
    error was invisible until the two theories were compared.
    """
    rows = [r for r in csv.reader(open(path)) if r]
    blob = " ".join(r[1] + " " + r[2] for r in rows)
    couplings = sorted(set(re.findall(r"[KM]\d+", blob)),
                       key=lambda s: (s[0], int(s[1:])))
    symbols = {c: sympy.Symbol(c) for c in couplings}

    def vector(expr):
        parsed = sympy.expand(sympy.sympify(expr, locals=symbols))
        poly = sympy.Poly(parsed, *[symbols[c] for c in couplings])
        if poly.total_degree() > 1:
            raise ValueError("not linear: %s" % expr)
        return tuple(Fraction(str(sympy.nsimplify(parsed.coeff(symbols[c]))))
                     for c in couplings)

    definitions, alternatives, unitarity = {}, {}, {}
    for name, impose, avoid, unitary in ((r[0].strip(), r[1].strip(),
                                          r[2].strip(), r[3].strip())
                                         for r in rows):
        definitions[name] = [vector(e) for e in split_wolfram_list(impose)]
        alternatives[name] = [
            [vector(f) for f in (split_wolfram_list(item)
                                 if item.startswith("{") else [item])]
            for item in split_wolfram_list(avoid)]
        unitarity[name] = unitary
    return couplings, definitions, alternatives, unitarity


def make_rank(width):
    def rank(matrix):
        if not matrix:
            return 0
        rows = [list(r) for r in matrix]
        pivot = 0
        for col in range(width):
            candidate = next((i for i in range(pivot, len(rows))
                              if rows[i][col] != 0), None)
            if candidate is None:
                continue
            rows[pivot], rows[candidate] = rows[candidate], rows[pivot]
            lead = rows[pivot][col]
            rows[pivot] = [x / lead for x in rows[pivot]]
            for i in range(len(rows)):
                if i != pivot and rows[i][col] != 0:
                    factor = rows[i][col]
                    rows[i] = [a - factor * b
                               for a, b in zip(rows[i], rows[pivot])]
            pivot += 1
        return pivot
    return rank


def render(vector, couplings):
    """Print a linear form with integer coefficients, cleared of fractions."""
    lcm = 1
    for x in vector:
        if x:
            lcm = lcm * x.denominator // gcd(lcm, x.denominator)
    scaled = [int(x * lcm) for x in vector]
    divisor = 0
    for x in scaled:
        divisor = abs(x) if divisor == 0 else gcd(divisor, abs(x))
    if divisor:
        scaled = [x // divisor for x in scaled]
    parts = []
    for name, value in zip(couplings, scaled):
        if value == 0:
            continue
        sign = "-" if value < 0 else ("+" if parts else "")
        magnitude = "" if abs(value) == 1 else str(abs(value))
        parts.append("%s%s%s" % (sign, magnitude, name))
    return "".join(parts) if parts else "0"


def glyph(unitary):
    if ">" in unitary or "<" in unitary:
        return "Consistent"
    if "Demonstrably" in unitary:
        return "Inconsistent"
    if "True" in unitary:
        return "Empty"
    return "More"


def main():
    quiet = "--quiet" in sys.argv
    couplings, definitions, alternatives, unitarity = load(CSV_PATH)
    rank = make_rank(len(couplings))
    names = list(definitions)
    ranks = {m: rank(definitions[m]) for m in names}

    def below(deeper, parent):
        return (ranks[deeper] > ranks[parent]
                and rank(definitions[deeper] + definitions[parent])
                == ranks[deeper])

    def guarded(model, alternative):
        return rank(definitions[model] + alternative) == ranks[model]

    print("theory %s: %d models, %d couplings %s"
          % (THEORY, len(names), len(couplings), couplings))

    def subspace_of(a, b):
        return rank(a + b) == rank(a)

    def same_union(xs, ys):
        return (all(any(subspace_of(x, y) for y in ys) for x in xs)
                and all(any(subspace_of(y, x) for x in xs) for y in ys))

    ok_a = all(same_union(alternatives[m], alternatives[m]) for m in names)
    two = [m for m in names if len(alternatives[m]) > 1][:2]
    ok_b = same_union(alternatives[two[0]], alternatives[two[1]]) if len(two) == 2 else None
    m0 = next(m for m in names if alternatives[m])
    ok_c = same_union([[tuple(-3 * c for c in f) for f in alternatives[m0][0]]],
                      [alternatives[m0][0]])
    print("self-test A (must be True)   recorded vs itself, every row: %s" % ok_a)
    print("self-test B (must be False)  two genuinely different rows : %s" % ok_b)
    print("self-test C (must be True)   same set, rescaled           : %s" % ok_c)
    if not (ok_a and ok_c) or ok_b:
        print("*** SELF-TESTS FAILED - results below are not trustworthy ***")

    descendants = {m: [k for k in names if k != m and below(k, m)]
                   for m in names}

    incomplete, unsound = [], []
    for model in names:
        for index, alternative in enumerate(alternatives[model]):
            if descendants[model] and not any(
                    guarded(k, alternative) for k in descendants[model]):
                unsound.append((model, index + 1))
        missed = [k for k in descendants[model]
                  if not any(guarded(k, a) for a in alternatives[model])]
        if missed:
            incomplete.append((model, missed))

    print("\nCOMPLETENESS  rows whose deconfliction misses a model below: "
          "%d of %d" % (len(incomplete), len(names)))
    print("SOUNDNESS     recorded alternatives matching nothing below: %d"
          % len(unsound))
    tally = {}
    for model, _ in incomplete:
        key = glyph(unitarity[model])
        tally[key] = tally.get(key, 0) + 1
    print("by unitarity glyph: %s" % tally)
    print("rows recording nothing while models lie below: %d"
          % len([m for m, _ in incomplete if not alternatives[m]]))
    if quiet:
        return

    def extra(parent, deeper):
        """A basis for deeper's conditions beyond parent's."""
        kept = []
        combined = definitions[parent] + definitions[deeper]
        rows = [list(r) for r in combined]
        for row in rows:
            if rank(definitions[parent] + kept + [tuple(row)]) > \
               rank(definitions[parent] + kept):
                kept.append(tuple(row))
        return kept

    def repaired(parent):
        candidates = [(k, extra(parent, k)) for k in descendants[parent]]

        def implies(a, b):
            return rank(definitions[parent] + a + b) \
                == rank(definitions[parent] + a)

        kept = [(x, a) for x, a in candidates
                if not any(y != x and implies(a, b) and not implies(b, a)
                           for y, b in candidates)]
        deduped = []
        for x, a in kept:
            if not any(implies(a, b) and implies(b, a) for _, b in deduped):
                deduped.append((x, a))
        return deduped

    print("\nPROPOSED DECONFLICTION for each incomplete row")
    print("(the recorded alternatives are reproduced among these; the rest "
          "are additions)\n")
    for model, missed in incomplete:
        print("  %s   [%s]   records %d, misses %d below"
              % (model, glyph(unitarity[model]),
                 len(alternatives[model]), len(missed)))
        for reached, forms in repaired(model):
            body = " AND ".join(render(f, couplings) + "=0" for f in forms)
            print("      [ %s ]   (reaches %s)" % (body, reached))
        print()


if __name__ == "__main__":
    main()
