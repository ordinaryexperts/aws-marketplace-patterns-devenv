# Unreleased

# 2.8.5

* Bundle `marketplace_rebrand.py`, `marketplace_rebrand_lib.py`, `marketplace_reprice.py`, and `marketplace_reprice_lib.py` from `aws-marketplace-utilities` into `/scripts` so pattern repos can run `make marketplace-rebrand` / `make marketplace-reprice` without mounting the utilities scripts dir into the container. Synced from utilities `1.10.0`.

# 2.8.4

* Fix `setup-env.sh`: integration testing tools (`pytest`, `playwright`, `boto3`, ...) were not actually being installed in the `:2.8.3` image, even though they appear in setup-env.sh. Two bugs combined:
  - `goose-ai` has no Python 3.12 release (all versions pin `<3.12`), so on Ubuntu 24.04 the bulk pip install fails atomically — none of the packages in the batch get installed, including `pytest`, `playwright`, `boto3`. Split the install: required test tools first, then optional AI dev tools (`aider-chat`, `langfuse`, `goose-ai`) in separate best-effort calls so a single failure doesn't block the batch.
  - `playwright install --with-deps chromium` then silently fails too because `--with-deps` tries to install `libasound2`, which was renamed to `libasound2t64` in Ubuntu 24.04. Now we apt-install the chromium runtime deps explicitly (with the correct `libasound2t64` name) and then run `playwright install chromium` without `--with-deps`.

  Net effect: `:2.8.4+` images will actually have a working playwright + chromium, enabling `make test-integration-ui` in pattern repos to run UI tests in the container instead of requiring a host playwright install.

# 2.8.3

* publish-template.sh and publish-diagram.sh now honor `template_bucket` and `template_pattern` from `marketplace_config.yaml` (falling back to hardcoded defaults when the file is absent). Previously the bucket was always hardcoded, which was inconsistent with marketplace.py reading the same config.

# 2.8.2

* Fix marketplace.py validate to read LogoUrl from PromotionalResources (was incorrectly checking Description)

# 2.8.1

* Adding script to manage new AWS Marketplace versions

# 2.8.0

* Upgrade CDK to 2.225.0 (was 2.120.0)
* Upgrade TaskCat to 0.9.57 (was 0.9.41)
* Upgrade packer to 1.14.3 (was 1.10.0)

# 2.7.0

* Upgrade to Ubuntu 24.04
* Add goose and aider AI tools

# 2.6.1

* Add AWS Session Manager plugin for SSM session support

# 2.6.0

* Add integration testing tools: pytest, playwright, boto3
* Remove requests downgrade workaround (incompatible with taskcat 0.9.41)

# 2.5.5

* Upgrade node.js to 20

# 2.5.4

* add publish-diagram.sh script

# 2.5.3

* fix path to supported_regions.txt

# 2.5.2

* remove eu-central-2 region due to lack of AWS::SES::EmailIdentity

# 2.5.1

* add default supported_regions.txt

# 2.5.0

* Updating pricing calcs in plf.py

# 2.4.2

* Upgrade Taskcat to 0.9.41
* Fix Taskcat / Docker issue

# 2.4.1

* Install packer amazon plugin

# 2.4.0

* Upgrade CDK to 2.120.0
* Upgrade Packer to 1.10.0
* Upgrade Taskcat to 0.9.40

# 2.3.4

* error handling improvements to packer.sh
* supported_regions.txt now is optional and has defaults

# 2.3.3

* Add args for --skip-pricing-update and --skip-region-update in plf.py

# 2.3.2

* fix git describe call in packer.sh

# 2.3.1

* plf script tweaks

# 2.3.0

* region related enhancements to scripts

# 2.2.0

* Upgrade node to 18.x
* Add scripts/differ.py
* Fix lint make command

# 2.1.4

* Update plf sheet name to match latest spreadsheet template from AWS

# 2.1.3

* Upgrade taskcat to 0.9.33

# 2.1.2

* Upgrade CDK to 2.44.0
* Upgrade Packer to 1.8.3
* Upgrade taskcat to 0.9.32

# 2.1.1

* Fix hard-coded pattern name in publish-template.sh

# 2.1.0

* Upgrade taskcat to 0.9.31
* Fix cleanup task to include empty-and-delete-bucket.py

# 2.0.0

* Upgrade to CDK 2

# 1.0.0

* Initial development
