FROM ghcr.io/guimaraeslucas/axonasp:2.2.3
USER root
COPY asp/ /opt/axonasp/www/
# O entrypoint original faz chown no webroot, que no Compose é somente leitura.
RUN chown -R axonasp:axonasp /opt/axonasp/www /opt/axonasp/temp
USER axonasp
ENTRYPOINT ["/opt/axonasp/axonasp-http"]
CMD []
EXPOSE 8801
