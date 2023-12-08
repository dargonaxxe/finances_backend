defmodule FinancesWeb.User.RegisterLiveIntegrationTest do
  use FinancesWeb.ConnCase
  import Phoenix.LiveViewTest

  @form_id "#user-form"
  @state_username_invalid %{user: %{username: "12345"}}
  @state_password_invalid %{user: %{pwd_string: "passpass123"}}
  @state_valid %{user: %{username: "username", pwd_string: "passpasspass"}}

  defp path do
    ~p"/registration"
  end

  describe "render" do
    test "should render", %{conn: conn} do
      {:ok, _view, html} = conn |> live(path())

      assert html =~ "<h1>Create a user</h1>"
    end
  end

  describe "edit" do
    test "should validate username when edited", %{conn: conn} do
      {:ok, view, _html} = conn |> live(path())

      assert view
             |> element(@form_id)
             |> render_change(@state_username_invalid) =~
               "should be at least 6 character(s)"
    end

    test "should validate password when edited", %{conn: conn} do
      {:ok, view, _html} = conn |> live(path())

      assert view
             |> element(@form_id)
             |> render_change(@state_password_invalid) =~
               "should be at least 12 character(s)"
    end

    test "should not show error when stuff is valid", %{conn: conn} do
      {:ok, view, _html} = conn |> live(path())

      view
      |> element(@form_id)
      |> render_change(@state_valid)
      |> Kernel.=~("should be at least")
      |> Kernel.not()
    end
  end
end
