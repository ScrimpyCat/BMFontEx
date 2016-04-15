defmodule BMFont.Char do
    use BMFont.Type

    type :id, 0, :integer
    type :x, 0, :integer
    type :y, 0, :integer
    type :width, 0, :integer
    type :height, 0, :integer
    type :xoffset, 0, :integer
    type :yoffset, 0, :integer
    type :xadvance, 0, :integer
    type :page, 0, :integer
    type "chnl", :channel, 0, :integer
end
