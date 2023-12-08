defmodule FinancesWeb.RegisterLiveTest do
  use ExUnit.Case

  alias FinancesWeb.RegisterLive
  alias FinancesBackend.User

  @incorrect_changeset %{}

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  defp create_changeset(_) do
    %{changeset: User.new() |> User.registration_changeset(%{})}
  end

  setup [:create_socket]

  describe "assign_user()" do
    test "should assign user", %{socket: socket} do
      socket
      |> RegisterLive.assign_user()
      |> assert_user_assigned()
    end
  end

  describe "assign_changeset()" do
    test "expects assign_user to be called", %{socket: socket} do
      assert_raise(FunctionClauseError, fn ->
        socket |> RegisterLive.assign_changeset()
      end)
    end

    test "should assign changeset", %{socket: socket} do
      socket
      |> RegisterLive.assign_user()
      |> assert_user_assigned()
      |> RegisterLive.assign_changeset()
      |> assert_form_assigned()
    end
  end

  describe "assign_form()" do
    setup [:create_changeset]

    test "should validate type", %{socket: socket} do
      assert_raise(FunctionClauseError, fn ->
        socket |> RegisterLive.assign_form(@incorrect_changeset)
      end)
    end

    test "should transform to form", %{socket: socket, changeset: changeset} do
      socket
      |> RegisterLive.assign_form(changeset)
      |> assert_form_assigned()
    end
  end

  defp assert_user_assigned(socket) do
    assert socket.assigns.user == %User{}
    socket
  end

  defp assert_form_assigned(socket) do
    assert %Phoenix.HTML.Form{
             id: "user",
             name: "user",
             options: [method: "post"],
             data: %User{username: nil, pwd_string: nil}
           } = socket.assigns.form
  end
end
