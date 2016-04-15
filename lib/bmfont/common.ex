defmodule BMFont.Common do
    use BMFont.Type

    type "lineHeight", :line_height, 0, :integer
    type :base, 0, :integer
    type "scaleW", :width, 0, :integer
    type "scaleH", :height, 0, :integer
    type :pages, 0, :integer
    type :packed, false, :bool
    type "alphaChnl", :alpha_channel, 0, :integer
    type "redChnl", :red_channel, 0, :integer
    type "greenChnl", :green_channel, 0, :integer
    type "blueChnl", :blue_channel, 0, :integer
end
