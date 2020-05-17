defmodule Shop.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :hash, :string
    field :password, :string, virtual: true

    belongs_to :membership, Shop.Membership, type: :string

    timestamps()
  end

  @required_attrs [
    :email,
    :password,
    :membership_id
  ]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8, max: 20, message: "password must be 8-20 characters")
    |> foreign_key_constraint(:membership_id, name: :users_membership_id_fkey)
    |> create_password_hash()
  end

  def create_password_hash(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  def create_password_hash(%Ecto.Changeset{} = changeset) do
    password_hash =
      changeset
      |> Ecto.Changeset.get_field(:password)
      |> Shop.Password.hash()

    changeset
    |> Ecto.Changeset.put_change(:hash, password_hash)
  end
end
