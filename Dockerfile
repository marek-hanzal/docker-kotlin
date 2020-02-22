FROM docker.leight.rocks/tools/buffalo

ENV \
    SDKMAN_DIR=/usr/local/sdkman \
    PATH="/usr/local/sdkman/candidates/kotlin/current/bin:/usr/local/sdkman/candidates/gradle/current/bin:$PATH"

USER root

RUN \
    rm /bin/sh && ln -s /bin/bash /bin/sh && \
    wget -q "https://api.bintray.com/content/jfrog/jfrog-cli-go/\$latest/jfrog-cli-linux-386/jfrog?bt_package=jfrog-cli-linux-386" -O /usr/local/bin/jfrog && \
    chmod +x /usr/local/bin/jfrog && \
    jfrog --version
RUN \
    curl -s https://get.sdkman.io | bash >/dev/null 2>&1 && \
    echo "sdkman_auto_answer=true" > ${SDKMAN_DIR}/etc/config && \
    echo "sdkman_auto_selfupdate=false" >> ${SDKMAN_DIR}/etc/config && \
    source ${SDKMAN_DIR}/bin/sdkman-init.sh && \
    sdk version && \
    sdk install kotlin >/dev/null 2>&1 && \
    sdk install gradle >/dev/null 2>&1 && \
    rm -rf ${SDKMAN_DIR}/archives
RUN \
    kotlinc -version && \
    gradle --version

COPY rootfs /
RUN chmod +x /usr/local/bin -R

WORKDIR /src

ENTRYPOINT ["dumb-init", "--"]
CMD ["kotlinc", "-version"]
