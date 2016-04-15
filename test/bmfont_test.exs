defmodule BMFontTest do
    use ExUnit.Case
    doctest BMFont

    setup context do
        font = %BMFont{
            chars: [
                %BMFont.Char{ channel: 15, height: 1, id: 32, page: 0, width: 3, x: 155, xadvance: 8, xoffset: -1, y: 75, yoffset: 31 },
                %BMFont.Char{ channel: 15, height: 20, id: 33, page: 0, width: 4, x: 250, xadvance: 8, xoffset: 2, y: 116, yoffset: 6 }
            ],
            common: %BMFont.Common{ alpha_channel: 1, base: 26, blue_channel: 0, green_channel: 0, height: 256, line_height: 32, packed: false, pages: 1, red_channel: 0, width: 256 },
            info: %BMFont.Info{ bold: false, charset: "", face: "Test", italic: false, outline: 0, padding: %{ down: 3, left: 4, right: 2, up: 1 }, size: 32, smooth: true, spacing: %{ horizontal: 1, vertical: 2 }, stretch_height: 100, supersampling: 1, unicode: false },
            kernings: [%BMFont.Kerning{ amount: -2, first: 32, second: 33 }],
            pages: [%BMFont.Page{ file: "Test.png", id: 0 }]}

        { :ok, [font: font] }
    end

    test "parsing BMFont text", %{ font: font } do
        assert font == """
        info face="Test" size=32 bold=0 italic=0 charset="" unicode=0 stretchH=100 smooth=1 aa=1 padding=1,2,3,4 spacing=1,2 outline=0
        common lineHeight=32 base=26 scaleW=256 scaleH=256 pages=1 packed=0 alphaChnl=1 redChnl=0 greenChnl=0 blueChnl=0
        page id=0 file="Test.png"
        chars count=2
        char id=32   x=155   y=75    width=3     height=1     xoffset=-1    yoffset=31    xadvance=8     page=0  chnl=15
        char id=33   x=250   y=116   width=4     height=20    xoffset=2     yoffset=6     xadvance=8     page=0  chnl=15
        kernings count=1
        kerning first=32  second=33  amount=-2
        """ |> BMFont.parse
    end

    test "parsing BMFont binary", %{ font: font } do
        assert font == <<
            "BMF", 3 :: size(8),

            1 :: size(8), 19 :: size(32)-little,
            32 :: size(16)-little, 1 :: size(1), 0 :: size(7), 0 :: size(8), 100 :: size(16)-little, 1 :: size(8), 1 :: size(8), 2 :: size(8), 3 :: size(8), 4 :: size(8), 1 :: size(8), 2 :: size(8), 0 :: size(8), "Test", 0 :: size(8),

            2 :: size(8), 15 :: size(32)-little,
            32 :: size(16)-little, 26 :: size(16)-little, 256 :: size(16)-little, 256 :: size(16)-little, 1 :: size(16)-little, 0 :: size(8), 1 :: size(8), 0 :: size(24),

            3 :: size(8), 9 :: size(32)-little,
            "Test.png", 0 :: size(8),

            4 :: size(8), 40 :: size(32)-little,
            32 :: size(32)-little, 155 :: size(16)-little, 75 :: size(16)-little, 3 :: size(16)-little, 1 :: size(16)-little, -1 :: size(16)-little, 31 :: size(16)-little, 8 :: size(16)-little, 0 :: size(8), 15 :: size(8),
            33 :: size(32)-little, 250 :: size(16)-little, 116 :: size(16)-little, 4 :: size(16)-little, 20 :: size(16)-little, 2 :: size(16)-little, 6 :: size(16)-little, 8 :: size(16)-little, 0 :: size(8), 15 :: size(8),

            5 :: size(8), 10 :: size(32)-little,
            32 :: size(32)-little, 33 :: size(32)-little, -2 :: size(16)-little
        >> |> BMFont.parse
    end
end
