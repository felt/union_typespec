defmodule SomeModule do
  @moduledoc false
  import UnionTypespec, only: [union_type: 1, union_typep: 1]

  @statuses [:read, :unread, :deleted]
  union_type status :: @statuses

  @permissions [:view, :edit, :admin]
  @type permission :: unquote(UnionTypespec.union_type_ast(@permissions))

  @roles [:user, :admin]
  union_typep role :: @roles

  @spec get_permission() :: permission()
  def get_permission do
    # Test the error case by returning something else (like :ok)
    hd(@permissions)
  end

  @spec authorized?(map()) :: boolean()
  def authorized?(_user) do
    # Calling the private function
    get_role()
    true
  end

  @spec get_role() :: role()
  defp get_role do
    # Test the error case by returning something else (like :ok)
    hd(@roles)
  end

  @spec get_status() :: status()
  def get_status do
    # Test the error case by returning something else (like :ok)
    hd(@statuses)
  end
end
