FROM ethnz/embyserver:v4.9.1.90

COPY --chown=root:root ./system/ /system/

RUN chmod 644 /system/Emby.Web.dll \
    /system/Emby.Server.Implementations.dll \
    /system/MediaBrowser.Model.dll \
    /system/dashboard-ui/modules/emby-apiclient/connectionmanager.js \
    /system/dashboard-ui/embypremiere/embypremiere.js