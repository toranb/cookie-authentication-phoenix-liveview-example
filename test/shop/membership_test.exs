defmodule Shop.MembershipTest do
  use Shop.DataCase, async: false

  alias Shop.Membership

  test "personal membership allowed" do
    attrs = %{id: "PERSONAL"}
    changeset = Membership.changeset(%Membership{}, attrs)
    assert changeset.valid?
  end

  test "business membership allowed" do
    attrs = %{id: "BUSINESS"}
    changeset = Membership.changeset(%Membership{}, attrs)
    assert changeset.valid?
  end

  test "everything else is invalid" do
    attrs = %{id: "ZIP"}
    changeset = Membership.changeset(%Membership{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             id: {"is invalid", [validation: :inclusion, enum: ["PERSONAL", "BUSINESS"]]}
           ]
  end
end
