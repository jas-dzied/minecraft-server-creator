fabric_url := 'https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.13.3/0.10.2/server/jar'
server_folder := justfile_directory()
log := server_folder+'/utils/logger'

@_create_fabric NAME:
    {{server_folder}}/utils/logger 'info' 'Making directory'
    mkdir {{NAME}} > /dev/null 2>&1
    {{server_folder}}/utils/logger 'info' 'Downloading server JAR'
    curl -J {{fabric_url}} -o {{server_folder}}/{{NAME}}/fabric-server.jar > /dev/null 2>&1
    {{server_folder}}/utils/logger 'info' 'Generating server files'
    cd {{NAME}} && java -jar {{server_folder}}/{{NAME}}/fabric-server.jar > /dev/null 2>&1
    {{server_folder}}/utils/logger 'info' 'Accepting EULA'
    {{server_folder}}/utils/accept_eula {{server_folder}}/{{NAME}}/eula.txt
    {{server_folder}}/utils/logger 'info' 'Generating justfile'
    cp {{server_folder}}/utils/fabric_template_justfile {{server_folder}}/{{NAME}}/justfile
    {{server_folder}}/utils/logger 'success' 'Done'
@fabric NAME:
    if [[ -d test ]]; then \
      {{log}} error 'Folder "{{NAME}}" already found!'; \
    else \
      just _create_fabric {{NAME}}; \
    fi

@_create_paper NAME:
    {{log}} info 'Making directory'
    mkdir {{NAME}} > /dev/null 2>&1
    {{log}} info 'Finding newest paper build'
    {{log}} info 'Downloading paper version '$({{server_folder}}/utils/find_paper_version)
    curl $(utils/find_paper) -J -o {{server_folder}}/{{NAME}}/paper-server.jar > /dev/null 2>&1
    {{server_folder}}/utils/logger 'info' 'Generating server files'
    cd {{NAME}} && java -jar {{server_folder}}/{{NAME}}/paper-server.jar > /dev/null 2>&1
    {{server_folder}}/utils/logger 'info' 'Accepting EULA'
    {{server_folder}}/utils/accept_eula {{server_folder}}/{{NAME}}/eula.txt
    {{server_folder}}/utils/logger 'info' 'Generating justfile'
    cp {{server_folder}}/utils/paper_template_justfile {{server_folder}}/{{NAME}}/justfile
    {{server_folder}}/utils/logger 'success' 'Done'
@paper NAME:
    if [[ -d test ]]; then \
      {{log}} error 'Folder "{{NAME}}" already found!'; \
    else \
      just _create_paper {{NAME}}; \
    fi

@mods NAME FOLDER:
    {{log}} info 'Adding mods from folder {{FOLDER}}'
    cp {{FOLDER}} {{server_folder}}/{{NAME}}/mods -r
    {{log}} success 'Done'
