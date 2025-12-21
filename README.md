<div align="center">
  <a href="https://dml.beyondthecloud.dev">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="./website/docs/public/DML-lib-logo.png">
      <img alt="SOQL Lib logo" src="./website/docs/public/DML-lib-logo.png" height="98">
    </picture>
  </a>
  <h1>DML Lib</h1>

<a href="https://beyondthecloud.dev"><img alt="Beyond The Cloud logo" src="https://img.shields.io/badge/MADE_BY_BEYOND_THE_CLOUD-555?style=for-the-badge"></a>
<a ><img alt="API version" src="https://img.shields.io/badge/api-v65.0-blue?style=for-the-badge"></a>
<a href="https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/badge/license-mit-green?style=for-the-badge"></a>

[![CI](https://github.com/beyond-the-cloud-dev/dml-lib/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/beyond-the-cloud-dev/dml-lib/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/beyond-the-cloud-dev/dml-lib/branch/main/graph/badge.svg)](https://codecov.io/gh/beyond-the-cloud-dev/dml-lib)
</div>

# Getting Started

The DML Lib provides functional constructs for DML statements in Apex.

DML Lib is part of [Apex Fluently](https://apexfluently.beyondthecloud.dev/), a suite of production-ready Salesforce libraries by [Beyond the Cloud](https://blog.beyondthecloud.dev/blog).

For more details, please refer to the [documentation](https://dml.beyondthecloud.dev).

**Insert DML**

```java
new DML()
    .toInsert(new Account(Name = 'My Account'))
    .commitWork();
```

**Update DML**

```java
Account account = [SELECT Id FROM Account LIMIT 1];

new DML()
    .toUpdate(new Account(Id = account.Id, Name = 'New Name'))
    .commitWork();
```

## Deploy to Salesforce

<a href="https://githubsfdeploy.herokuapp.com?owner=beyond-the-cloud-dev&repo=dml-lib&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Documentation

Visit the [documentation](https://dml.beyondthecloud.dev) to view the full documentation.

## Contributors

<a href="https://github.com/beyond-the-cloud-dev/dml-lib/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=beyond-the-cloud-dev/dml-lib" />
</a>


## License notes:

- For proper license management each repository should contain LICENSE file similar to this one.
- each original class should contain copyright mark: © Copyright 2025, Beyond The Cloud Sp. z o.o. (BeyondTheCloud.Dev)
