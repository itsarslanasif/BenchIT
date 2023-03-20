import { defineStore } from 'pinia';

export const WorkspaceStore = defineStore('workspace', {
  state: () => {
    return {
      workspace: {
        admin_role: null,
        capacity: 1,
        company_name: null,
        organization_type: null,
        workspace_avatar: null,
        bench_it_url: null,
        workspace_type: null,
      },
      capacityError: '',
      activePhase: 1,
      workspace_type_options: [
        { label: 'Work', value: 'work' },
        { label: 'School', value: 'school' },
        { label: 'Shared interest group', value: 'shared_interest' },
        { label: 'Other', value: 'other' },
      ],
      organization_type_options: [
        { label: 'Customer Goods', value: 'consumer_goods' },
        { label: 'Financial Services', value: 'financial_services' },
        { label: 'Government', value: 'government' },
        {
          label: 'Healthcare/Pharmaceutical',
          value: 'healthCare_pharmacutical',
        },
        { label: 'Media', value: 'media' },
        { label: 'Nonprofit', value: 'non_profit' },
      ],
      admin_role_options: [
        { text: 'Administrative/Facilities', value: 'administrative' },
        { text: 'Accounting/Finance', value: 'accounting' },
        { text: 'Business Development', value: 'business_development' },
        { text: 'Business Owner', value: 'business_owner' },
        { text: 'Customer Support', value: 'customer_support' },
      ],
    };
  },
});
