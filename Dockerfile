FROM emby/embyserver:4.9.4.1

COPY --chown=root:root ./system/ /system/

RUN chmod 644 /system/Emby.Web.dll \
    /system/Emby.Server.Implementations.dll \
    /system/MediaBrowser.Model.dll \
    /system/dashboard-ui/modules/emby-apiclient/connectionmanager.js \
    /system/dashboard-ui/embypremiere/embypremiere.js