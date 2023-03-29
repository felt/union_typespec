defmodule Test.ModuleTest do
  @moduledoc false
  import UnionTypespec, only: [union_type: 1]

  @statuses [:read, :unread, :deleted]
  union_type status :: @statuses

  @permissions [:view, :edit, :admin]
  @type permission :: unquote(UnionTypespec.union_type_ast(@permissions))

  @spec get_permission() :: permission()
  def get_permission do
    # Test the error case by returning something else (like :ok)
    hd(@permissions)
  end

  @spec get_status() :: status()
  def get_status do
    # Test the error case by returning something else (like :ok)
    hd(@statuses)
  end
end
