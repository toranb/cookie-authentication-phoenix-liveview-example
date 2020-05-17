defmodule Shop.Live.HelperTest do
  use ExUnit.Case, async: true

  alias Shop.Form
  alias ShopWeb.Live.Helper

  test "when password blank showing_error returns margin" do
    f = %{errors: nil}

    attrs = valid_attrs() |> Map.put("password", "")
    changeset = Form.changeset(%Form{}, attrs)

    result = Helper.showing_error(f, changeset, :password)
    assert result == "mb-6"
  end

  test "when password blank and touched showing_error returns margin" do
    f = %{errors: nil}

    attrs =
      valid_attrs()
      |> Map.put("password", "")
      |> Map.put("password_touched", true)
      |> Map.put("form_submitted", true)
      |> Map.put("action", :insert)

    changeset = Form.changeset(%Form{}, attrs)

    result = Helper.showing_error(f, changeset, :password)
    assert result == "mb-6"
  end

  @doc false
  def valid_attrs() do
    %{
      "email" => "toranb@gmail.com",
      "password" => "abcd1234",
      "membership_id" => "PERSONAL"
    }
  end
end
