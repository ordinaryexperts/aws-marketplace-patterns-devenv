# Unreleased

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
