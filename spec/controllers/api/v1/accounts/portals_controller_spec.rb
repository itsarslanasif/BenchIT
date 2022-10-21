require 'rails_helper'

RSpec.describe 'Api::V1::Accounts::Portals', type: :request do
  let(:account) { create(:account) }
  let(:agent) { create(:user, account: account, role: :agent) }
  let(:admin) { create(:user, account: account, role: :administrator) }
  let(:agent_1) { create(:user, account: account, role: :agent) }
  let(:agent_2) { create(:user, account: account, role: :agent) }
  let!(:portal) { create(:portal, slug: 'portal-1', name: 'test_portal', account_id: account.id) }

  before { create(:portal_member, user: agent, portal: portal) }

  describe 'GET /api/v1/accounts/{account.id}/portals' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}/portals"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'get all portals' do
        portal2 = create(:portal, name: 'test_portal_2', account_id: account.id, slug: 'portal-2')
        expect(portal2.id).not_to be_nil
        get "/api/v1/accounts/#{account.id}/portals",
            headers: agent.create_new_auth_token

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['payload'].length).to be 2
        expect(json_response['payload'][0]['id']).to be portal.id
      end
    end
  end

  describe 'GET /api/v1/accounts/{account.id}/portals/{portal.slug}' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}/portals"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'get one portals' do
        get "/api/v1/accounts/#{account.id}/portals/#{portal.slug}",
            headers: agent.create_new_auth_token

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq portal.name
      end
    end
  end

  describe 'POST /api/v1/accounts/{account.id}/portals' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        post "/api/v1/accounts/#{account.id}/portals",
             params: {},
             headers: agent.create_new_auth_token

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'creates portal' do
        file = fixture_file_upload(Rails.root.join('spec/assets/avatar.png'), 'image/png')

        portal_params = {
          portal: {
            name: 'test_portal',
            slug: 'test_kbase'
          },
          logo: file
        }
        post "/api/v1/accounts/#{account.id}/portals",
             params: portal_params,
             headers: admin.create_new_auth_token

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eql('test_portal')
        expect(json_response['logo']['filename']).to eql('avatar.png')
      end
    end
  end

  describe 'PUT /api/v1/accounts/{account.id}/portals/{portal.slug}' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        put "/api/v1/accounts/#{account.id}/portals/#{portal.slug}", params: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'updates portal' do
        portal_params = {
          portal: {
            name: 'updated_test_portal',
            config: { 'allowed_locales' => %w[en es] }
          }
        }

        expect(portal.name).to eql('test_portal')

        put "/api/v1/accounts/#{account.id}/portals/#{portal.slug}",
            params: portal_params,
            headers: admin.create_new_auth_token

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eql(portal_params[:portal][:name])
        expect(json_response['config']).to eql({ 'allowed_locales' => [{ 'articles_count' => 0, 'categories_count' => 0, 'code' => 'en' },
                                                                       { 'articles_count' => 0, 'categories_count' => 0, 'code' => 'es' }] })
      end

      it 'archive portal' do
        portal_params = {
          portal: {
            archived: true
          }
        }

        expect(portal.archived).to be_falsy

        put "/api/v1/accounts/#{account.id}/portals/#{portal.slug}",
            params: portal_params,
            headers: admin.create_new_auth_token

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['archived']).to eql(portal_params[:portal][:archived])

        portal.reload
        expect(portal.archived).to be_truthy
      end
    end
  end

  describe 'DELETE /api/v1/accounts/{account.id}/portals/{portal.slug}' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        delete "/api/v1/accounts/#{account.id}/portals/#{portal.slug}", params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'deletes portal' do
        delete "/api/v1/accounts/#{account.id}/portals/#{portal.slug}",
               headers: admin.create_new_auth_token
        expect(response).to have_http_status(:success)
        deleted_portal = Portal.find_by(id: portal.slug)
        expect(deleted_portal).to be_nil
      end
    end
  end

  describe 'PUT /api/v1/accounts/{account.id}/portals/{portal.slug}/add_members' do
    let(:new_account) { create(:account) }
    let(:new_agent) { create(:user, account: new_account, role: :agent) }

    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        put "/api/v1/accounts/#{account.id}/portals/#{portal.slug}/add_members", params: {}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'add members to the portal' do
        portal_params = {
          portal: {
            member_ids: [agent_1.id, agent_2.id]
          }
        }
        expect(portal.members.count).to be(1)

        put "/api/v1/accounts/#{account.id}/portals/#{portal.slug}/add_members",
            params: portal_params,
            headers: admin.create_new_auth_token

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(portal.reload.member_ids).to include(agent_1.id)
        expect(json_response['portal_members'].length).to be(3)
      end
    end
  end
end
