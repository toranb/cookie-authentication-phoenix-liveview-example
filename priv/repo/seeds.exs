%Shop.Membership{} |> Shop.Membership.changeset(%{ id: "PERSONAL" }) |> Shop.Repo.insert!()
%Shop.Membership{} |> Shop.Membership.changeset(%{ id: "BUSINESS" }) |> Shop.Repo.insert!()
