json.id workspace.id
json.admin_role workspace.admin_role
json.bench_it_url workspace.bench_it_url
json.capacity workspace.capacity
json.company_name workspace.company_name
json.image_url url_for(workspace.workspace_avatar) if workspace.workspace_avatar.attached?
json.organization_type workspace.organization_type
json.updated_at workspace.updated_at
json.workspace_type workspace.workspace_type
json.created_at workspace.created_at
