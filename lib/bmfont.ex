defmodule BMFont do
    @moduledoc """
      Parses text and binary BMFont files in accordance with the
      [AngelCode spec](http://www.angelcode.com/products/bmfont/doc/file_format.html).

      Everything is kept pretty much as is, with the exception of some of the fields
      being renamed to their longer forms.
    """

    @type t :: %BMFont{ info: %BMFont.Info{}, common: %BMFont.Common{}, pages: [%BMFont.Page{}], chars: [%BMFont.Char{}], kernings: [%BMFont.Kerning{}] }

    defstruct info: %BMFont.Info{}, common: %BMFont.Common{}, pages: [], chars: [], kernings: []

    @doc """
      Parse a BMFont file format, supports both text and binary versions.

      The `parse/1` function can be passed either the binary data, the entire string, or
      an enumerable with the separate lines of text.
    """
    @spec parse(binary | [String.t]) :: t
    def parse(data = <<"BMF", _ :: binary>>) do
        { { { :header, {:magic, "BMF"}, {:version, 3} }, { :block, data } }, <<>> } = Tonic.load(data, BMFont.Binary)
        new_binary(data)
    end
    def parse(string) when is_binary(string), do: parse(String.split(string, "\n", trim: true))
    def parse(lines) do
        Enum.map(lines, fn line ->
            create_tag(String.trim(line) |> String.split(" ", trim: true))
        end) |> new
    end

    defp create_tag(["char"|args]), do: BMFont.Char.parse(args)
    defp create_tag(["kerning"|args]), do: BMFont.Kerning.parse(args)
    defp create_tag(["page"|args]), do: BMFont.Page.parse(args)
    defp create_tag(["info"|args]), do: BMFont.Info.parse(args)
    defp create_tag(["common"|args]), do: BMFont.Common.parse(args)
    defp create_tag(["chars"|_]), do: nil #isn't needed
    defp create_tag(["kernings"|_]), do: nil #isn't needed
    defp create_tag(line), do: IO.puts "Unable to parse line: #{line}"

    defp new(tags, font \\ %BMFont{})
    defp new([], font), do: %{ font | pages: Enum.reverse(font.pages), chars: Enum.reverse(font.chars), kernings: Enum.reverse(font.kernings) }
    defp new([tag = %BMFont.Char{}|tags], font), do: new(tags, %{ font | chars: [tag|font.chars] })
    defp new([tag = %BMFont.Kerning{}|tags], font), do: new(tags, %{ font | kernings: [tag|font.kernings] })
    defp new([tag = %BMFont.Page{}|tags], font), do: new(tags, %{ font | pages: [tag|font.pages] })
    defp new([tag = %BMFont.Info{}|tags], font), do: new(tags, %{ font | info: tag })
    defp new([tag = %BMFont.Common{}|tags], font), do: new(tags, %{ font | common: tag })
    defp new([nil|tags], font), do: new(tags, font)

    defp new_binary(tags, font \\ %BMFont{})
    defp new_binary([], font), do: font
    defp new_binary([{ _, _, { :info, { :size, size }, { :smooth, smooth }, { :unicode, unicode }, { :italic, italic }, { :bold, bold }, _, { :charset, charset }, { :stretch_height, stretch_height }, { :supersampling, supersampling }, { :padding, { :up, padding_up }, { :right, padding_right }, { :down, padding_down }, { :left, padding_left } }, { :spacing, { :horizontal, spacing_horizontal }, { :vertical, spacing_vertical } }, { :outline, outline }, { :face, face } } }|tags], font), do: new_binary(tags, %{ font | info: %BMFont.Info{ size: size, smooth: smooth, unicode: unicode, italic: italic, bold: bold, charset: charset, stretch_height: stretch_height, supersampling: supersampling, padding: %{ up: padding_up, right: padding_right, down: padding_down, left: padding_left }, spacing: %{ horizontal: spacing_horizontal, vertical: spacing_vertical }, outline: outline, face: face } })
    defp new_binary([{ _, _, { :common, { :line_height, line_height }, { :base, base }, { :width, width }, { :height, height }, { :pages, pages }, { :packed, packed }, { :alpha_channel, alpha_channel }, { :red_channel, red_channel }, { :green_channel, green_channel }, { :blue_channel, blue_channel } } }|tags], font), do: new_binary(tags, %{ font | common: %BMFont.Common{ line_height: line_height, base: base, width: width, height: height, pages: pages, packed: packed, alpha_channel: alpha_channel, red_channel: red_channel, green_channel: green_channel, blue_channel: blue_channel } })
    defp new_binary([{ _, _, { :pages, pages } }|tags], font), do: new_binary(tags, %{ font | pages: Enum.map(Enum.with_index(pages), fn { { { :file, file } }, index } -> %BMFont.Page{ id: index, file: file } end) })
    defp new_binary([{ _, _, { :chars, chars } }|tags], font), do: new_binary(tags, %{ font | chars: Enum.map(chars, fn { { :id, id }, { :x, x }, { :y, y }, { :width, width }, { :height, height }, { :xoffset, xoffset }, { :yoffset, yoffset }, { :xadvance, xadvance }, { :page, page }, { :channel, channel } } -> %BMFont.Char{ id: id, x: x, y: y, width: width, height: height, xoffset: xoffset, yoffset: yoffset, xadvance: xadvance, page: page, channel: channel } end) })
    defp new_binary([{ _, _, { :kernings, kernings } }|tags], font), do: new_binary(tags, %{ font | kernings: Enum.map(kernings, fn { { :first, first }, { :second, second }, { :amount, amount } } -> %BMFont.Kerning{ first: first, second: second, amount: amount } end) })
end
