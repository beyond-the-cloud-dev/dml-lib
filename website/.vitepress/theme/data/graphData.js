/**
 * Graph data for Unit of Work dependency visualization
 *
 * This module contains the complete data for visualizing how DML Lib
 * processes 17 records in 12 DML statements using dependency resolution.
 */

/**
 * 17 SObject records with their metadata
 * Each node represents a Salesforce record to be inserted/upserted
 */
export const nodes = [
  // Accounts (8 total)
  { id: 'account1', type: 'Account', operation: 'INSERT', name: 'Account 1', color: '#4ade80' },
  { id: 'account2', type: 'Account', operation: 'UPSERT', name: 'Account 2', color: '#f97316' },
  { id: 'account3', type: 'Account', operation: 'UPSERT', name: 'Account 3', color: '#94a3b8' },
  { id: 'account4', type: 'Account', operation: 'UPSERT', name: 'Account 4', color: '#78716c' },
  { id: 'account5', type: 'Account', operation: 'INSERT', name: 'Account 5', color: '#06b6d4' },
  { id: 'account6', type: 'Account', operation: 'INSERT', name: 'Account 6', color: '#22c55e' },
  { id: 'account7', type: 'Account', operation: 'INSERT', name: 'Account 7', color: '#84cc16' },
  { id: 'account8', type: 'Account', operation: 'INSERT', name: 'Account 8', color: '#4ade80' },

  // Contacts (4 total)
  { id: 'contact1', type: 'Contact', operation: 'INSERT', name: 'Contact 1', color: '#06b6d4' },
  { id: 'contact2', type: 'Contact', operation: 'INSERT', name: 'Contact 2', color: '#14b8a6' },
  { id: 'contact3', type: 'Contact', operation: 'INSERT', name: 'Contact 3', color: '#14b8a6' },
  { id: 'contact4', type: 'Contact', operation: 'INSERT', name: 'Contact 4', color: '#14b8a6' },

  // Opportunities (4 total)
  { id: 'opportunity1', type: 'Opportunity', operation: 'INSERT', name: 'Opportunity 1', color: '#a855f7' },
  { id: 'opportunity2', type: 'Opportunity', operation: 'INSERT', name: 'Opportunity 2', color: '#ec4899' },
  { id: 'opportunity3', type: 'Opportunity', operation: 'INSERT', name: 'Opportunity 3', color: '#3b82f6' },
  { id: 'opportunity4', type: 'Opportunity', operation: 'INSERT', name: 'Opportunity 4', color: '#3b82f6' },

  // Lead (1 total)
  { id: 'lead1', type: 'Lead', operation: 'INSERT', name: 'Lead 1', color: '#ef4444' }
]

/**
 * 14 dependency edges showing relationships between records
 * Each edge represents a lookup/master-detail relationship that must be resolved
 */
export const edges = [
  // Account hierarchy (ParentId relationships)
  { from: 'account2', to: 'account1', label: 'ParentId' },
  { from: 'account4', to: 'account2', label: 'ParentId' },
  { from: 'account5', to: 'account2', label: 'ParentId' },
  { from: 'account3', to: 'account5', label: 'ParentId' },
  { from: 'account6', to: 'account5', label: 'ParentId' },
  { from: 'account7', to: 'account5', label: 'ParentId' },

  // Contact relationships (AccountId lookups)
  { from: 'contact1', to: 'account2', label: 'AccountId' },
  { from: 'contact2', to: 'account3', label: 'AccountId' },
  { from: 'contact3', to: 'account6', label: 'AccountId' },
  { from: 'contact4', to: 'account6', label: 'AccountId' },

  // Opportunity relationships (AccountId lookups)
  { from: 'opportunity1', to: 'account1', label: 'AccountId' },
  { from: 'opportunity2', to: 'account4', label: 'AccountId' },
  { from: 'opportunity3', to: 'account6', label: 'AccountId' },
  { from: 'opportunity4', to: 'account6', label: 'AccountId' }
]

/**
 * 12 DML execution steps showing how records are grouped and committed
 * Despite having 17 records, DML Lib optimizes to just 12 DML statements
 */
export const dmlSteps = [
  {
    step: 1,
    operation: 'INSERT',
    sobject: 'Account',
    records: ['account1', 'account8'],
    reason: 'No dependencies, same bucket',
    description: 'Insert independent Account records with no parent references.',
    color: '#4ade80'
  },
  {
    step: 2,
    operation: 'INSERT',
    sobject: 'Lead',
    records: ['lead1'],
    reason: 'No dependencies',
    description: 'Insert Lead - completely independent, no relationships.',
    color: '#ef4444'
  },
  {
    step: 3,
    operation: 'UPSERT',
    sobject: 'Account',
    records: ['account2'],
    reason: 'Depends on account1 (ParentId)',
    description: 'Account1 has ID now, upsert account2 with ParentId reference.',
    color: '#f97316'
  },
  {
    step: 4,
    operation: 'INSERT',
    sobject: 'Opportunity',
    records: ['opportunity1'],
    reason: 'Depends on account1 (AccountId)',
    description: 'Insert opportunity1 linked to account1.',
    color: '#a855f7'
  },
  {
    step: 5,
    operation: 'UPSERT',
    sobject: 'Account',
    records: ['account4'],
    reason: 'Depends on account2 (ParentId)',
    description: 'Account2 has ID - upsert account4 as child.',
    color: '#78716c'
  },
  {
    step: 6,
    operation: 'INSERT',
    sobject: 'Account',
    records: ['account5'],
    reason: 'Depends on account2 (ParentId)',
    description: 'Insert account5 as child of account2.',
    color: '#06b6d4'
  },
  {
    step: 7,
    operation: 'INSERT',
    sobject: 'Contact',
    records: ['contact1'],
    reason: 'Depends on account2 (AccountId)',
    description: 'Insert contact1 linked to account2.',
    color: '#06b6d4'
  },
  {
    step: 8,
    operation: 'UPSERT',
    sobject: 'Account',
    records: ['account3'],
    reason: 'Depends on account5 (ParentId)',
    description: 'Account5 has ID - upsert account3 as child.',
    color: '#94a3b8'
  },
  {
    step: 9,
    operation: 'INSERT',
    sobject: 'Account',
    records: ['account6', 'account7'],
    reason: 'Depend on account5 (ParentId), same bucket',
    description: 'Insert account6, account7 - both depend on account5.',
    color: '#22c55e'
  },
  {
    step: 10,
    operation: 'INSERT',
    sobject: 'Opportunity',
    records: ['opportunity2'],
    reason: 'Depends on account4 (AccountId)',
    description: 'Insert opportunity2 linked to account4.',
    color: '#ec4899'
  },
  {
    step: 11,
    operation: 'INSERT',
    sobject: 'Contact',
    records: ['contact2', 'contact3', 'contact4'],
    reason: 'Depend on account3 and account6, same bucket',
    description: 'Insert contacts - Account dependencies resolved.',
    color: '#14b8a6'
  },
  {
    step: 12,
    operation: 'INSERT',
    sobject: 'Opportunity',
    records: ['opportunity3', 'opportunity4'],
    reason: 'Depend on account6 (AccountId), same bucket',
    description: 'Final step - opportunities linked to account6.',
    color: '#3b82f6'
  }
]
