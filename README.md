# union_typespec

A simple, tiny, compile time-only library for defining an Elixir `@type` whose values
are one of a fixed set of options.

There are two ways to use it:

1. The `union_type` macro, which replaces a normal `@type` annotation with a nice,
   concise macro version of the type definition.
2. `UnionTypespec.union_type_ast/1`, which produces an AST you can `unquote` within
   the usual `@type` definition.

Here's what those look like in practice:

```elixir
defmodule MyModule do
  import UnionTypespec, only: [union_type: 1]

  @statuses [:read, :unread, :deleted]
  union_type status :: @statuses

  @permissions [:view, :edit, :admin]
  @type permission :: unquote(UnionTypespec.union_type_ast(@permissions))

  @spec get_permission() :: permission()
  def get_permission, do: Enum.random(@permissions)

  @spec get_status() :: status()
  def get_status, do: Enum.random(@statuses)
end
```

## Installation

We have not yet published the package to Hex, because it's not (yet?) clear
that it's valuable to anyone else. Until we do, you can still install it by
adding the following to your `mix.exs` and running `$ mix deps.get`:

```elixir
def deps do
  [
    {:union_typespec, git: "https://github.com/felt/union_typespec.git", tag: "v0.0.2", runtime: false},
  ]
end
```

And if you do find it useful, we'd love to hear about it!
