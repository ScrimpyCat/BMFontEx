defmodule BMFont.Info do
    use BMFont.Type

    type :face, "", :string
    type :size, 0, :integer
    type :bold, false, :bool
    type :italic, false, :bool
    type :charset, "", :string
    type :unicode, false, :bool
    type "stretchH", :stretch_height, 100, :integer
    type :smooth, false, :bool
    type "aa", :supersampling, 1, :integer
    type :padding, %{ up: 0, right: 0, down: 0, left: 0 }, :rect
    type :spacing, %{ horizontal: 0, vertical: 0 }, :alignment
    type :outline, 0, :integer
end
