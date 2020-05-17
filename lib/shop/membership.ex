defmodule Shop.Membership do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :string, []}
  schema "memberships" do
    timestamps()
  end

  @required_attrs [
    :id
  ]

  def changeset(membership, params \\ %{}) do
    membership
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
    |> validate_inclusion(:id, ["PERSONAL", "BUSINESS"])
  end
end
