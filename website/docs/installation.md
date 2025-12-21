# Installation

## Install via Unlocked Package

<!--
 sf package version create --package "DML Lib" --target-dev-hub beyondthecloud-prod --installation-key-bypass --wait 30 --code-coverage

 sf package version promote --package "DML Lib@1.9.0-1"  --target-dev-hub beyondthecloud-prod
--> 

Install the SOQL Lib unlocked package with `btcdev` namespace to your Salesforce environment:

`/packaging/installPackage.apexp?p0=04tP6000002CeRxIAK`

[Install on Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tP6000002CeRxIAK)

[Install on Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tP6000002CeRxIAK)

## Install via Unmanaged Package

Install the DML Lib unmanaged package without namespace to your Salesforce environment:

`/packaging/installPackage.apexp?p0=04tP60000029HoT`

[Install on Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tP60000029HoT)

[Install on Production](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tP60000029HoT)

## Deploy via Button

Click the button below to deploy DML Lib to your environment.

<a href="https://githubsfdeploy.herokuapp.com?owner=beyond-the-cloud-dev&repo=dml-lib&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Copy and Deploy

**Apex**

- [`DML.cls`](https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/force-app/main/default/classes/DML.cls)
- [`DML_Test.cls`](https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/force-app/main/default/classes/DML_Test.cls)