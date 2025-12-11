/-
Copyright (c) 2024-2025 Lean FRO LLC. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: David Thrane Christiansen
-/

import VersoManual
import Blueprint.Meta.Lean
import Blueprint.Papers

-- This is a chapter that's included
import Blueprint.Nat

-- This gets access to most of the manual genre (which is also useful for textbooks)
open Verso Doc Genre Manual Elab

-- This gets access to Lean code that's in code blocks, elaborated in the same process and
-- environment as Verso
open Verso.Genre.Manual.InlineLean


open Blueprint

set_option pp.rawOnError true

open Lean in
structure TheoremConfig where
  name : Option String
  label : Option Name
  deriving ToJson, FromJson, Quote

open ArgParse in
instance : FromArgs TheoremConfig DocElabM where
  fromArgs := TheoremConfig.mk <$> .named `name .string true
                               <*> .named `label .name true

open Lean in
block_extension Block.theorem (cfg : TheoremConfig) where
  data := ToJson.toJson cfg
  traverse := fun _ _ _ => pure none
  toTeX :=
    some fun _ go _ _ content => do
      pure <| .seq <| ← content.mapM fun b => do
        pure <| .seq #[← go b, .raw "\n"]
  toHtml :=
    open Verso.Output.Html in
    open Verso.Doc.Html in
    some fun _ go _ data content => do
      let .ok (cfg : TheoremConfig) := FromJson.fromJson? data
        | HtmlT.logError s!"Error deserializing theorem data"
          return .empty
      pure {{
        <div class="theorem">
          <span class="theorem-name">"Theorem"
            {{if let .some n := cfg.name then " (" ++ n ++ ")" else ""}}
            "."
          </span>
          {{← content.mapM go}}
        </div>
      }}

open Lean Elab in
@[directive]
def thm : DirectiveExpanderOf TheoremConfig
  | cfg, stxs => do
    let child ← stxs.mapM elabBlock
    ``(Block.other (Block.theorem $(quote cfg)) #[ $[ $child ],* ])

#doc (Manual) "The variational principle in ergodic dynamics" =>

{index}[example]
This project aims to formalize the theory of measure-theoretic entropy up to its relations to topological entropy, manifested as the variational principle:

$$`h_{\mathrm{top}}(f) = \sup_{\mu \in \mathcal{M}_f(X)}h_{\mu}(f).`

Most of the content will follow the presentation of {citet einsiedlerWardEntropy}[].

# Conditional measures

Hi, hello!

:::thm (name := "Awesome theorem")
This is, supposedely, a theorem. Why is it not working? :(
:::

# Index
%%%
number := false
tag := "index"
%%%

{theIndex}
