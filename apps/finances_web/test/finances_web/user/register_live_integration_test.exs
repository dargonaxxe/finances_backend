defmodule FinancesWeb.User.RegisterLiveIntegrationTest do
  use FinancesWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "render" do
    test "should render", %{conn: conn} do
      {:ok, view, html} = conn |> live(~p"/registration")

      assert html =~ "<h1>Create a user</h1>"
    end
  end
end
