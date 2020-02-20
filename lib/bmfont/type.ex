defmodule BMFont.Type do
    defmacro __using__(_) do
        quote do
            import BMFont.Type

            @before_compile unquote(__MODULE__)
            @types []
        end
    end

    defmacro __before_compile__(env) do
        quote do
            defstruct unquote(Enum.map(Module.get_attribute(env.module, :types), fn { _, name, default, _ } -> { name, default } end))

            def parse(args) do
                Enum.reduce(args, %unquote(env.module){}, unquote({ :fn, [env.module], Enum.map(Module.get_attribute(env.module, :types), fn
                    { cmd, name, _, :string } -> List.first(quote do
                        <<"#{unquote(cmd)}=", arg :: binary>>, struct -> %{ struct | unquote(name) =>  String.trim(arg, "\"") }
                    end)
                    { cmd, name, _, :integer } -> List.first(quote do
                        <<"#{unquote(cmd)}=", arg :: binary>>, struct -> %{ struct | unquote(name) =>  String.to_integer(arg) }
                    end)
                    { cmd, name, _, :bool } -> List.first(quote do
                        <<"#{unquote(cmd)}=", arg :: binary>>, struct -> %{ struct | unquote(name) =>  String.to_integer(arg) != 0 }
                    end)
                    { cmd, name, _, :rect } -> List.first(quote do
                        <<"#{unquote(cmd)}=", arg :: binary>>, struct -> %{ struct | unquote(name) =>  Enum.zip([:up, :right, :down, :left], String.split(arg, ",") |> Enum.map(&String.to_integer/1)) |> Map.new }
                    end)
                    { cmd, name, _, :alignment } -> List.first(quote do
                        <<"#{unquote(cmd)}=", arg :: binary>>, struct -> %{ struct | unquote(name) =>  Enum.zip([:horizontal, :vertical], String.split(arg, ",") |> Enum.map(&String.to_integer/1)) |> Map.new }
                    end)
                end) }))
            end
        end
    end

    defmacro type(name, default, kind), do: quote do: type(unquote(to_string(name)), unquote(name), unquote(default), unquote(kind))

    defmacro type(cmd, name, default, kind), do: quote do: @types [{ unquote(cmd), unquote(name), unquote(Macro.escape(default)), unquote(kind) }|@types]
end
