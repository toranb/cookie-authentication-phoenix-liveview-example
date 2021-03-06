defmodule ShopWeb.Router do
  use ShopWeb, :router

  import ShopWeb.Plug.Session, only: [redirect_unauthorized: 2, validate_session: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ShopWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :validate_session
  end

  pipeline :restricted do
    plug :browser
    plug :redirect_unauthorized
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShopWeb do
    pipe_through :browser

    get "/logout", LogoutController, :index
    live "/", PageLive, :index
    live "/signup", SignupLive, :index
    live "/login", LoginLive, :index
  end

  scope "/shop", ShopWeb do
    pipe_through :restricted

    live "/", ShopLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShopWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ShopWeb.Telemetry
    end
  end
end
