defmodule FinancesWeb.RegisterLive do
  alias FinancesBackend.User
  use FinancesWeb, :live_view

  require Logger

  def mount(_, _session, socket) do
    {:ok, socket |> assign_user() |> assign_changeset()}
  end

  def assign_user(socket) do
    socket |> assign(:user, User.new())
  end

  def assign_changeset(%{assigns: %{user: user}} = socket) do
    changeset =
      user
      |> User.registration_changeset(%{})

    socket |> assign_form(changeset)
  end

  def assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket |> assign(:form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="create" id="user-form">
      <h1>Create a user</h1>
      <.input field={@form[:username]} label="Username"/>
      <.input field={@form[:pwd_string]} label="Password" type="password"/>
      <:actions> 
        <.button>Sign Up</.button> 
      </:actions>   
    </.simple_form>
    """
  end

  # def handle_event("validate", %{"user" => user_params}, %{assigns: %{user: user}} = socket) do
  #   changeset =
  #     user
  #     |> User.registration_changeset(user_params)
  #     |> Map.put(:action, :validate)
  #
  #   {:noreply, socket |> assign_form(changeset)}
  # end
  #
  # def handle_event("create", _unsigned_params, socket) do
  #   # todo
  #   {:noreply, socket}
  # end
end
