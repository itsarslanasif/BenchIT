json.extract! workspace, :id, :admin_role, :bench_it_url, :capacity, :company_name, :organization_type, :workspace_type
json.image_url url_for(workspace.workspace_avatar) if workspace.workspace_avatar.attached?
