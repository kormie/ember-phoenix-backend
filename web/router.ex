defmodule Backend.Router do
  use Backend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Backend do
    pipe_through :api # Use the default browser stack

    resources "/messages", MessageController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Backend do
  #   pipe_through :api
  # end
end
