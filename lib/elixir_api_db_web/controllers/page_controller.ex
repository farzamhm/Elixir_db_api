defmodule ElixirApiDbWeb.PageController do
  use ElixirApiDbWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
