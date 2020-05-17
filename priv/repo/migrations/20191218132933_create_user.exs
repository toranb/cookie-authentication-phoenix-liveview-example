defmodule Shop.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:memberships, primary_key: false) do
      add :id, :string, primary_key: true

      timestamps()
    end

    create table(:users) do
      add :email, :string, null: false
      add :hash, :string, null: false
      add :membership_id, references(:memberships, on_delete: :nothing, type: :string), null: false

      timestamps()
    end

    create index(:users, [:membership_id])
  end
end
