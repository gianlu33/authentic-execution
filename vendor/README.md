# SGX vendor information

To run the demos with SGX nodes and modules, you need to provide:
  - A private key used to sign the modules
  - A configuration JSON file used during the Remote Attestation process, for the authentication with the Intel attestation server

## Private key

- Generate the private key with `openssl` and store it in this folder
  - Example command: `openssl genrsa -3 3072 > private_key.pem`

## SGX Remote Attestation settings

- Sign up for a Development Access account at https://api.portal.trustedservices.intel.com/EPID-attestation. Make sure that the Name Base Mode is Linkable Quote (this is all the framework supports now). Take note of "SPID", "Primary key", and "Secondary key".

- Copy the template provided here called `settings_template.json` to `settings.json` on this same folder.

- Replace the fields `spid`, `primary_subscription_key` and `secondary_subscription_key` with the values retrieved previously.

- Source code of the Remote Attestation framework used: [Github](https://github.com/ndokmai/rust-sgx-remote-attestation/tree/7e2c26930d4a87aa040b3e1d5602c61fcd5145ee)
