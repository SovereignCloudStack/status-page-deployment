#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# This script changes the old domains in the k3s environment configs
# to the new domains, suplied by domains.env.
# The script will modify the old values when run, to easily change the domains
# again, or revert the changes.

set -euo pipefail

source domains.env

grep -rl ${OLD_WEB_DOMAIN} -- ./ | xargs sed -i "s/${OLD_WEB_DOMAIN}/${WEB_DOMAIN}/g"
grep -rl ${OLD_API_DOMAIN} -- ./ | xargs sed -i "s/${OLD_API_DOMAIN}/${API_DOMAIN}/g"
grep -rl ${OLD_DEX_DOMAIN} -- ./ | xargs sed -i "s/${OLD_DEX_DOMAIN}/${DEX_DOMAIN}/g"
