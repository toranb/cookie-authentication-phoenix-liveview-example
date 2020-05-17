defmodule ShopWeb.AuthenticationError do
  @moduledoc """
  Raised when the live view salt is missing
  """
  defexception [:message]
end
