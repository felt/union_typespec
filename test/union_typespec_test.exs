defmodule UnionTypespecTest do
  use ExUnit.Case, async: true

  alias UnionTypespec.Test.SampleModule

  describe "union_type/1" do
    test "creates a valid @type from list" do
      assert fetch!(:type, :status) == "status() :: :read | :unread | :deleted"
    end
  end

  describe "union_type_ast/1" do
    test "when unquoted in a @type, creates valid value of type" do
      assert fetch!(:type, :permission) == "permission() :: :view | :edit | :admin"
    end
  end

  describe "union_typep/1" do
    test "creates a valid @typep from list" do
      assert fetch!(:typep, :role) == "role() :: :user | :admin"
    end
  end

  defp fetch!(type_of_type, type_name) do
    assert {:ok, types} = Code.Typespec.fetch_types(SampleModule)
    assert {^type_of_type, type} = Enum.find(types, fn {_, {name, _, _}} -> name == type_name end)

    type
    |> Code.Typespec.type_to_quoted()
    |> Macro.to_string()
  end
end
