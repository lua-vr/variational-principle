import VersoManual

open Verso Doc Genre Manual Elab

open Lean in
structure TheoremConfig where
  name : Option String
  label : Option Name
  deriving ToJson, FromJson, Quote

open ArgParse in
instance : FromArgs TheoremConfig DocElabM where
  fromArgs := TheoremConfig.mk <$> .named `name .string true
                               <*> .named `label .name true

def theoremCss := r###"
  .theorem {
    border-radius: 7px;
    /* border: 1px solid #ccc; */
    padding: 0px 15px;
    margin: 15px 0px;
    font-style: italic;
    font-size: 0.97rem;
  }
     .theorem em {
    font-weight: 500;
    font-style: normal;
  }
     .theorem-name {
    font-family: var(--verso-text-font-family);
    font-style: normal;
    font-weight: 600;
  }
     .theorem > p:first-of-type {
    display: inline;
  }
  "###

open Lean in
block_extension Block.theorem (cfg : TheoremConfig) where
  data := ToJson.toJson cfg
  traverse := fun _ _ _ => pure none
  extraCss := [theoremCss]
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
