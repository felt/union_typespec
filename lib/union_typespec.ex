defmodule UnionTypespec do
  @moduledoc """
  A simple, tiny, compile time-only library for defining an Elixir `@type` whose values are one of a fixed set of options.
  """

  @moduledoc since: "0.0.1"

  @doc """
  Transforms an enumerable (like a list of atoms) into an AST for use in a typespec.

  This is primarily useful when you have a module attribute that defines

  Taken wholesale from [Eiji's ElixirForum answer](https://elixirforum.com/t/dynamically-generate-typespecs-from-module-attribute-list/7078/5).

  Example:

      defmodule MyModule do
        import UnionTypespec, only: [union_type: 1]

        @permissions [:view, :edit, :admin]
        union_type permission :: @permissions

        @spec random_permission() :: permission()
        def random_permission, do: Enum.random(@permissions)
      end
  """
  @doc since: "0.0.1"
  defmacro union_type({:"::", _, [{name, _, _}, data]}) do
    quote bind_quoted: [data: data, name: name] do
      @type unquote({name, [], Elixir}) :: unquote(UnionTypespec.union_type_ast(data))
    end
  end

  @doc """
  Unquote on the right-hand side of `@type` if you prefer the explicitness of that syntax over the `union_type` macro.

  Example:

      defmodule MyModule do
        @permissions [:view, :edit, :admin]
        @type permission :: unquote(UnionTypespec.union_type_ast(@permissions))

        @spec random_permission() :: permission()
        def random_permission, do: Enum.random(@permissions)
      end
  """
  @doc since: "0.0.1"
  def union_type_ast([item]), do: item
  def union_type_ast([head | tail]), do: {:|, [], [head, union_type_ast(tail)]}

  @doc """
  Same as `#{inspect(__MODULE__)}.union_type/1` but for a private type (`@typep`).

  Example:

      defmodule MyModule do
        import UnionTypespec, only: [union_typep: 1]

        @permissions [:view, :edit, :admin]
        union_typep permission :: @permissions

        @spec random_permission() :: permission()
        defp random_permission, do: Enum.random(@permissions)
      end
  """
  @doc since: "0.0.3"
  defmacro union_typep({:"::", _, [{name, _, _}, data]}) do
    quote bind_quoted: [data: data, name: name] do
      @typep unquote({name, [], Elixir}) :: unquote(UnionTypespec.union_type_ast(data))
    end
  end
end
