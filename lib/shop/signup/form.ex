defmodule Shop.Signup.Form do
  use Ecto.Schema

  import Ecto.Changeset

  alias Shop.User

  @password_message "Password must be between 8 and 20 characters"

  schema "signup_form" do
    field :email, :string
    field :password, :string
    field :email_touched, :boolean
    field :password_touched, :boolean
    field :password_focused, :boolean
    field :form_submitted, :boolean
    field :form_disabled, :boolean

    field :membership_id, :string
  end

  @required_attrs [
    :email,
    :password,
    :membership_id
  ]

  @optional_attrs [
    :email_touched,
    :password_touched,
    :password_focused,
    :form_submitted,
    :form_disabled
  ]

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @required_attrs ++ @optional_attrs)
    |> validate_required(:email, message: "Email address is required")
    |> validate_required(:password, message: @password_message)
    |> validate_required(:membership_id, message: "Membership is required")
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8, max: 20, message: @password_message)
  end

  def create_user(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  def create_user(%Ecto.Changeset{} = changeset) do
    email = changeset |> Ecto.Changeset.get_field(:email)
    password = changeset |> Ecto.Changeset.get_field(:password)
    membership_id = changeset |> Ecto.Changeset.get_field(:membership_id)

    user_changeset =
      %User{}
      |> User.changeset(%{
        email: email,
        password: password,
        membership_id: membership_id
      })

    case Shop.Repo.insert(user_changeset) do
      {:ok, %User{} = user} ->
        user

      {:error, _changeset} ->
        false
    end
  end
end
