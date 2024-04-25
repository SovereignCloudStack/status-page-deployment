#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -euo pipefail

old_web_domain=status.213.131.230.142.nip.io
old_api_domain=api.213.131.230.142.nip.io
old_dex_domain=idp.213.131.230.142.nip.io

source domains.env

grep -rl ${old_web_domain} -- ./ | xargs sed -i "s/${old_web_domain}/${WEB_DOMAIN}/g"
grep -rl ${old_api_domain} -- ./ | xargs sed -i "s/${old_api_domain}/${API_DOMAIN}/g"
grep -rl ${old_dex_domain} -- ./ | xargs sed -i "s/${old_dex_domain}/${DEX_DOMAIN}/g"
