defmodule BMFont.Binary do
    use Tonic, optimize: true

    endian :little
    group :header do
        string :magic, length: 3
        uint8 :version
    end

    repeat :block do
        uint8 :type
        uint32 :size

        chunk get(:size) do
            on get(:type) do
                1 -> # info
                    group :info do
                        int16 :size
                        bit :smooth
                        bit :unicode
                        bit :italic
                        bit :bold
                        bit :fixed_height # ??
                        skip :bit # reserved bit 5
                        skip :bit # reserved bit 6
                        skip :bit # reserved bit 7
                        uint8 :charset, fn
                            { name, 0 } -> { name, "" }
                            { name, charset } -> { name, to_string(charset) } # unsure of correct thing to do here
                        end
                        uint16 :stretch_height
                        uint8 :supersampling
                        group :padding do
                            uint8 :up
                            uint8 :right
                            uint8 :down
                            uint8 :left
                        end
                        group :spacing do
                            uint8 :horizontal
                            uint8 :vertical                        
                        end
                        uint8 :outline
                        string :face, 0
                    end
                2 -> # common
                    group :common do
                        uint16 :line_height
                        uint16 :base
                        uint16 :width
                        uint16 :height
                        uint16 :pages
                        skip bit # reserved bit 0
                        skip bit # reserved bit 1
                        skip bit # reserved bit 2
                        skip bit # reserved bit 3
                        skip bit # reserved bit 4
                        skip bit # reserved bit 5
                        skip bit # reserved bit 6
                        bit :packed
                        uint8 :alpha_channel
                        uint8 :red_channel
                        uint8 :green_channel
                        uint8 :blue_channel
                    end
                3 -> # pages
                    repeat :pages do
                        string :file, 0
                    end
                4 -> # chars
                    repeat :chars do
                        uint32 :id
                        uint16 :x
                        uint16 :y
                        uint16 :width
                        uint16 :height
                        int16 :xoffset
                        int16 :yoffset
                        int16 :xadvance
                        uint8 :page
                        uint8 :channel
                    end
                5 -> # kerning pairs
                    repeat :kernings do
                        uint32 :first
                        uint32 :second
                        int16 :amount
                    end
            end
        end
    end
end
