/-
Copyright (c) 2024-2025 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: David Thrane Christiansen
-/

import VersoManual
import Blueprint.Meta.Lean
import Blueprint.Papers
import Blueprint.Theorem

open Verso Doc Genre Manual

open Blueprint

set_option pp.rawOnError true

#doc (Manual) "The variational principle in ergodic dynamics" =>

{index}[example]
This project aims to formalize the theory of measure-theoretic entropy up to its relations to topological entropy, manifested as the variational principle:

$$`h_{\mathrm{top}}(f) = \sup_{\mu \in \mathcal{M}_f(X)}h_{\mu}(f).`

Most of the content will follow the presentation of {citet einsiedlerWardEntropy}[].

# Conditional measures

Hi, hello!

:::thm (name := "Awesome theorem")
This is, supposedely, a theorem. Hello.

$$`\int f(x) dx`
:::

# Index
%%%
number := false
tag := "index"
%%%

{theIndex}
