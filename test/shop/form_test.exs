defmodule Shop.FormTest do
  use Shop.DataCase, async: false

  alias Shop.Repo
  alias Shop.Signup
  alias Shop.Membership

  @email "toranb@gmail.com"
  @password "abcd1234"
  @membership "MEMBER"
  @password_message "Password must be between 8 and 20 characters"

  test "email is required" do
    attrs = valid_attrs() |> Map.put("email", "")
    changeset = Signup.Form.changeset(%Signup.Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             email: {"Email address is required", [validation: :required]}
           ]
  end

  test "password is required" do
    attrs = valid_attrs() |> Map.put("password", "")
    changeset = Signup.Form.changeset(%Signup.Form{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [password: {@password_message, [validation: :required]}]
  end

  test "membership is required" do
    attrs = valid_attrs() |> Map.delete("membership_id")
    changeset = Signup.Form.changeset(%Signup.Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             membership_id: {"Membership is required", [validation: :required]}
           ]
  end

  test "changeset is invalid if email is not legit" do
    attrs = valid_attrs() |> Map.put("email", "foo")
    changeset = Signup.Form.changeset(%Signup.Form{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [email: {"has invalid format", [validation: :format]}]
  end

  test "changeset is invalid if password is too short" do
    attrs = valid_attrs() |> Map.put("password", "abcdefg")
    changeset = Signup.Form.changeset(%Signup.Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             password:
               {@password_message, [count: 8, validation: :length, kind: :min, type: :string]}
           ]
  end

  test "changeset is invalid if password is too long" do
    attrs = valid_attrs() |> Map.put("password", "abcdefghijklmnopqrstu")
    changeset = Signup.Form.changeset(%Signup.Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             password:
               {@password_message, [count: 20, validation: :length, kind: :max, type: :string]}
           ]
  end

  @doc false
  def valid_attrs() do
    %{
      "email" => @email,
      "password" => @password,
      "membership_id" => @membership
    }
  end

  @doc false
  def insert_membership(id) do
    %Membership{}
    |> Membership.changeset(%{
      id: id
    })
    |> Repo.insert!()
  end
end
