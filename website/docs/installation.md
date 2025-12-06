# Installation

## Install via Unlocked Package

<!--
 sf package version create --package "DML Lib" --target-dev-hub beyondthecloud-prod --installation-key-bypass --wait 30 --code-coverage

 sf package version promote --package "DML Lib@1.9.0-1"  --target-dev-hub beyondthecloud-prod
--> 

Install the SOQL Lib unlocked package with `btcdev` namespace to your Salesforce environment:

`/packaging/installPackage.apexp?p0=04tP6000002A7OrIAK`

[Install on Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tP6000002A7OrIAK)

[Install on Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tP6000002A7OrIAK)


## Install via Unmanaged Package

Install the DML Lib unmanaged package without namespace to your Salesforce environment:

`/packaging/installPackage.apexp?p0=04tP60000029Hmr`

[Install on Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tP60000029Hmr)

[Install on Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tP60000029Hmr)

## Copy and Deploy

**Apex**

- [`DML.cls`](https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/force-app/main/default/classes/DML.cls)
- [`DML_Test.cls`](https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/force-app/main/default/classes/DML_Test.cls)