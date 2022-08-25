FROM amazon/aws-cli
LABEL Maintainer="Sivakumar Vunnam"

RUN yum install -y -q git wget jq unzip tree && wget 'https://github.com/mikefarah/yq/releases/download/v4.9.8/yq_linux_amd64' -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq

COPY entrypoint.sh /entrypoint.sh

RUN chmod 775 /entrypoint.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
