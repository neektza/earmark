defmodule Helpers.InlineCodeTest do
  use ExUnit.Case
  import Earmark.Helpers.InlineCodeHelpers, only: [still_pending_inline_code: 2, pending_inline_code: 1]

  # pending_inline_code
  [
    { "empty line -> not a pending inline code", "", {nil, false} },
    { "no backquotes -> not a pending inline code", "Hello World", {nil, false} },
    { "closed backquotes --> not a pending inline code", "`a ``` b`c", {nil, false} },
    { "pair of backquotes, nested structs -> not pending", "`1 `` 2` `` ` `` >`< `` >`<", {nil, false}},
    { "pair of backquotes, some escapes -> not pending", "`1 `` 2` `` ` `` >`< `` \\`>`<", {nil, false}},

    { "one single backquote -> pending(`)", "`", {"`", true} },
    { "one double backquote -> pending(``)", "``", {"``", true} },
    { "triple backquote after some text -> pending(```)", "alpha```", {"```", true} },
    { "single backquote in between -> pending(`)", "`1 `` 2` `` ` `` >`< ``", {"`", true}},
    { "single backquote in between, some escapes -> pending(`)", "`1 `` 2` `` ` `` \\`>`< ``", {"`", true}}
  ] |> Enum.each(fn { description, line, result } -> 
           test(description) do
             assert pending_inline_code(unquote(line)) == unquote(result)
           end
         end)
  
  # still_pending_inline_code
  [
    # description                                        opener line    result
    { "empty line -> not closing for single backquote" , "`"  , ""    , {"`", false} },
    { "empty line -> not closing for double backquote" , "``" , ""    , {"``", false} },
    { "single backquote closes single backquote"       , "`"  , "`"   , {nil, false} },
    { "double backquote closes double backquote"       , "``" , " ``" , {nil, false} },
    { "pair of single backquotes does not close single backquote", "`", "alpha ` beta`", {"`", true}},
    { "odd number of single backquotes closes single backquote", "`", "` ` `", {nil, false}},
    { "escapes do not close",                            "`", "`  ` \\`", {"`", true}},
    { "first double backquote inside, second reopens", "`", "`` ` ``", {"``", true}},
    { "triple backqoute is closed but double is opened", "```", "``` ``", {"``", true}},
    { "triple backqoute is closed but single is opened", "```", "``` ` ``` ``` ``", {"`", true}},
    { "backquotes before closing do not matter",         "``", "` ``", {nil, false}},
    { "backquotes before closing do not matter (reopening case)", "``", "` `` ```", {"```", true}},
    { "backquotes before closing and after opening do not matter", "``", "` `` ``` ````", {"```", true}},
  ] |> Enum.each( fn { description, opener, line, result } ->
         test(description) do
           assert still_pending_inline_code(unquote(line), unquote(opener)) == unquote(result)
         end
       end)
         
end
