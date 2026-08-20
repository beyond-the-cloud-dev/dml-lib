---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "DML Lib"
  text: "Apex DML Library"
  tagline: A powerful, fluent API for Salesforce DML operations with built-in mocking support
  actions:
    - theme: brand
      text: API Reference
      link: /3.1.0/dml/insert
    - theme: alt
      text: Mocking
      link: /3.1.0/mocking/insert
    - theme: alt
      text: FLS
      link: /3.1.0/configuration/field-level-security
    - theme: alt
      text: Sharing Mode
      link: /3.1.0/configuration/sharing-mode

features:
  - title: Mock DML Statements in Apex Tests
    details: Built-in mocking support lets you test your code without database operations, making tests faster and more isolated.
  - title: Comprehensive Results
    details: Get detailed operation results including success/failure status, record IDs, and error information for each DML operation.
  - title: Fluent API
    details: Chain DML operations with a clean, readable syntax. Insert, update, upsert, delete, undelete, and publish platform events.
  - title: Immediate Operations
    details: Execute single DML operations immediately and get results without needing to call commitWork().
  - title: Relationship Handling
    details: Automatically resolve parent-child relationships across inserts. No need to manually assign IDs after parent inserts.
  - title: Security Controls
    details: Full support for User/System mode and With/Without Sharing, plus field-level security stripping.
---

<BTCFooter context="dml-lib" />
