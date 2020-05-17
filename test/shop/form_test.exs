defmodule Shop.FormTest do
  use Shop.DataCase, async: false

  alias Shop.Repo
  alias Shop.Form
  alias Shop.Membership

  @email "toranb@gmail.com"
  @password "abcd1234"
  @membership "MEMBER"

  test "email is required" do
    attrs = valid_attrs() |> Map.put("email", "")
    changeset = Form.changeset(%Form{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [email: {"can't be blank", [validation: :required]}]
  end

  test "password is required" do
    attrs = valid_attrs() |> Map.put("password", "")
    changeset = Form.changeset(%Form{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [password: {"can't be blank", [validation: :required]}]
  end

  test "membership is required" do
    attrs = valid_attrs() |> Map.delete("membership_id")
    changeset = Form.changeset(%Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             membership_id: {"can't be blank", [validation: :required]}
           ]
  end

  test "changeset is invalid if email is not legit" do
    attrs = valid_attrs() |> Map.put("email", "foo")
    changeset = Form.changeset(%Form{}, attrs)
    refute changeset.valid?
    assert Map.get(changeset, :errors) == [email: {"has invalid format", [validation: :format]}]
  end

  test "changeset is invalid if password is too short" do
    attrs = valid_attrs() |> Map.put("password", "abcdefg")
    changeset = Form.changeset(%Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             password:
               {"password must be 8-20 characters",
                [count: 8, validation: :length, kind: :min, type: :string]}
           ]
  end

  test "changeset is invalid if password is too long" do
    attrs = valid_attrs() |> Map.put("password", "abcdefghijklmnopqrstu")
    changeset = Form.changeset(%Form{}, attrs)
    refute changeset.valid?

    assert Map.get(changeset, :errors) == [
             password:
               {"password must be 8-20 characters",
                [count: 20, validation: :length, kind: :max, type: :string]}
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
